import 'dart:async';

import 'package:delivery/stores/pages/common/store_func.dart';

import '../../common/models/delivery.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../stores/pages/user_business_store.dart';

class UserBusinessController {
  final UserBusinessStore store;

  UserBusinessController({
    required this.store,
  });

  final app = locator<AppSettings>();

  final deliveryRepository = DeliveriesFirebaseRepository();
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;

  String ownerId = '';

  Future<void> init(String userId) async {
    ownerId = userId;
    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  void _getDeliveries() {
    _deliveriesSubscription?.cancel(); // Cancel any previus subscriptions
    _deliveriesSubscription = deliveryRepository
        .getDeliveryByOwnerId(ownerId)
        .listen((List<DeliveryModel> fetchedDeliveries) {
      store.setDeliveries(fetchedDeliveries);
      store.setPageState(PageState.success);
    }, onError: (error) {
      store.setError('Erro ao buscar entregas: $error');
    });
  }
}
