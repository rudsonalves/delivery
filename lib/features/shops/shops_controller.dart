import 'dart:async';

import 'package:delivery/stores/common/store_func.dart';
import 'package:flutter/material.dart';

import '/repository/firebase_store/deliveries_firebase_repository.dart';
import '../../common/utils/data_result.dart';
import '../../repository/firebase_store/abstract_deliveries_repository.dart';
import '../../repository/firebase_store/abstract_shop_repository.dart';
import '/common/models/shop.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import 'stores/shops_store.dart';
import '../add_shop/add_shop_page.dart';

class ShopsController {
  final AbstractShopRepository shopRepository = ShopFirebaseRepository();
  final AbstractDeliveriesRepository deliveriesRepository =
      DeliveriesFirebaseRepository();

  StreamSubscription<List<ShopModel>>? _shopsSubscription;

  late final ShopsStore store;

  void init(ShopsStore newStore) {
    store = newStore;
    getShops();
  }

  void dispose() {
    _shopsSubscription?.cancel();
  }

  Future<void> getShops() async {
    store.setState(PageState.loading);
    _shopsSubscription?.cancel(); // Cancel any previous subscriptions
    _shopsSubscription = shopRepository.streamShopByName().listen(
        (List<ShopModel> fetchedShops) {
      store.setShops(fetchedShops);
      store.setState(PageState.success);
    }, onError: (err) {
      store.setError('Erro ao buscar lojas: $err');
    });
  }

  Future<void> editShop(BuildContext context, ShopModel shop) async {
    final result = await shopRepository.getAddressesForShop(shop.id!);

    final shopManagerId = shop.managerId;
    ShopModel? newShop;

    if (result.isSuccess) {
      final address = result.data;

      if (address != null && address.isNotEmpty) {
        shop.address = address.first;
      }
    }

    if (context.mounted) {
      newShop = await Navigator.pushNamed(
        context,
        AddShopPage.routeName,
        arguments: shop,
      ) as ShopModel?;
    }

    // Update shop managerId in all deliveries
    if (newShop != null && shopManagerId != newShop.managerId) {
      shop = newShop.copyWith();
      final result = await deliveriesRepository.updateManagerId(
        newShop.id!,
        newShop.managerId!,
      );

      if (result.isFailure) {
        store.setError('Ocorreu um erro. Tente mais tarde!');
      }
    }
  }

  Future<DataResult<void>> deleteClient(ShopModel client) async {
    return await shopRepository.delete(client.id!);
  }
}
