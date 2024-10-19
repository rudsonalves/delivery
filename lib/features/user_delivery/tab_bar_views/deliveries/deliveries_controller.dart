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
import 'dart:developer';

import '../../../../locator.dart';
import '../../../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../../../services/navigation_route.dart';
import '../../../../stores/user/user_store.dart';
import '/stores/common/store_func.dart';
import '../../../../common/models/delivery.dart';
import 'deliveries_store.dart';

class DeliveriesController {
  final deliveryRepository = DeliveriesFirebaseRepository();
  final user = locator<UserStore>().currentUser!;
  final navRoute = locator<NavigationRoute>();

  late final DeliveriesStore store;
  late final DeliveryStatus status;
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;

  List<DeliveryModel> get deliveries => store.deliveries.value;

  void init({
    required DeliveriesStore store,
    required DeliveryStatus status,
  }) {
    this.store = store;
    this.status = status;

    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
    _deliveriesSubscription = null;
  }

  void _getDeliveries() {
    store.setPageState(PageState.loading);
    // Cancel previus subscription
    _deliveriesSubscription?.cancel();
    _deliveriesSubscription = deliveryRepository
        .getByDeliveryId(
      deliveryId: user.id!,
      status: status,
    )
        .listen((List<DeliveryModel> fetchedDeliveries) {
      store.setPageState(PageState.loading);
      store.setDeliveries(fetchedDeliveries);
      store.setPageState(PageState.success);
    }, onError: (err) {
      store.setError('Erro ao buscar entregas: $err');
    });
  }

  Future<void> catchDeliveryById(String deliveryId) async {
    try {
      store.setPageState(PageState.loading);
      await deliveryRepository.updateDeliveryStatus(
        user: user,
        deliveryId: deliveryId,
      );
      store.setPageState(PageState.success);
    } catch (err) {
      store.setError('Erro ao buscar entregas: $err');
    }
  }

  Future<void> setDeliveriesPoints() async {
    try {
      store.setPageState(PageState.initial);
      var result = await navRoute.setDeliveries(deliveries);
      if (result.isFailure) {
        throw Exception(result.error);
      }
      // result = await navRoute.createBasicRoute();
      // if (result.isFailure) {
      //   throw Exception(result.error);
      // }
      // store.setPageState(PageState.success);
    } catch (err) {
      final message = 'createBasicRoute error: $err';
      log(message);
      store.setError('Erro na determinação de sua localização.');
    }
  }
}
