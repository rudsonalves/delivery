import 'dart:developer';

import 'package:delivery/common/models/delivery.dart';
import 'package:delivery/stores/user/user_store.dart';
import 'package:mobx/mobx.dart';

import '../../common/models/client.dart';
import '../../common/models/shop.dart';
import '../../common/models/user.dart';
import '../../locator.dart';
import '../../repository/firebase_store/client_firebase_repository.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import 'common/store_func.dart';

part 'add_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class AddDeliveryStore = _AddDeliveryStore with _$AddDeliveryStore;

enum SearchMode { name, phone }

abstract class _AddDeliveryStore with Store {
  final localStore = locator<LocalStorageService>();
  final deliveryRepository = DeliveriesFirebaseRepository();
  final clientRepository = ClientFirebaseRepository();

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

  @action
  init() {
    getInLocalStore();
    state = PageState.success;
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
    if (shopId == null) {
      log('ShopId is null!');
      return;
    }

    if (selectedClient == null) {
      log('selectedClient is null!');
      return;
    }

    final client = selectedClient!;

    final shop = shops.firstWhere((shop) => shop.id == shopId);

    final user = locator<UserStore>().currentUser;

    final managerId =
        (user!.role != UserRole.manager) ? shop.managerId : user.id!;

    final delivery = DeliveryModel(
      shopId: shop.id!,
      shopName: shop.name,
      clientId: client.id!,
      clientName: client.name,
      deliveryId: null,
      deliveryName: null,
      managerId: managerId,
      deliveryDate: DateTime.now(),
      status: DeliveryStatus.orderRegisteredForPickup,
      clientAddress: client.addressString!,
      shopAddress: shop.addressString!,
      clientLocation: client.location!,
      shopLocation: shop.location!,
    );

    await deliveryRepository.add(delivery);
  }
}
