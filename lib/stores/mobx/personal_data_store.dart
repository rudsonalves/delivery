import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../repository/viacep/via_cep_repository.dart';
import 'common/store_func.dart';

part 'personal_data_store.g.dart';

// ignore: library_private_types_in_public_api
class PersonalDataStore = _PersonalDataStore with _$PersonalDataStore;

abstract class _PersonalDataStore with Store {
  @observable
  String? phone;

  @observable
  String? errorPhoneMsg;

  @observable
  String? zipCode;

  @observable
  String? errorZipCodeMsg;

  @observable
  AddressModel? address;

  @observable
  String? number;

  @observable
  String? errorNumberMsg;

  @observable
  PageState state = PageState.initial;

  @observable
  String? cpf;

  @observable
  String? errorCpfMsg;

  @action
  void setNumber(String value) {
    number = value.trim();
    _validNumber();
  }

  @action
  void _validNumber() {
    if (number == null || number!.isEmpty) {
      errorNumberMsg = 'Número é obrigatório';
      return;
    }
    errorNumberMsg = null;
  }

  @action
  void setPhone(String value) {
    phone = _removeNonNumber(value);
    _validPhone();
  }

  @action
  void _validPhone() {
    if (phone == null || phone!.length < 11) {
      errorPhoneMsg = 'Número Inválido';
      return;
    }
    errorPhoneMsg = null;
  }

  @action
  void setZipCode(String value) {
    zipCode = _removeNonNumber(value);
    _validZipCode();
  }

  @action
  void _validZipCode() {
    if (zipCode != null && zipCode!.length == 8) {
      _fetchAddress();
    } else {
      errorZipCodeMsg = 'CEP inválido';
    }
  }

  @action
  void setCpf(String value) {
    cpf = _removeNonNumber(value);
    _validCpf();
  }

  @action
  void _validCpf() {
    if (cpf == null ||
        cpf!.length != 11 ||
        RegExp(r'^(\d)\1*$').hasMatch(cpf!)) {
      errorCpfMsg = 'CPF inválido';
      return;
    }

    int digit1 = _calculateDigit(cpf!.substring(0, 9), 10);
    int digit2 = _calculateDigit(cpf!.substring(0, 10), 11);

    bool valid = digit1 == int.parse(cpf![9]) && digit2 == int.parse(cpf![10]);
    if (!valid) {
      errorCpfMsg = 'CPF inválido';
      return;
    }
    errorCpfMsg = null;
  }

  String _removeNonNumber(String value) {
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

  @action
  void _handleFetchError(String message) {
    // errorMsg = message;
    state = PageState.error;
    // log(errorMsg!);
  }

  @action
  Future<void> _fetchAddress() async {
    try {
      state = PageState.loading;

      final response = await ViaCepRepository.getLocalByCEP(zipCode!);
      if (!response.isSuccess) {
        _handleFetchError('Erro ao buscar o endereço: ${response.error}');
        errorZipCodeMsg = 'CEP inválido';
        return;
      }

      final viaAddress = response.data;
      if (viaAddress == null) {
        _handleFetchError('Endereço não encontrado');
        errorZipCodeMsg = 'CEP inválido';
        return;
      }

      address = AddressModel(
        zipCode: viaAddress.zipCode,
        street: viaAddress.street,
        number: '?',
        neighborhood: viaAddress.neighborhood,
        state: viaAddress.state,
        city: viaAddress.city,
      );

      state = PageState.success;
      errorZipCodeMsg = null;
      return;
    } catch (err) {
      _handleFetchError('erro desconhecido: $err');
      return;
    }
  }

  @action
  void cleanFields() {
    phone = null;
    errorPhoneMsg = null;
    zipCode = null;
    errorZipCodeMsg = null;
    address = null;
    number = null;
    errorNumberMsg = null;
    cpf = null;
    errorCpfMsg = null;
    // errorMsg = null;
    state = PageState.initial;
  }

  int _calculateDigit(String cpf, int factor) {
    int total = 0;
    for (int i = 0; i < cpf.length; i++) {
      total += int.parse(cpf[i]) * factor--;
    }
    int rest = total % 11;
    return (rest < 2) ? 0 : 11 - rest;
  }

  bool isValid() {
    _fetchAddress();
    _validCpf();
    _validNumber();
    _validPhone();
    _validZipCode();

    return errorCpfMsg == null &&
        errorNumberMsg == null &&
        errorPhoneMsg == null &&
        errorZipCodeMsg == null;
  }
}
