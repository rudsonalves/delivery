import 'dart:developer';

import 'package:flutter/material.dart';

import '../../common/models/delivery.dart';
import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../../repository/firebase_store/client_firebase_repository.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import '../../stores/user/user_store.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import '../../stores/common/store_func.dart';
import '../../common/models/client.dart';
import '../../common/models/shop.dart';
import 'stores/add_delivery_store.dart';

class AddDeliveryController {
  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final nameController = TextEditingController();

  final localStore = locator<LocalStorageService>();
  final user = locator<UserStore>();
  final deliveryRepository = DeliveriesFirebaseRepository();
  final clientRepository = ClientFirebaseRepository();
  final shopRepository = ShopFirebaseRepository();

  List<ShopModel> get shops => store.shops;
  List<ClientModel> get clients => store.clients;
  ClientModel? get selectedClient => store.selectedClient;
  PageState get state => store.state;
  String? get selectedShopId => store.shopId;
  SearchMode get searchBy => store.searchBy;
  NoShopState get noShopsState => store.noShopsState;

  late final AddDeliveryStore store;

  Future<void> init(AddDeliveryStore newStore) async {
    store = newStore;

    getInLocalStore();
    if (shops.isEmpty) await refreshShops();
  }

  void dispose() {
    phoneController.dispose();
    nameController.dispose();
  }

  void getInLocalStore() {
    final shops = localStore.getManagerShops();

    if (shops.isNotEmpty) {
      store.setShops(shops);
    } else {
      refreshShops();
    }
  }

  Future<void> refreshShops() async {
    store.setState(PageState.loading);
    late final DataResult<List<ShopModel>> result;
    if (user.isBusiness) {
      result = await shopRepository.getShopByOwner(user.currentUser!.id!);
    } else if (user.isManager) {
      result = await shopRepository.getShopByManager(user.currentUser!.id!);
    }
    if (result.isFailure) {
      log('AddDeliveryStore.init: ${result.error}');
      store.setNoShopState(NoShopState.unknowError);
      return;
    }
    final shops = result.data!;
    await localStore.setManagerShops(shops);

    store.setNoShopState(NoShopState.ready);
    store.setShopId(shops.first.id!);
    store.setState(PageState.success);
  }

  Future<void> searchClientsByName(String name) async {
    store.setState(PageState.loading);
    final result = await clientRepository.getClientsByName(name);
    if (result.isFailure) {
      log('searchClientsByName: ${result.error}');
      store.setError('Ocorreu um erro. Favor tentar mais tarde.');
      return;
    }
    store.setClients(result.data!);
    store.setState(PageState.success);
  }

  Future<void> searchClentsByPhone(String phone) async {
    store.setState(PageState.loading);
    final result = await clientRepository.getClientsByPhone(phone);
    if (result.isFailure) {
      log('searchClentsByPhone: ${result.error}');
      store.setError('Ocorreu um erro. Favor tentar mais tarde.');
      return;
    }
    store.setClients(result.data!);
    store.setState(PageState.success);
  }

  Future<void> createDelivery() async {
    try {
      store.setState(PageState.loading);
      if (store.shopId == null) {
        throw Exception('ShopId is null!');
      }

      if (selectedClient == null) {
        throw Exception('selectedClient is null!');
      }

      final client = selectedClient!;

      final shop = shops.firstWhere((shop) => shop.id == store.shopId);

      final user = locator<UserStore>().currentUser;

      final managerId =
          (user!.role != UserRole.manager) ? shop.managerId : user.id!;

      final delivery = DeliveryModel(
        ownerId: shop.ownerId,
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
        clientLocation: client.geopoint,
        geopoint: shop.geopoint,
        geohash: shop.geohash,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await deliveryRepository.add(delivery);
      store.setState(PageState.success);
    } catch (err) {
      log('createDelivery: $err');
      store.setError('Ocorreu um erro. Favor tentar mais tarde.');
    }
  }
}
