import 'package:mobx/mobx.dart';

import '../../../common/models/address.dart';
import '../../../common/models/client.dart';
import '../../../stores/common/store_func.dart';
import '/common/extensions/generic_extensions.dart';

part 'add_client_store.g.dart';

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
  String? errorZipCode;

  @observable
  AddressModel? address;

  @observable
  String? number;

  @observable
  String? errorNumber;

  @observable
  ZipStatus zipStatus = ZipStatus.initial;

  @observable
  PageState state = PageState.initial;

  @observable
  String? cpf;

  @observable
  String? errorCpfMsg;

  @observable
  String? complement;

  @observable
  bool isEdited = false;

  // reactivity to geoPoint changes - this is true if number, complement and
  // zipCode changes
  bool updateGeoPoint = false;

  // reactivity to zipcode changes - this is true only if zipCode Change
  bool zipCodeChanged = false;

  @observable
  String? errorMessage;

  @action
  void setZipCodeChanged() => zipCodeChanged = true;

  @action
  void resetZipCodeChanged() => zipCodeChanged = false;

  @action
  void setUpdateGeoPoint() => updateGeoPoint = true;

  @action
  void resetUpdateGeoPoint() => updateGeoPoint = false;

  @action
  void setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }

  @action
  void setClientFromClient(ClientModel client) {
    name = client.name;
    email = client.email;
    phone = client.phone;
    addressType = client.address?.type ?? 'Residencial';
    number = client.address?.number;
    zipCode = client.address?.zipCode;
    complement = client.address?.complement;
    zipStatus = address != null ? ZipStatus.success : ZipStatus.initial;
    isEdited = false;
    updateGeoPoint = false;
  }

  @action
  _checkIsEdited(String? value, String newValue) {
    isEdited = _isChanged(value, newValue) || isEdited;
  }

  bool _isChanged(String? value, String newValue) {
    return newValue != value;
  }

  @action
  void setAddressType(String value) {
    _checkIsEdited(addressType, value);
    addressType = value;
  }

  @action
  void setName(String value) {
    _checkIsEdited(name, value);
    name = value;
    _validName();
  }

  void _validName() {
    if (name == null || name!.length < 3) {
      errorName = 'nome deve ser maior que 3 caracteres';
    } else {
      errorName = null;
    }
  }

  @action
  void setEmail(String value) {
    _checkIsEdited(email, value);
    email = value;
    _validEmail();
  }

  @action
  bool isEmailValid() {
    _validEmail();
    return errorEmail == null;
  }

  @action
  void _validEmail() {
    errorEmail = StoreFunc.itsNotEmail(email)
        ? 'Por favor, insira um email válido'
        : null;
  }

  @action
  void setPhone(String value) {
    _checkIsEdited(phone, value);
    phone = value;
    _validPhone();
  }

  @action
  void setComplement(String value) {
    _checkIsEdited(complement, value);
    complement = value;
    setUpdateGeoPoint();
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(addressType, value);
    updateGeoPoint = updateGeoPoint || (number != value);
    number = value;
    _validNumber();
    setUpdateGeoPoint();
  }

  @action
  void setZipCode(String value) {
    _checkIsEdited(zipCode, value);
    zipCode = value;
    _validZipCode();
    if (errorZipCode == null) {
      setZipCodeChanged();
      setUpdateGeoPoint();
    }
  }

  @action
  void setZipStatus(ZipStatus status) {
    zipStatus = status;
  }

  @action
  void setErrorZipCode(String? message) {
    errorZipCode = message;
  }

  @action
  void setCpf(String value) {
    _checkIsEdited(cpf, value);
    cpf = value.onlyNumbers();
    _validCpf();
  }

  @action
  void setState(PageState status) {
    state = status;
  }

  @action
  void _validPhone() {
    final numebers = phone?.onlyNumbers() ?? '';
    if (numebers.length != 11) {
      errorPhone = 'Telephone inválido';
    } else {
      errorPhone = null;
    }
  }

  @action
  void _validNumber() {
    if (number == null || number!.isEmpty) {
      errorNumber = 'Número é obrigatório';
      return;
    }
    errorNumber = null;
  }

  @action
  void _validZipCode() {
    final numbers = zipCode?.onlyNumbers() ?? '';

    if (numbers.length == 8) {
      errorZipCode = null;
    } else {
      errorZipCode = 'CEP inválido';
    }
  }

  @action
  void _validCpf() {
    errorCpfMsg = StoreFunc.validCpf(cpf);
  }

  @action
  bool isValid() {
    _validEmail();
    _validNumber();
    _validZipCode();
    _validName();
    _validPhone();

    return errorEmail == null &&
        errorNumber == null &&
        errorZipCode == null &&
        errorName == null &&
        errorPhone == null;
  }
}