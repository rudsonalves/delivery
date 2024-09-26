import 'package:mobx/mobx.dart';

part 'user_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class UserDeliveryStore = _UserDeliveryStore with _$UserDeliveryStore;

abstract class _UserDeliveryStore with Store {
  @observable
  String shopId = '';

  @action
  void setShopId(String value) {
    shopId = value;
  }
}
