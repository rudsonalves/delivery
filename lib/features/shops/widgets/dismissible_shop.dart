import 'package:flutter/material.dart';

import '../../../common/models/shop.dart';
import '../../../common/utils/markdown_to_rich_text.dart';
import '../../../components/widgets/base_dismissible_container.dart';

class DismissibleShop extends StatelessWidget {
  final ShopModel shop;
  final Future<void> Function(ShopModel) editShop;
  final Future<bool> Function(ShopModel) deleteShop;

  const DismissibleShop({
    super.key,
    required this.shop,
    required this.editShop,
    required this.deleteShop,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: UniqueKey(),
      background: baseDismissibleContainer(
        context,
        alignment: Alignment.centerLeft,
        color: Colors.green.withOpacity(.30),
        icon: Icons.edit,
        label: 'Editar',
      ),
      secondaryBackground: baseDismissibleContainer(
        context,
        alignment: Alignment.centerRight,
        color: Colors.red.withOpacity(.30),
        icon: Icons.delete,
        label: 'Apagar',
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          margin: EdgeInsets.zero,
          color: colorScheme.surfaceContainerHigh,
          child: ListTile(
            title: Text(shop.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdowntoRichText(
                  text:
                      '*${shop.description ?? ''}*\n${shop.addressString ?? ''}',
                ),
              ],
            ),
            // Text(shop.description ?? ''),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          editShop(shop);
        } else if (direction == DismissDirection.endToStart) {
          return await deleteShop(shop);
        }
        return false;
      },
    );
  }
}
