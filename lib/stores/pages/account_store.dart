import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../common/models/shop.dart';
import '../../locator.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../services/local_storage_service.dart';
import '../user/user_store.dart';
import 'common/store_func.dart';

part 'account_store.g.dart';

// ignore: library_private_types_in_public_api
class AccountStore = _AccountStore with _$AccountStore;

abstract class _AccountStore with Store {
  final shopRepository = ShopFirebaseRepository();
  final localStore = locator<LocalStorageService>();

  @observable
  bool showQRCode = false;

  @observable
  List<ShopModel> shops = [];

  @observable
  PageState state = PageState.initial;

  @action
  void toogleShowQRCode() {
    showQRCode = !showQRCode;
  }

  @action
  Future<void> init() async {
    getInLocalStore();
    state = PageState.success;
  }

  @action
  Future<void> getManagerShops() async {
    try {
      state = PageState.loading;
      final managerId = locator<UserStore>().id;
      if (managerId == null) {
        throw Exception('Manager id is null!');
      }

      final result = await shopRepository.getShopByManager(managerId);
      if (result.isFailure) {
        throw Exception('Repository.getShopByManager: ${result.error}');
      }
      shops = result.data!;
      await setInLocalStore();
      state = PageState.success;
    } catch (err) {
      final message = 'getManagerShops: $err';
      log(message);
      state = PageState.error;
    }
  }

  Future<void> setInLocalStore() async {
    await localStore.setManagerShops(shops);
  }

  @action
  void getInLocalStore() {
    shops = localStore.getManagerShops();
  }
}
