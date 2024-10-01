import 'package:delivery/common/models/shop.dart';
import 'package:mobx/mobx.dart';

import '../../common/models/delivery.dart';
import 'common/store_func.dart';

part 'user_manager_store.g.dart';

// ignore: library_private_types_in_public_api
class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  ObservableList<DeliveryModel> deliveries = ObservableList<DeliveryModel>();

  @observable
  String? errorMessage;

  @observable
  String? shopId;

  @observable
  List<ShopModel> shops = [];

  @action
  setShops(List<ShopModel> newShops) {
    shops = newShops;
  }

  @action
  void setPageState(PageState newState) {
    state = newState;
  }

  @action
  void setShopId(String value) {
    shopId = value;
  }

  @action
  void setDeliveries(List<DeliveryModel> newDeliveries) {
    deliveries = ObservableList<DeliveryModel>.of(newDeliveries);
  }

  @action
  void setError(String message) {
    errorMessage = message;
    setPageState(PageState.error);
  }
}
