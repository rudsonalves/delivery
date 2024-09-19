import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';
import '/locator.dart';
import '/common/models/shop.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../stores/pages/common/store_func.dart';
import '../../stores/pages/shops_store.dart';
import '../../stores/user/user_store.dart';
import '../add_shop/add_shop_page.dart';

class ShopsController {
  final pageStore = ShopsStore();
  final shopRepository = ShopFirebaseRepository();
  final userStore = locator<UserStore>();

  PageState get state => pageStore.state;
  bool get isAdmin => userStore.isAdmin;
  UserModel? get currentUser => userStore.currentUser;
  String accountId = '';

  void init() {}

  Future<void> editShop(BuildContext context, ShopModel shop) async {
    final result = await shopRepository.getAddressesForShop(shop.id!);

    if (result.isSuccess) {
      final address = result.data;

      if (address != null && address.isNotEmpty) {
        shop.address = address.first;
      }
    }

    if (context.mounted) {
      await Navigator.pushNamed(
        context,
        AddShopPage.routeName,
        arguments: shop,
      );
    }
  }

  Future<DataResult<void>> deleteClient(ShopModel client) async {
    return await shopRepository.delete(client.id!);
  }
}
