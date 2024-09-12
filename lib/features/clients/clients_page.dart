import 'dart:developer';

import 'package:flutter/material.dart';

import '/components/widgets/base_dismissible_container.dart';
import '../../common/models/client.dart';
import 'clients_controller.dart';
import '/features/add_client/add_cliend_page.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  static const routeName = '/clients';

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final ctrl = ClientsController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  Future<void> _editClient(ClientModel client) async {
    await ctrl.editClient(context, client);
  }

  Future<void> _deleteClient(ClientModel client) async {
    log(client.toString());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddClientPage.routeName),
        label: const Text('Adicionar Cliente'),
        icon: const Icon(Icons.person_add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<ClientModel>>(
          stream: ctrl.clientRepository.streamClientByName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No clients found.'),
              );
            }

            final clients = snapshot.data!;

            return ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
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
                        title: Text(client.name),
                        subtitle: Text(client.phone),
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _editClient(client);
                    } else if (direction == DismissDirection.endToStart) {
                      _deleteClient(client);
                    }
                    return false;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
