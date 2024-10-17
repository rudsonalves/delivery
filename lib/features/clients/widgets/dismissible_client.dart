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
