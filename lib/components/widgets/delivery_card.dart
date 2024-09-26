import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/common/extensions/delivery_status_extensions.dart';
import '../../common/models/delivery.dart';
import '../../common/theme/app_text_style.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;
  final void Function(DeliveryModel) showInMap;

  const DeliveryCard({
    super.key,
    required this.delivery,
    required this.showInMap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: Icon(delivery.status.icon),
        title: Text(delivery.clientName),
        onTap: () => showInMap(delivery),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Telefone: ',
                style: AppTextStyle.font14Bold(),
              ),
              TextSpan(
                text: '${delivery.shopPhone}\n',
                style: AppTextStyle.font14(),
              ),
              TextSpan(
                text: 'Endereço: ',
                style: AppTextStyle.font14Bold(),
              ),
              TextSpan(
                text: delivery.clientAddress,
                style: AppTextStyle.font14(),
              ),
              TextSpan(
                text: '\nHorário: ',
                style: AppTextStyle.font14Bold(),
              ),
              TextSpan(
                text: DateFormat("HH:mm 'do dia' dd/MM/yyyy")
                    .format(delivery.createdAt!),
                style: AppTextStyle.font14(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
