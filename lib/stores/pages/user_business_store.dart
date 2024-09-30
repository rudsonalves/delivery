import 'package:mobx/mobx.dart';

import '../../common/models/delivery.dart';
import 'common/store_func.dart';

part 'user_business_store.g.dart';

// ignore: library_private_types_in_public_api
class UserBusinessStore = _UserBusinessStore with _$UserBusinessStore;

abstract class _UserBusinessStore with Store {
  @observable
  PageState pageState = PageState.initial;

  @observable
  ObservableList<DeliveryModel> deliveries = ObservableList<DeliveryModel>();

  @observable
  String? errorMessage;

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
}
