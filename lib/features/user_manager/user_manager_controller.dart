import 'dart:async';

import '/stores/pages/common/store_func.dart';
import '../../common/models/delivery.dart';
import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../stores/pages/user_manager_store.dart';
import '../../stores/user/user_store.dart';

class UserManagerController {
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;
  final user = locator<UserStore>();
  final app = locator<AppSettings>();
  late final UserManagerStore store;
  final deliveryRepository = DeliveriesFirebaseRepository();

  UserModel? get currentUser => user.currentUser;

  void init(UserManagerStore newStore) {
    store = newStore;
    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  void _getDeliveries() {
    store.setPageState(PageState.loading);
    _deliveriesSubscription?.cancel(); // Cancel any previus subscription
    if (store.shopId != null) {
      _deliveriesSubscription = deliveryRepository
          .getByShopId(store.shopId!)
          .listen((List<DeliveryModel> fetchedDeliveries) {
        store.setDeliveries(fetchedDeliveries);
        store.setPageState(PageState.success);
      }, onError: (err) {
        store.setError('Erro ao buscar entregas: $err');
      });
    } else {
      _deliveriesSubscription = deliveryRepository
          .getByManagerId(user.id!)
          .listen((List<DeliveryModel> fetchedDeliveries) {
        store.setDeliveries(fetchedDeliveries);
        store.setPageState(PageState.success);
      }, onError: (err) {
        store.setError('Erro ao buscar entregas: $err');
      });
    }
  }
}
