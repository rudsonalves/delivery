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

import 'dart:developer';

import '../../common/models/user.dart';
import '../../locator.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import 'stores/account_store.dart';
import '../../stores/common/store_func.dart';
import '../../stores/user/user_store.dart';

class AccountController {
  late final AccountStore store;

  final userStore = locator<UserStore>();

  final shopRepository = ShopFirebaseRepository();
  final localStore = locator<LocalStorageService>();

  UserModel? get currentUser => userStore.currentUser;

  Future<void> init(AccountStore newStore) async {
    store = newStore;
  }

  Future<void> getManagerShops() async {
    try {
      store.setState(PageState.loading);
      final managerId = locator<UserStore>().id;
      if (managerId == null) {
        throw Exception('Manager id is null!');
      }

      final result = await shopRepository.getShopByManager(managerId);
      if (result.isFailure) {
        throw Exception('Repository.getShopByManager: ${result.error}');
      }
      final shops = result.data!;
      await localStore.setManagerShops(shops);
      store.setShops(shops);
      store.setState(PageState.success);
    } catch (err) {
      final message = 'getManagerShops: $err';
      log(message);
      store.setShops([]);
      store.setState(PageState.error);
    }
  }
}
