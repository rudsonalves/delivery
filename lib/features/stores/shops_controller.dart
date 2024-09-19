import 'package:flutter/material.dart';

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

  Future<void> editShop(BuildContext context, ShopModel client) async {
    final result = await shopRepository.getAddressesForShop(client.id!);

    if (result.isSuccess) {
      final address = result.data;

      if (address != null && address.isNotEmpty) {
        client.address = address.first;
      }
    }

    if (context.mounted) {
      await Navigator.pushNamed(
        context,
        AddShopPage.routeName,
        arguments: client,
      );
    }
  }

  Future<DataResult<void>> deleteClient(ShopModel client) async {
    return await shopRepository.delete(client.id!);
  }
}
