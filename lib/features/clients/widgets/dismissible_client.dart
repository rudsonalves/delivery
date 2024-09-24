import 'package:flutter/material.dart';

import '../../../common/models/client.dart';
import '../../../components/widgets/base_dismissible_container.dart';
import '../clients_controller.dart';

class DismissibleClient extends StatelessWidget {
  final ClientsController ctrl;
  final ClientModel client;
  final Future<bool> Function(ClientModel client) deleteClient;
  final Future<void> Function(ClientModel client) editClient;

  const DismissibleClient({
    super.key,
    required this.ctrl,
    required this.client,
    required this.deleteClient,
    required this.editClient,
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
        enable: ctrl.isAdmin,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          margin: EdgeInsets.zero,
          color: colorScheme.surfaceContainerHigh,
          child: ListTile(
            title: Text(client.name),
            subtitle: Text(client.phone),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          editClient(client);
        } else if (direction == DismissDirection.endToStart) {
          return await deleteClient(client);
        }
        return false;
      },
    );
  }
}
