import 'dart:async';

import '../../common/models/delivery.dart';
import '../../managers/deliveries_manager.dart';
import 'stores/user_delivery_store.dart';

class UserDeliveryController {
  late final DeliveriesManager manager;
  late final UserDeliveryStore store;

  Future<void> init({
    required UserDeliveryStore store,
  }) async {
    this.store = store;

    manager = DeliveriesManager(store: store);

    getNearbyDeliveries();
  }

  void dispose() {
    manager.dispose();
  }

  Future<void> Function() get getNearbyDeliveries =>
      manager.getNearbyDeliveries;

  Future<void> Function() get refreshNearbyDeliveries =>
      manager.refreshNearbyDeliveries;

  Future<void> Function(DeliveryModel) get changeStatus =>
      manager.changeDeliveryStatus;

  void updateRadius(double newRadius) {
    store.setRadius(newRadius);
    refreshNearbyDeliveries();
  }
}
