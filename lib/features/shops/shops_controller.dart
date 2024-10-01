import 'package:delivery/repository/firebase_store/deliveries_firebase_repository.dart';
import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';
import '../../repository/firebase_store/abstract_deliveries_repository.dart';
import '../../repository/firebase_store/abstract_shop_repository.dart';
import '/locator.dart';
import '/common/models/shop.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../stores/pages/common/store_func.dart';
import '../../stores/pages/shops_store.dart';
import '../../stores/user/user_store.dart';
import '../add_shop/add_shop_page.dart';

class ShopsController {
  final store = ShopsStore();
  final AbstractShopRepository shopRepository = ShopFirebaseRepository();
  final AbstractDeliveriesRepository deliveriesRepository =
      DeliveriesFirebaseRepository();
  final userStore = locator<UserStore>();

  PageState get state => store.state;
  bool get isAdmin => userStore.isAdmin;
  UserModel? get currentUser => userStore.currentUser;
  String accountId = '';

  void init() {}

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
        store.setErrorMessage('Ocorreu um erro. Tente mais tarde!');
      }
    }
  }

  Future<DataResult<void>> deleteClient(ShopModel client) async {
    return await shopRepository.delete(client.id!);
  }
}
