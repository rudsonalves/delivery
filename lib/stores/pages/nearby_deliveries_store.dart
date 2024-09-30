import 'package:mobx/mobx.dart';

import '/common/models/delivery.dart';
import 'common/store_func.dart';

part 'nearby_deliveries_store.g.dart';

// ignore: library_private_types_in_public_api
class NearbyDeliveriesStore = _NearbyDeliveriesStore
    with _$NearbyDeliveriesStore;

abstract class _NearbyDeliveriesStore with Store {
  @observable
  PageState pageState = PageState.initial;

  @observable
  ObservableList<DeliveryModel> deliveries = ObservableList<DeliveryModel>();

  @observable
  String? errorMessage;

  @observable
  double radiusInKm = 5.0; // Default radius

  @action
  void setPageState(PageState state) {
    pageState = state;
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

  @action
  void cleanError() {
    errorMessage = null;
    setPageState(PageState.initial);
  }

  @action
  void setRadius(double newRadius) {
    radiusInKm = newRadius;
  }
}
