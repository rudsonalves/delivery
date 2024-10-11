import 'package:flutter/material.dart';

import '../../components/widgets/delivery_card.dart';
import '../../common/models/delivery.dart';
import '../../common/models/shop_delivery_info.dart';
import '../../common/utils/markdown_to_rich_text.dart';

class ShopCard extends StatelessWidget {
  final ShopDeliveryInfo shopInfo;
  final void Function(DeliveryModel)? action;
  final bool isExpanded;
  final void Function(bool) onExpansionChanged;

  const ShopCard({
    super.key,
    required this.shopInfo,
    this.action,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  String _cleanPhone(String phone) {
    return phone.replaceAll('(', '').replaceAll(')', '');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Text(
            '${shopInfo.shopName} a ${shopInfo.distance.toStringAsFixed(2)} km'),
        subtitle: MarkdowntoRichText(
          text:
              '**${shopInfo.length} entrega${shopInfo.length > 1 ? 's' : ''}**'
              ' 📞 ${_cleanPhone(shopInfo.phone!)}\n'
              '${shopInfo.address!}',
        ),
        children: shopInfo.deliveries
            .map(
              (deliveryExtended) => DeliveryCard(
                delivery: deliveryExtended.delivery,
                action: (delivery) {
                  if (action != null) {
                    action!(delivery);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
