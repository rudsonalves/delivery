import 'package:mobx/mobx.dart';

import '../../../common/models/shop.dart';
import '../../../stores/pages/common/store_func.dart';

part 'account_store.g.dart';

// ignore: library_private_types_in_public_api
class AccountStore = _AccountStore with _$AccountStore;

abstract class _AccountStore with Store {
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
  void setState(PageState newState) {
    state = newState;
  }

  @action
  void setShops(List<ShopModel> newShops) {
    shops = newShops;
  }
}
