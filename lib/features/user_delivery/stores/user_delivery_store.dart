import 'package:mobx/mobx.dart';

import '../../../common/models/shop_delivery_info.dart';
import '../../../stores/common/store_func.dart';

part 'user_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class UserDeliveryStore = _UserDeliveryStore with _$UserDeliveryStore;

abstract class _UserDeliveryStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  ObservableList<ShopDeliveryInfo> deliveries =
      ObservableList<ShopDeliveryInfo>();

  @observable
  String? errorMessage;

  @observable
  double radiusInKm = 5.0; // Default radius

  @action
  void setState(PageState newState) {
    state = newState;
  }

  @action
  void setDeliveries(List<ShopDeliveryInfo> newDeliveries) {
    deliveries = ObservableList<ShopDeliveryInfo>.of(newDeliveries);
  }

  @action
  void setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }

  @action
  void cleanError() {
    errorMessage = null;
    setState(PageState.initial);
  }

  @action
  void setRadius(double newRadius) {
    radiusInKm = newRadius;
  }
}
