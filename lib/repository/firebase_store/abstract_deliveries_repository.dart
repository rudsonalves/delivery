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

import '../../common/models/delivery.dart';
import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractDeliveriesRepository {
  Future<DataResult<DeliveryModel>> add(DeliveryModel delivery);
  Future<DataResult<DeliveryModel>> update(DeliveryModel delivery);
  Future<DataResult<void>> delete(String deliveryId);
  Future<DataResult<DeliveryModel?>> get(String deliveryId);
  Stream<List<DeliveryModel>> getNearby({
    required GeoPoint geopoint,
    required double radiusInKm,
  });
  Stream<List<DeliveryModel>> getByOwnerId(String ownerId);
  Future<DataResult<void>> updateManagerId(String shopId, String managerId);
  Stream<List<DeliveryModel>> getAll();
  Future<DataResult<void>> updateStatus(DeliveryModel delivery);
  Stream<List<DeliveryModel>> getByShopId({
    required String shopId,
    DeliveryStatus? status,
  });
  Stream<List<DeliveryModel>> getByManagerId({
    required String managerId,
    required DeliveryStatus status,
  });
  Future<DataResult<void>> updateDeliveryStatus({
    required UserModel user,
    required String deliveryId,
    DeliveryStatus toStatus = DeliveryStatus.orderPickedUpForDelivery,
  });
  Stream<List<DeliveryModel>> getByDeliveryId({
    required String deliveryId,
    required DeliveryStatus status,
  });
}
