import 'package:flutter/material.dart';

import '../../common/utils/markdown_to_rich_text.dart';
import '/common/extensions/delivery_status_extensions.dart';
import '../../common/models/delivery.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;
  final void Function(DeliveryModel)? action;

  const DeliveryCard({
    super.key,
    required this.delivery,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      child: ListTile(
        title: Text(delivery.clientName),
        subtitle: MarkdowntoRichText(
          text: '**Retirada: ${delivery.shopName}** -'
              ' ${delivery.shopAddress}\n'
              '**Entrega:**'
              ' ${delivery.clientAddress}',
        ),
        leading: delivery.status.icon,
        onTap: () {
          if (action != null) {
            action!(delivery);
          }
        },
      ),
    );
  }
}
