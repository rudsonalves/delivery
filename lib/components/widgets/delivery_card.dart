import 'package:flutter/material.dart';

import '../../common/utils/markdown_to_rich_text.dart';
import '/common/extensions/delivery_status_extensions.dart';
import '../../common/models/delivery.dart';
import 'custom_list_tile.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;
  final void Function(DeliveryModel)? onTap;
  final Widget? button;
  final bool selected;

  const DeliveryCard({
    super.key,
    required this.delivery,
    this.onTap,
    this.button,
    this.selected = false,
  });

  String _cleanPhone(String phone) {
    return phone.replaceAll('(', '').replaceAll(')', '');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap != null ? () => onTap!(delivery) : null,
      child: Card(
        color: selected
            ? colorScheme.tertiaryContainer
            : colorScheme.surfaceContainer,
        child: CustomListTile(
          stringTitle: '${delivery.shopName} ➠ ${delivery.clientName}',
          subtitle: Column(
            children: [
              MarkdowntoRichText(
                text: '**Retirada:** ${delivery.shopAddress}'
                    ' (📞 **${_cleanPhone(delivery.shopPhone)}**)',
              ),
              const SizedBox(height: 6),
              MarkdowntoRichText(
                text: '**Entrega:** ${delivery.clientAddress}'
                    ' (📞 **${_cleanPhone(delivery.clientPhone)}**)',
              ),
            ],
          ),
          leading: button == null
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: delivery.status.icon,
                )
              : Column(
                  children: [
                    delivery.status.icon,
                    const SizedBox(height: 20),
                    button!,
                  ],
                ),
        ),
      ),
    );
  }
}
