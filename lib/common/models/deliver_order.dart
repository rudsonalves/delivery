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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'delivery.dart';

class DeliveryOrder {
  final String deliveryId;
  final String clientName;
  final String clientAddress;
  final String clientPhone;
  final GeoPoint clientLocation;

  DeliveryOrder({
    required this.deliveryId,
    required this.clientName,
    required this.clientAddress,
    required this.clientPhone,
    required this.clientLocation,
  });

  LatLng get latLng => LatLng(
        clientLocation.latitude,
        clientLocation.longitude,
      );

  factory DeliveryOrder.fromDelivery(DeliveryModel delivery) {
    return DeliveryOrder(
      deliveryId: delivery.id!,
      clientName: delivery.clientName,
      clientAddress: delivery.clientAddress,
      clientPhone: delivery.clientPhone,
      clientLocation: delivery.clientLocation.geopoint,
    );
  }
}
