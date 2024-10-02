import 'dart:developer';

import '../../common/models/user.dart';
import '../../locator.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import 'stores/account_store.dart';
import '../../stores/pages/common/store_func.dart';
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
