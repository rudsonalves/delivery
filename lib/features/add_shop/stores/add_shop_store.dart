import 'package:mobx/mobx.dart';

import '../../../common/models/address.dart';
import '/common/extensions/generic_extensions.dart';
import '/common/models/shop.dart';
import '../../../stores/common/store_func.dart';

part 'add_shop_store.g.dart';

// ignore: library_private_types_in_public_api
class AddShopStore = _AddShopStore with _$AddShopStore;

abstract class _AddShopStore with Store {
  @observable
  String? name;

  @observable
  String? errorName;

  @observable
  String? description;

  @observable
  String? managerId;

  @observable
  String? managerName;

  @observable
  String? phone;

  @observable
  String? errorPhone;

  @observable
  String? addressType = 'Comercial';

  @observable
  String? zipCode;

  @observable
  String? errorZipCode;

  @observable
  String? number;

  @observable
  String? errorNumber;

  @observable
  ZipStatus zipStatus = ZipStatus.initial;

  @observable
  PageState state = PageState.initial;

  @observable
  String? complement;

  @observable
  bool isEdited = false;

  @observable
  String? errorMessage;

  @observable
  bool resetAddressString = false;

  @observable
  bool resetZipCode = false;

  @observable
  String? addressString;

  AddressModel? address;

  // This flag is true if number, complement or zipCode changes
  bool updateGeoPoint = false;

  void setUpdateGeoPoint() => updateGeoPoint = true;

  void resetUpdateGeoPoint() {
    updateGeoPoint = false;
    zipCodeChanged = false;
  }

  // This flag is true if zipCode changes
  bool zipCodeChanged = false;

  void setZipCodeChanged() => zipCodeChanged = true;

  void resetZipCodeChanged() => zipCodeChanged = false;

  void setAddress(AddressModel newAddress) {
    address = newAddress.copyWith();
  }

  @action
  setAddressString(String? value) {
    addressString = value;
  }

  @action
  toogleAddressString() {
    resetAddressString = !resetAddressString;
  }

  @action
  void setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }

  @action
  void setManager(Map<String, dynamic> manager) {
    _checkIsEdited(managerId, manager['id']);
    _checkIsEdited(managerName, manager['name']);
    managerId = manager['id'];
    managerName = manager['name'];
  }

  @action
  void setShopFromShop(ShopModel shop) {
    name = shop.name;
    phone = shop.phone;
    description = shop.description;
    managerId = shop.managerId;
    managerName = shop.managerName;
    addressType = shop.address?.type ?? 'Comercial';
    number = shop.address?.number;
    zipCode = shop.address?.zipCode;
    complement = shop.address?.complement;
    zipStatus = shop.address != null ? ZipStatus.success : ZipStatus.initial;
    isEdited = false;
    updateGeoPoint = false;
    address = shop.address?.copyWith();
  }

  @action
  void setName(String value) {
    _checkIsEdited(name, value);
    name = value;
    _validName();
  }

  @action
  setPhone(String value) {
    _checkIsEdited(phone, value);
    phone = value;
    _validPhone();
  }

  @action
  void setDescription(String value) {
    _checkIsEdited(description, value);
    description = value;
  }

  @action
  void setAddressType(String value) {
    _checkIsEdited(addressType, value);
    addressType = value;
  }

  @action
  void setComplement(String value) {
    _checkIsEdited(complement, value);
    if (complement != value) {
      complement = value;
      setUpdateGeoPoint();

      if (address != null) {
        address!.complement = value;
        setAddressString(address!.geoAddressString);
      }
    }
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(addressType, value);
    if (number != value) {
      number = value;
      setUpdateGeoPoint();

      if (address != null) {
        address!.number = value;
        _validNumber();
        setAddressString(address!.geoAddressString);
      }
    }
  }

  @action
  void setZipCode(String value) {
    _checkIsEdited(zipCode, value);
    zipCode = value;
    _validZipCode();
    if (errorZipCode == null) {
      toogleAddressString();
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
  void setState(PageState newState) {
    state = newState;
  }

  @action
  _checkIsEdited(String? value, String? newValue) {
    isEdited = value != newValue || isEdited;
  }

  @action
  void _validName() {
    errorName =
        name!.trim().length < 3 ? 'Nome dever ter 3 ou mais caracteres' : null;
  }

  @action
  void _validPhone() {
    String numbers = phone!.onlyNumbers();
    int length = numbers.length;
    String? firstDigit;
    if (length > 2) {
      firstDigit = numbers[2];
    }
    bool isPhoneNumber = (length == 10 && firstDigit != '9') ||
        (length == 11 && firstDigit == '9');
    errorPhone = !isPhoneNumber ? 'Telefone inválido' : null;
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

  bool isValid() {
    _validNumber();
    _validPhone();
    _validZipCode();
    _validName();

    return errorNumber == null &&
        errorZipCode == null &&
        errorName == null &&
        errorPhone == null;
  }
}
