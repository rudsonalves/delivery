import 'package:mobx/mobx.dart';

import '../../services/local_storage_service.dart';
import '/common/extensions/generic_extensions.dart';
import '../../common/utils/data_result.dart';
import '/common/models/shop.dart';
import '../../common/models/address.dart';
import '../../common/models/via_cep_address.dart';
import '../../locator.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../user/user_store.dart';
import 'common/store_func.dart';

part 'add_shop_store.g.dart';

// ignore: library_private_types_in_public_api
class AddShopStore = _AddShopStore with _$AddShopStore;
final repository = ShopFirebaseRepository();

abstract class _AddShopStore with Store {
  final localStore = locator<LocalStorageService>();

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
  String? complement;

  @observable
  bool isEdited = false;

  bool updateLocation = false;

  String? id;
  String? userId;

  Future<ShopModel?> getShopFromForm() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.success;
      return null;
    }

    if (address == null) {
      await _mountAddress();
    }
    if (updateLocation) {
      address!.complement = complement;
      address!.number = number!;
      await _setCoordinates();
    }
    address!.type = addressType!;

    state = PageState.success;
    return ShopModel(
      id: id,
      name: name!,
      description: description,
      ownerId: locator<UserStore>().currentUser!.id!,
      phone: phone!,
      managerId: managerId,
      managerName: managerName,
      address: address?.copyWith(),
      addressString: address?.geoAddressString,
      location: address?.location,
    );
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
    id = shop.id;
    userId = shop.ownerId;
    name = shop.name;
    phone = shop.phone;
    description = shop.description;
    managerId = shop.managerId;
    managerName = shop.managerName;
    addressType = shop.address?.type ?? 'Comercial';
    number = shop.address?.number;
    zipCode = shop.address?.zipCode;
    complement = shop.address?.complement;
    address = shop.address?.copyWith();
    zipStatus = address != null ? ZipStatus.success : ZipStatus.initial;
    isEdited = false;
    updateLocation = false;
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
  void setComplement(String value) {
    _checkIsEdited(complement, value);
    complement = value;
  }

  @action
  void setAddressType(String value) {
    _checkIsEdited(addressType, value);
    addressType = value;
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(addressType, value);
    updateLocation = updateLocation || (number != value);
    number = value;
    _validNumber();
  }

  @action
  void setZipCode(String value) {
    _checkIsEdited(zipCode, value);
    updateLocation = updateLocation || (zipCode != value);
    zipCode = value;
    _validZipCode();
    if (errorZipCode == null) _mountAddress();
  }

  @action
  void setPageState(PageState newState) {
    state = newState;
  }

  @action
  Future<void> _setCoordinates() async {
    address = await address!.updateLocation();
    updateLocation = false;
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

  @action
  Future<void> _mountAddress() async {
    zipStatus = ZipStatus.loading;

    ZipStatus status;
    String? err;
    ViaCepAddressModel? via;
    (status, err, via) = await StoreFunc.fetchAddress(zipCode);

    zipStatus = status;
    errorZipCode = err;

    if (via == null) return;

    if (updateLocation) {
      address = AddressModel(
        zipCode: via.zipCode,
        street: via.street,
        number: number ?? 'S/N',
        complement: complement,
        type: addressType ?? 'Residencial',
        neighborhood: via.neighborhood,
        location: null,
        state: via.state,
        city: via.city,
      );
    }

    zipStatus = ZipStatus.success;
  }

  @action
  Future<DataResult<ShopModel>> saveShop() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'form fields are invalid.',
        code: 550,
      ));
    }
    final shop = await getShopFromForm();
    if (shop == null) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 550,
      ));
    }
    final result = await repository.add(shop);
    state = result.isSuccess ? PageState.success : PageState.error;

    // Update local shop list
    final shops = localStore.getManagerShops();
    shops.add(shop);
    localStore.setManagerShops(shops);
    return result;
  }

  @action
  Future<DataResult<ShopModel>> updateShop() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 550,
      ));
    }
    final client = await getShopFromForm();
    if (client == null) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Shop return null.',
        code: 550,
      ));
    }
    final result = await repository.update(client);
    state = result.isSuccess ? PageState.success : PageState.error;
    return result;
  }
}
