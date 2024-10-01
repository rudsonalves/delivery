import 'package:mobx/mobx.dart';

import 'common/store_func.dart';

part 'shops_store.g.dart';

// ignore: library_private_types_in_public_api
class ShopsStore = _ShopsStore with _$ShopsStore;

abstract class _ShopsStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  String? errorMessage;

  @action
  setState(PageState newState) {
    state = newState;
  }

  @action
  setErrorMessage(String message) {
    errorMessage = message;
    setState(PageState.error);
  }
}
