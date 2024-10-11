import 'delivery_extended.dart';

class ShopDeliveryInfo {
  final String shopName;
  final double distance;

  int get length => deliveries.length;
  String? get phone => deliveries.first.delivery.shopPhone;
  String? get address => deliveries.first.delivery.shopAddress;
  final List<DeliveryExtended> deliveries = [];

  ShopDeliveryInfo({
    required this.shopName,
    required this.distance,
  });
}
