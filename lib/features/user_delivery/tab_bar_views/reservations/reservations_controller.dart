// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';

import '../../../../common/models/delivery.dart';
import '../../../../managers/deliveries_manager.dart';
import '../../stores/user_delivery_store.dart';

class ReservationsController {
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

  Future<void> Function(DeliveryModel) get changeDeliveryStatus =>
      manager.changeDeliveryStatus;

  void updateRadius(double newRadius) {
    store.setRadius(newRadius);
    refreshNearbyDeliveries();
  }
}
