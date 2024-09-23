import 'package:flutter/material.dart';

import '../models/delivery.dart';

extension DeliveryStatusExtension on DeliveryStatus {
  String get displayName {
    switch (this) {
      case DeliveryStatus.orderRegisteredForPickup:
        return "Pedido registrado para retirada";
      case DeliveryStatus.orderPickedUpForDelivery:
        return "Pedido retirado para entrega";
      case DeliveryStatus.orderInTransit:
        return "Pedido em trânsito";
      case DeliveryStatus.orderDelivered:
        return "Pedido entregue";
      case DeliveryStatus.orderClosed:
        return "Pedido encerrado";
      case DeliveryStatus.orderReject:
        return "Pedido rejeitado";
      default:
        return "";
    }
  }

  Color get color {
    switch (this) {
      case DeliveryStatus.orderRegisteredForPickup:
        return Colors.blue;
      case DeliveryStatus.orderPickedUpForDelivery:
        return Colors.orange;
      case DeliveryStatus.orderInTransit:
        return Colors.purple;
      case DeliveryStatus.orderDelivered:
        return Colors.green;
      case DeliveryStatus.orderClosed:
        return Colors.grey;
      case DeliveryStatus.orderReject:
        return Colors.redAccent;
      default:
        return Colors.black;
    }
  }
}
