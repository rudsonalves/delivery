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
    DeliveryStatus? status,
  });
  Stream<List<DeliveryModel>> getByDeliveryId(String deliveryId);
  Future<DataResult<void>> updateDeliveryStatus({
    required UserModel user,
    required String deliveryId,
    DeliveryStatus toStatus = DeliveryStatus.orderInTransit,
  });
}
