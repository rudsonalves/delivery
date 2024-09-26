import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../models/delivery.dart';

extension DeliveryStatusExtension on DeliveryStatus {
  String get displayName {
    switch (this) {
      case DeliveryStatus.orderRegisteredForPickup:
        return 'Pedido Registrado para Retirada';
      case DeliveryStatus.orderPickedUpForDelivery:
        return 'Pedido Retirado para Entrega';
      case DeliveryStatus.orderInTransit:
        return 'Pedido em Trânsito';
      case DeliveryStatus.orderDelivered:
        return 'Pedido Entregue';
      case DeliveryStatus.orderClosed:
        return 'Pedido Fechado';
      case DeliveryStatus.orderReject:
        return 'Pedido Rejeitado';
    }
  }

  IconData get icon {
    switch (this) {
      case DeliveryStatus.orderRegisteredForPickup:
        return Symbols.concierge_rounded;
      case DeliveryStatus.orderPickedUpForDelivery:
        return Icons.delivery_dining_rounded;
      case DeliveryStatus.orderInTransit:
        return Symbols.local_shipping_rounded;
      case DeliveryStatus.orderDelivered:
        return Symbols.task_alt_rounded;
      case DeliveryStatus.orderClosed:
        return Symbols.flaky_rounded;
      case DeliveryStatus.orderReject:
        return Symbols.report_rounded;
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
