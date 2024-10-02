import 'package:mobx/mobx.dart';

import '../../../stores/pages/common/store_func.dart';

part 'user_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class UserDeliveryStore = _UserDeliveryStore with _$UserDeliveryStore;

abstract class _UserDeliveryStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  String? errorMessage;

  @action
  void setState(PageState newState) {
    state = newState;
  }

  @action
  void setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }
}
