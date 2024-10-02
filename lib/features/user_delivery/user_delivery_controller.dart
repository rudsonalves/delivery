import 'stores/user_delivery_store.dart';

class UserDeliveryController {
  late final UserDeliveryStore store;

  void init(UserDeliveryStore newStore) {
    store = newStore;
  }

  void dispose() {}
}
