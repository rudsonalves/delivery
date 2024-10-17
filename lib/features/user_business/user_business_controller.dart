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

import 'package:delivery/stores/common/store_func.dart';

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
