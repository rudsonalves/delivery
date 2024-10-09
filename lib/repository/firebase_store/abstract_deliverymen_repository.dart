import 'package:geolocator/geolocator.dart';

import '../../common/models/delivery_men.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractDeliverymenRepository {
  Future<Position?> getCurrentLocation();
  Future<DataResult<DeliverymenModel>> updateLocation(
      DeliverymenModel deliverymen);
  Future<DataResult<DeliverymenModel>> add(DeliverymenModel deliverymen);
}