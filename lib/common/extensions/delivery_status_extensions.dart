import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../models/delivery.dart';

extension DeliveryStatusExtension on DeliveryStatus {
  String get displayName {
    switch (this) {
      case DeliveryStatus.orderRegisteredForPickup:
        return 'Pedido Registrado para Retirada';
      case DeliveryStatus.orderReservedForPickup:
        return 'Pedido Reservado para Retirada';
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

  Icon get icon {
    switch (this) {
      case DeliveryStatus.orderRegisteredForPickup:
        return const Icon(
          Symbols.deployed_code_update_rounded,
          color: Colors.purple,
        );
      case DeliveryStatus.orderReservedForPickup:
        return const Icon(
          Symbols.deployed_code_history_rounded,
          color: Colors.cyan,
        );
      case DeliveryStatus.orderPickedUpForDelivery:
        return const Icon(
          Symbols.deployed_code_rounded,
          color: Colors.yellow,
        );
      case DeliveryStatus.orderInTransit:
        return const Icon(
          Symbols.local_shipping,
          color: Colors.blue,
        );
      case DeliveryStatus.orderDelivered:
        return const Icon(
          Symbols.house_rounded,
          color: Colors.orangeAccent,
        );
      case DeliveryStatus.orderClosed:
        return const Icon(
          Symbols.task_alt_rounded,
          color: Colors.green,
        );
      case DeliveryStatus.orderReject:
        return const Icon(
          Symbols.cancel,
          color: Colors.red,
        );
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
