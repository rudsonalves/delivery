import 'package:mobx/mobx.dart';

import '../../../common/models/shop.dart';
import '../../../stores/common/store_func.dart';

part 'shops_store.g.dart';

// ignore: library_private_types_in_public_api
class ShopsStore = _ShopsStore with _$ShopsStore;

abstract class _ShopsStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  String? errorMessage;

  @observable
  ObservableList<ShopModel> shops = ObservableList<ShopModel>();

  @action
  setState(PageState newState) {
    state = newState;
  }

  @action
  void setShops(List<ShopModel> newShops) {
    shops = ObservableList<ShopModel>.of(newShops);
  }

  @action
  setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }
}
