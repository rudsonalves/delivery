// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';

import 'package:flutter/material.dart';

import '/common/models/user.dart';
import '/locator.dart';
import '/stores/common/store_func.dart';
import '../../stores/user/user_store.dart';
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

  final user = locator<UserStore>().currentUser;

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

    switch (user?.role) {
      case UserRole.admin:
        _shopsSubscription = shopRepository.streamShopAll().listen(
            (List<ShopModel> fetchedShops) {
          store.setShops(fetchedShops);
          store.setState(PageState.success);
        }, onError: (err) {
          store.setError('Erro ao buscar lojas: $err');
        });
        return;
      case UserRole.business:
        _shopsSubscription = shopRepository.streamShopByOwner(user!.id!).listen(
            (List<ShopModel> fetchedShops) {
          store.setShops(fetchedShops);
          store.setState(PageState.success);
        }, onError: (err) {
          store.setError('Erro ao buscar lojas: $err');
        });
        return;
      case UserRole.manager:
        _shopsSubscription = shopRepository
            .streamShopByManager(user!.id!)
            .listen((List<ShopModel> fetchedShops) {
          store.setShops(fetchedShops);
          store.setState(PageState.success);
        }, onError: (err) {
          store.setError('Erro ao buscar lojas: $err');
        });
        return;
      case UserRole.delivery:
      case null:
        return;
    }
  }

  Future<void> addShop() async {}

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
