import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../repository/viacep/via_cep_repository.dart';
import 'common/generic_functions.dart';

part 'add_client_store.g.dart';

enum Status { initial, loading, success, error }

// ignore: library_private_types_in_public_api
class AddClientStore = _AddClientStore with _$AddClientStore;

abstract class _AddClientStore with Store {
  @observable
  String? name;

  @observable
  String? errorName;

  @observable
  String? email;

  @observable
  String? errorEmail;

  @observable
  String? phone;

  @observable
  String? errorPhone;

  @observable
  String? addressType = 'Residencial';

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
  Status status = Status.initial;

  @observable
  String? cpf;

  @observable
  String? errorCpfMsg;

  @observable
  String? complement;

  @action
  void setComplement(String value) {
    complement = value;
    _updateAddress();
  }

  @action
  void setAddressType(String value) {
    addressType = value;
    _updateAddress();
  }

  @action
  void setName(String value) {
    name = value;
    _validateName();
  }

  void _validateName() {
    if (name == null || name!.length < 3) {
      errorName = 'nome deve ser maior que 3 caracteres';
    } else {
      errorName = null;
    }
  }

  @action
  void setEmail(String value) {
    email = value;
    _validateEmail();
  }

  @action
  bool isEmailValid() {
    _validateEmail();
    return errorEmail == null;
  }

  @action
  void _validateEmail() {
    errorEmail = StoreFunc.itsNotEmail(email)
        ? 'Por favor, insira um email válido'
        : null;
  }

  @action
  void setPhone(String value) {
    phone = value;
    _validatePhone();
  }

  @action
  void _validatePhone() {
    final numebers = _removeNonNumber(phone);
    if (numebers.length != 11) {
      errorPhone = 'Telephone inválido';
    } else {
      errorPhone = null;
    }
  }

  @action
  void setNumber(String value) {
    number = value.trim();
    _validNumber();
    _updateAddress();
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

  int _calculateDigit(String cpf, int factor) {
    int total = 0;
    for (int i = 0; i < cpf.length; i++) {
      total += int.parse(cpf[i]) * factor--;
    }
    int rest = total % 11;
    return (rest < 2) ? 0 : 11 - rest;
  }

  String _removeNonNumber(String? value) {
    return value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
  }

  @action
  Future<void> _fetchAddress() async {
    try {
      status = Status.loading;

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
        number: number ?? 'S/N',
        complement: complement ?? '',
        type: addressType ?? 'Residencial',
        neighborhood: viaAddress.neighborhood,
        state: viaAddress.state,
        city: viaAddress.city,
      );

      status = Status.success;
      errorZipCodeMsg = null;
      return;
    } catch (err) {
      _handleFetchError('erro desconhecido: $err');
      return;
    }
  }

  @action
  _updateAddress() {
    if (address != null) {
      address = address!.copyWith(
        number: number ?? 'S/N',
        complement: complement ?? '',
      );
    }
  }

  @action
  void _handleFetchError(String message) {
    // errorMsg = message;
    status = Status.error;
    // log(errorMsg!);
  }
}