import 'delivery_extended.dart';

class ShopDeliveryInfo {
  final String shopName;
  final double distance;

  int get length => deliveries.length;
  final List<DeliveryExtended> deliveries = [];

  ShopDeliveryInfo({
    required this.shopName,
    required this.distance,
  });
}
