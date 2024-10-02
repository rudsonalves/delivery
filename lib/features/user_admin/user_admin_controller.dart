import 'dart:async';

import '../../common/models/delivery.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../stores/pages/common/store_func.dart';
import '../../stores/pages/user_admin_store.dart';

class UserAdminController {
  late final UserAdminStore store;

  final app = locator<AppSettings>();

  final deliveryRepository = DeliveriesFirebaseRepository();
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;

  Future<void> init(UserAdminStore newStore) async {
    store = newStore;

    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  void _getDeliveries() {
    store.setPageState(PageState.loading);
    _deliveriesSubscription?.cancel(); // Cancel any previus subscriptions
    _deliveriesSubscription = deliveryRepository.getAll().listen(
        (List<DeliveryModel> fetchedDeliveries) {
      store.setDeliveries(fetchedDeliveries);
      store.setPageState(PageState.success);
    }, onError: (error) {
      store.setError('Erro ao buscar entregas: $error');
    });
  }
}
