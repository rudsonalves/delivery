import 'delivery.dart';

class DeliveryExtended {
  final DeliveryModel delivery;
  final double distanceFromShop;

  DeliveryExtended({
    required this.delivery,
    required this.distanceFromShop,
  });

  factory DeliveryExtended.fromDeliveryModel(
      DeliveryModel delivery, double distanceFromShop) {
    return DeliveryExtended(
      delivery: delivery,
      distanceFromShop: distanceFromShop,
    );
  }

  DeliveryModel toDeliveryModel() {
    return delivery;
  }
}
