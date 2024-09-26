import 'package:mobx/mobx.dart';

part 'user_manager_store.g.dart';

// ignore: library_private_types_in_public_api
class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  @observable
  String shopId = '';

  @action
  void setShopId(String value) {
    shopId = value;
  }
}
