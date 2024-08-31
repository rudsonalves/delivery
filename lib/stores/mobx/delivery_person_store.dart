import 'package:mobx/mobx.dart';

import '../../common/models/adreess.dart';
import '../../repository/viacep/via_cep_repository.dart';

part 'delivery_person_store.g.dart';

enum Status { initial, loading, success, error }

// ignore: library_private_types_in_public_api
class DeliveryPersonStore = _DeliveryPersonStore with _$DeliveryPersonStore;

abstract class _DeliveryPersonStore with Store {
  @observable
  String? name;

  @observable
  String? errorNameMsg;

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
  Status status = Status.initial;

  @observable
  String? cpf;

  @observable
  String? errorCpfMsg;

  @observable
  String? password;

  @observable
  String? errorPasswordMsg;

  @observable
  String? errorCheckPasswordMsg;

  @observable
  String? checkPassword;

  @observable
  String? email;

  @observable
  String? errorEmailMsg;

  @action
  void setName(String value) {
    name = value.trim();
    _validName();
  }

  @action
  void _validName() {
    if (name == null || name!.isEmpty) {
      errorNameMsg = 'Nome é obrigatório';
      return;
    }
    errorNameMsg = null;
  }

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
  void setPassword(String value) {
    password = value;
    _validPassword();
  }

  @action
  void _validPassword() {
    if (password == null || password!.length < 6) {
      errorPasswordMsg = 'Senha menor que 6 caracteres';
      return;
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');
    if (!regex.hasMatch(password!)) {
      errorPasswordMsg = 'Senha deve conter números e letras';
      return;
    }
    errorPasswordMsg = null;
  }

  @action
  void setCheckPassword(String value) {
    checkPassword = value.trim();
    _validCheckPassword();
  }

  @action
  void _validCheckPassword() {
    if (password == null || password != checkPassword) {
      errorCheckPasswordMsg = 'Senhas diferem';
      return;
    }
    errorCheckPasswordMsg = null;
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
  void setEmail(String value) {
    email = value;
    validEmail();
  }

  @action
  void validEmail() {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email == null || email!.isEmpty || !regex.hasMatch(email!)) {
      errorEmailMsg = 'E-mail válido';
      return;
    }
    errorEmailMsg = null;
  }

  @action
  void setCpf(String value) {
    cpf = _removeNonNumber(value);
    _validCpf();
  }

  @action
  void _validCpf() {
    if (cpf!.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf!)) {
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
    status = Status.error;
    // log(errorMsg!);
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
        number: '?',
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
  void cleanFields() {
    name = null;
    errorNameMsg = null;
    phone = null;
    errorPhoneMsg = null;
    zipCode = null;
    errorZipCodeMsg = null;
    address = null;
    number = null;
    errorNumberMsg = null;
    cpf = null;
    errorCpfMsg = null;
    password = null;
    errorPasswordMsg = null;
    errorCheckPasswordMsg = null;
    email = null;
    errorEmailMsg = null;
    // errorMsg = null;
    status = Status.initial;
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
    _validName();
    _validCpf();
    _validNumber();
    _validPassword();
    _validPhone();
    _validZipCode();
    _validCheckPassword();

    return errorCheckPasswordMsg == null &&
        errorCpfMsg == null &&
        errorEmailMsg == null &&
        errorNameMsg == null &&
        errorNumberMsg == null &&
        errorPasswordMsg == null &&
        errorPhoneMsg == null &&
        errorZipCodeMsg == null;
  }
}
