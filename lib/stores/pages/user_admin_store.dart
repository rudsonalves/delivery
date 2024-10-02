import 'package:mobx/mobx.dart';

import '../../common/models/delivery.dart';
import 'common/store_func.dart';

part 'user_admin_store.g.dart';

// ignore: library_private_types_in_public_api
class UserAdminStore = _UserAdminStore with _$UserAdminStore;

abstract class _UserAdminStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  ObservableList<DeliveryModel> deliveries = ObservableList<DeliveryModel>();

  @observable
  String? errorMessage;

  @action
  void setPageState(PageState newState) {
    state = newState;
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
