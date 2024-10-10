import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../common/models/delivery_men.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractDeliverymenRepository {
  // Future<Position?> getCurrentLocation();
  Future<GeoFirePoint> getCurrentGeoFirePoint();
  Future<DataResult<DeliverymenModel>> updateLocation(
      DeliverymenModel deliverymen);
  Future<DataResult<DeliverymenModel>> set(DeliverymenModel deliverymen);
  Future<DataResult<DeliverymenModel?>> get(String id);
  Future<DataResult<void>> delete(String id);
}
