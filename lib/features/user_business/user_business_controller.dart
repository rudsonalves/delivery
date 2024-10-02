import 'dart:async';

import 'package:delivery/stores/pages/common/store_func.dart';

import '../../common/models/delivery.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import 'stores/user_business_store.dart';

class UserBusinessController {
  late final UserBusinessStore store;

  final app = locator<AppSettings>();

  final deliveryRepository = DeliveriesFirebaseRepository();
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;

  String ownerId = '';

  Future<void> init(UserBusinessStore newStore, String userId) async {
    store = newStore;

    ownerId = userId;
    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  void _getDeliveries() {
    store.setState(PageState.loading);
    _deliveriesSubscription?.cancel(); // Cancel any previus subscriptions
    _deliveriesSubscription = deliveryRepository.getByOwnerId(ownerId).listen(
        (List<DeliveryModel> fetchedDeliveries) {
      store.setDeliveries(fetchedDeliveries);
      store.setState(PageState.success);
    }, onError: (error) {
      store.setError('Erro ao buscar entregas: $error');
    });
  }
}
