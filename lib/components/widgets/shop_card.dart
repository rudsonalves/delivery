// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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
                onTap: (delivery) {
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
