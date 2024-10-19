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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../common/models/deliver_order.dart';
import '../common/models/delivery.dart';
import '../common/utils/data_result.dart';
import 'geo_location.dart';

class NavigationRoute {
  final Map<String, DeliveryOrder> deliveries = {};
  GeoPoint? _startLocation;
  final List<String> orderIds = [];

  GeoPoint get start => _startLocation!;
  LatLng get startLatLng => LatLng(
        _startLocation!.latitude,
        _startLocation!.longitude,
      );

  void reversedOrder() {
    final reversedOrder = orderIds.reversed.toList();
    orderIds.clear();
    orderIds.addAll(reversedOrder);
  }

  void swapOrderIds(int index0, int index1) {
    final value0 = orderIds[index0];
    orderIds[index0] = orderIds[index1];
    orderIds[index1] = value0;
  }

  Future<DataResult<void>> setDeliveries(List<DeliveryModel> deliveries) async {
    try {
      this.deliveries.clear();
      this.deliveries.addEntries(
            deliveries.map(
              (delivery) =>
                  MapEntry(delivery.id!, DeliveryOrder.fromDelivery(delivery)),
            ),
          );

      _startLocation = (await GeoLocation.getCurrentGeoFirePoint()).geopoint;

      return DataResult.success(null);
    } catch (err) {
      final message = 'NavigationRoute.setDeliveries error: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  Future<DataResult<void>> createBasicRoute() async {
    try {
      if (_startLocation == null) {
        return DataResult.failure(const GenericFailure(
          message: 'Não foi possível obter a sua localização atual',
        ));
      }
      final Set<String> ids = deliveries.keys.toSet();

      final id = _getMinorDistance(ids, _startLocation!);

      orderIds.clear();
      ids.remove(id);
      orderIds.add(id);
      GeoPoint start = deliveries[id]!.clientLocation;

      while (ids.isNotEmpty) {
        final nextId = _getMinorDistance(ids, start);
        ids.remove(nextId);
        orderIds.add(nextId);
        start = deliveries[nextId]!.clientLocation;
      }

      return DataResult.success(null);
    } catch (err) {
      final message = 'NavigationRoute.createBasicRoute error: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  String _getMinorDistance(Set<String> ids, GeoPoint start) {
    double shortDistance = 999999;
    String shortDistanceId = '';
    for (final id in ids) {
      final distance = GeoLocation.calculateDistance(
        start,
        deliveries[id]!.clientLocation,
      );

      if (distance < shortDistance) {
        shortDistance = distance;
        shortDistanceId = id;
      }
    }

    return shortDistanceId;
  }
}
