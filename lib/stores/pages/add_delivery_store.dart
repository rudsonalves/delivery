import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../common/utils/geo_point_funcs.dart';
import '/common/models/delivery.dart';
import '/stores/user/user_store.dart';
import '../../common/models/client.dart';
import '../../common/models/shop.dart';
import '../../common/models/user.dart';
import '../../locator.dart';
import '../../repository/firebase_store/client_firebase_repository.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import 'common/store_func.dart';
import '/repository/firebase_store/shop_firebase_repository.dart';

part 'add_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class AddDeliveryStore = _AddDeliveryStore with _$AddDeliveryStore;

enum SearchMode { name, phone }

enum NoShopState { unknowError, noShops, ready, waiting }

abstract class _AddDeliveryStore with Store {
  final localStore = locator<LocalStorageService>();
  final deliveryRepository = DeliveriesFirebaseRepository();
  final clientRepository = ClientFirebaseRepository();
  final shopRepository = ShopFirebaseRepository();

  @observable
  List<ShopModel> shops = [];

  @observable
  List<ClientModel> clients = [];

  @observable
  PageState state = PageState.initial;

  @observable
  String? shopId;

  @observable
  ClientModel? selectedClient;

  @observable
  SearchMode searchBy = SearchMode.phone;

  @observable
  NoShopState noShopsState = NoShopState.ready;

  @action
  Future<void> init() async {
    noShopsState = NoShopState.waiting;
    getInLocalStore();
    if (shops.isEmpty) {
      final result = await shopRepository
          .getShopByManager(locator<UserStore>().currentUser!.id!);
      if (result.isFailure) {
        log('AddDeliveryStore.init: ${result.error}');
        noShopsState = NoShopState.unknowError;
        return;
      }
      shops = result.data!;
      if (shops.isEmpty) {
        noShopsState = NoShopState.noShops;
        return;
      }
      // save shops in local store
      await localStore.setManagerShops(shops);
    }
    noShopsState = NoShopState.ready;
    state = PageState.success;
    shopId = shops.first.id;
  }

  @action
  void getInLocalStore() {
    shops = localStore.getManagerShops();
  }

  @action
  void setShopId(String value) {
    shopId = value;
  }

  @action
  void toogleSearchBy() {
    searchBy = searchBy == SearchMode.name ? SearchMode.phone : SearchMode.name;
  }

  @action
  Future<void> searchClientsByName(String name) async {
    state = PageState.loading;
    final result = await clientRepository.getClientsByName(name);
    if (result.isFailure) {
      log('searchClientsByName: ${result.error}');
      state = PageState.error;
      return;
    }
    clients = result.data!;
    state = PageState.success;
  }

  @action
  Future<void> searchClentsByPhone(String phone) async {
    state = PageState.loading;
    final result = await clientRepository.getClientsByPhone(phone);
    if (result.isFailure) {
      log('searchClentsByPhone: ${result.error}');
      state = PageState.error;
      return;
    }
    clients = result.data!;
    state = PageState.success;
  }

  @action
  void selectClient(ClientModel client) {
    selectedClient = client;
    log(selectedClient!.id ?? '');
  }

  Future<void> createDelivery() async {
    try {
      if (shopId == null) {
        throw Exception('ShopId is null!');
      }

      if (selectedClient == null) {
        throw Exception('selectedClient is null!');
      }

      final client = selectedClient!;

      final shop = shops.firstWhere((shop) => shop.id == shopId);

      final user = locator<UserStore>().currentUser;

      final managerId =
          (user!.role != UserRole.manager) ? shop.managerId : user.id!;

      final geoPonitHash = createGeoPointHash(shop.location!);

      final delivery = DeliveryModel(
        shopId: shop.id!,
        shopName: shop.name,
        shopPhone: shop.phone,
        clientId: client.id!,
        clientName: client.name,
        clientPhone: client.phone,
        deliveryId: null,
        deliveryName: null,
        managerId: managerId,
        status: DeliveryStatus.orderRegisteredForPickup,
        clientAddress: client.addressString!,
        shopAddress: shop.addressString!,
        clientLocation: client.location!,
        location: shop.location!,
        geoHash: geoPonitHash,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await deliveryRepository.add(delivery);
    } catch (err) {
      log('createDelivery: $err');
    }
  }
}
