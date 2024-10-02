import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../common/models/via_cep_address.dart';
import '../../locator.dart';
import '../../repository/firebase_store/abstract_shop_repository.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import '../../stores/user/user_store.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import '../../common/models/shop.dart';
import '../../common/utils/data_result.dart';
import '../../stores/pages/common/store_func.dart';
import 'stores/add_shop_store.dart';

class AddShopController {
  late final AddShopStore store;
  final localStore = locator<LocalStorageService>();
  final AbstractShopRepository repository = ShopFirebaseRepository();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final cepController = MaskedTextController(mask: '##.###-###');
  final numberController = TextEditingController();
  final complementController = TextEditingController();

  bool get isEdited => store.isEdited;
  bool get isValid => store.isValid();
  PageState get state => store.state;

  ShopModel? shop;
  AddressModel? address;
  ReactionDisposer? _disposer;

  void init(AddShopStore newStore, ShopModel? editShop) {
    store = newStore;

    if (editShop != null) {
      shop = editShop.copyWith();
      _setShopValues();
    }

    _disposer = reaction<bool>(
      (_) => store.mountAddress,
      (valor) {
        if (valor) {
          _mountAddress();
          store.resetMountAddress();
        }
      },
    );
  }

  void _setShopValues() {
    store.setShopFromShop(shop!);

    nameController.text = shop!.name;
    phoneController.text = shop!.phone;
    descriptionController.text = shop!.description ?? '';
    store.addressType = shop!.address?.type ?? 'Comercial';
    cepController.text = shop!.address?.zipCode ?? '';
    numberController.text = shop!.address?.number ?? '';
    complementController.text = shop!.address?.complement ?? '';
    address = shop!.address;
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cepController.dispose();
    numberController.dispose();
    complementController.dispose();
    descriptionController.dispose();
    _disposer?.call();
  }

  Future<ShopModel?> getShopFromForm() async {
    store.setState(PageState.loading);
    if (!store.isValid()) {
      store.setError('Verifique os campos obrigatórios (*) do formulário.');
      return null;
    }

    if (address == null) {
      await _mountAddress();
    }
    if (store.updateLocation) {
      address!.complement = store.complement;
      address!.number = store.number!;
      await _setCoordinates();
    }
    address!.type = store.addressType!;

    store.setState(PageState.success);
    return ShopModel(
      id: shop?.id,
      name: store.name!,
      description: store.description,
      ownerId: locator<UserStore>().currentUser!.id!,
      phone: store.phone!,
      managerId: store.managerId,
      managerName: store.managerName,
      address: address?.copyWith(),
      addressString: address?.geoAddressString,
      location: address?.location,
    );
  }

  Future<void> _setCoordinates() async {
    address = await address!.updateLocation();
    store.resetUpdateLocation();
  }

  Future<void> _mountAddress() async {
    store.setZipStatus(ZipStatus.loading);

    ZipStatus status;
    String? err;
    ViaCepAddressModel? via;
    (status, err, via) = await StoreFunc.fetchAddress(store.zipCode);

    store.setZipStatus(status);
    store.setErrorZipCode(err);

    if (via == null) return;

    if (store.updateLocation) {
      address = AddressModel(
        id: address?.id,
        type: store.addressType ?? 'Residencial',
        zipCode: via.zipCode,
        street: via.street,
        number: store.number ?? 'S/N',
        complement: store.complement,
        neighborhood: via.neighborhood,
        state: via.state,
        city: via.city,
        location: null,
        updatedAt: DateTime.now(),
      );
    }

    store.setZipStatus(ZipStatus.success);
  }

  Future<DataResult<ShopModel>> saveShop() async {
    store.setState(PageState.loading);
    if (!store.isValid()) {
      store.setError('Preencha os campos obrigatórios (*) do formulário.');
      return DataResult.failure(const GenericFailure(
        message: 'form fields are invalid.',
        code: 550,
      ));
    }
    ShopModel? newShop = await getShopFromForm();
    if (newShop == null) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 550,
      ));
    }
    final result = await repository.add(newShop);
    if (result.isFailure) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(GenericFailure(
        message: 'Unexpected error: ${result.error.toString()}',
        code: 551,
      ));
    }

    // Update local shop list
    newShop = result.data!;
    await _addToLocalShopList(newShop);
    shop = newShop;
    store.setState(PageState.success);
    return result;
  }

  Future<void> _addToLocalShopList(ShopModel shop) async {
    final shops = localStore.getManagerShops();
    shops.add(shop);
    await localStore.setManagerShops(shops);
  }

  Future<DataResult<ShopModel>> updateShop() async {
    store.setState(PageState.loading);
    if (!store.isValid()) {
      store.setError('Preencha os campos obrigatórios (*) do formulário.');
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 550,
      ));
    }
    ShopModel? newShop = await getShopFromForm();
    if (newShop == null) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Shop return null.',
        code: 550,
      ));
    }
    final result = await repository.update(newShop);

    if (result.isFailure) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(GenericFailure(
        message: 'Unexpected error: ${result.error.toString()}',
        code: 551,
      ));
    }

    // Update local shop list
    newShop = result.data!;
    await _updateLocalShopList(newShop);
    shop = newShop;
    store.setState(PageState.success);

    return result;
  }

  Future<void> _updateLocalShopList(ShopModel shop) async {
    final shops = localStore.getManagerShops();
    final index = shops.indexWhere((s) => s.id == shop.id);
    if (index == -1) {
      throw const ExactAssetImage('_updateLocalShopList returned -1 index');
    }
    shops[index] = shop;
    await localStore.setManagerShops(shops);
  }
}
