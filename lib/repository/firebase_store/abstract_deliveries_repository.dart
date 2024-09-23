import '../../common/models/delivery.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractDeliveriesRepository {
  Future<DataResult<DeliveryModel>> add(DeliveryModel delivery);
  Future<DataResult<DeliveryModel>> update(DeliveryModel delivery);
  Future<DataResult<DeliveryModel>> updateStatus(DeliveryStatus deliveryStatus);
  Future<DataResult<void>> delete(String deliveryId);
  Future<DataResult<DeliveryModel?>> get(String deliveryId);
  Stream<List<DeliveryModel>> streamDeliveryByShopId(String shopId);
  Stream<List<DeliveryModel>> streamShopByName();
}