import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/models/delivery.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractDeliveriesRepository {
  Future<DataResult<DeliveryModel>> add(DeliveryModel delivery);
  Future<DataResult<DeliveryModel>> update(DeliveryModel delivery);
  Future<DataResult<DeliveryModel>> updateStatus(DeliveryStatus deliveryStatus);
  Future<DataResult<void>> delete(String deliveryId);
  Future<DataResult<DeliveryModel?>> get(String deliveryId);
  Stream<List<DeliveryModel>> getByShopId(String shopId);
  Stream<List<DeliveryModel>> streamShopByName();
  Stream<List<DeliveryModel>> getNearby({
    required GeoPoint location,
    required double radiusInKm,
  });
  Stream<List<DeliveryModel>> getByOwnerId(String ownerId);
  Stream<List<DeliveryModel>> getByManagerId(String managerId);
  Future<DataResult<void>> updateManagerId(String shopId, String managerId);
  Stream<List<DeliveryModel>> getAll();
}
