import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../common/utils/data_result.dart';
import '/common/models/shop.dart';
import '../../common/models/address.dart';
import '../../common/models/via_cep_address.dart';
import '../../locator.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../services/geolocation_service.dart';
import '../user/user_store.dart';
import 'common/store_func.dart';

part 'add_shop_store.g.dart';

// ignore: library_private_types_in_public_api
class AddShopStore = _AddShopStore with _$AddShopStore;
final repository = ShopFirebaseRepository();

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

  String? id;
  String? userId;

  @action
  void setManager(Map<String, dynamic> manager) {
    _checkIsEdited(managerId, manager['id']);
    _checkIsEdited(managerName, manager['name']);
    managerId = manager['id'];
    managerName = manager['name'];
  }

  Future<ShopModel?> getShopFromForm() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.success;
      return null;
    }

    if (address != null) {
      if (address!.latitude == null || address!.longitude == null) {
        await _setCoordinates();
      }

      state = PageState.success;
      return ShopModel(
        id: id,
        userId: locator<UserStore>().currentUser!.id!,
        name: name!,
        description: description,
        managerId: managerId,
        managerName: managerName,
        address: address,
      );
    }
    return null;
  }

  @action
  void setShopFromShop(ShopModel shop) {
    id = shop.id;
    userId = shop.userId;
    name = shop.name;
    description = shop.description;
    managerId = shop.managerId;
    managerName = shop.managerName;
    address = shop.address;
    zipCode = shop.address?.zipCode;
    number = shop.address?.number;
    complement = shop.address?.complement;
    zipStatus = address != null ? ZipStatus.success : ZipStatus.initial;
    isEdited = false;
  }

  @action
  _checkIsEdited(String? value, String? newValue) {
    isEdited = value != newValue;
  }

  @action
  void setName(String value) {
    _checkIsEdited(name, value);
    name = value;
    _validName();
  }

  @action
  void _validName() {
    errorName =
        name!.trim().length < 3 ? 'Nome dever ter 3 ou mais caracteres' : null;
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
    _updateAddress();
  }

  @action
  void setAddressType(String value) {
    _checkIsEdited(addressType, value);
    addressType = value;
    _updateAddress();
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(addressType, value);
    number = value;
    _validName();
    _updateAddress();
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
  void setZipCode(String value) {
    _checkIsEdited(zipCode, value);
    zipCode = value;
    _validZipCode();
    if (errorZipCode == null) _mountAddress();
  }

  @action
  void _validZipCode() {
    final numbers = StoreFunc.removeNonNumber(zipCode ?? '');

    if (numbers.length == 8) {
      errorZipCode = null;
    } else {
      errorZipCode = 'CEP inválido';
    }
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

    address = AddressModel(
      zipCode: via.zipCode,
      street: via.street,
      number: number ?? '',
      complement: complement,
      type: addressType ?? 'Comercial',
      neighborhood: via.neighborhood,
      latitude: null,
      longitude: null,
      state: via.state,
      city: via.city,
    );

    if (address!.isValidAddress) {
      await _setCoordinates();
    }
    zipStatus = ZipStatus.success;
  }

  @action
  Future<void> _updateAddress() async {
    if (address != null) {
      final updateCoordinates =
          number != null && number!.isNotEmpty && address!.number != number;
      address = address!.copyWith(
        number: number,
        complement: complement,
      );
      if (updateCoordinates && address!.isValidAddress) {
        await _setCoordinates();
      }
    }
  }

  @action
  Future<void> _setCoordinates() async {
    final result =
        await GeolocationServiceGoogle.getCoordinatesFromAddress(address!);
    if (result.isFailure || result.data == null) {
      log('Get coordenate API error!');
      return;
    }
    address = result.data;
  }

  @action
  void setPageState(PageState newState) {
    state = newState;
  }

  bool isValid() {
    _validNumber();
    _validZipCode();
    _validName();

    return errorNumber == null && errorZipCode == null && errorName == null;
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
