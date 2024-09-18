import 'package:flutter/material.dart';

import '/common/theme/app_text_style.dart';
import '/components/widgets/state_loading.dart';
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

  Future<bool> _deleteClient(ClientModel client) async {
    if (!ctrl.isAdmin) return false;

    final result = await showDialog<bool?>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.warning_amber_rounded,
              size: 60,
            ),
            title: const Text('Apagar Cliente'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'Todos os dados do cliente'),
                      TextSpan(
                        text: '\n\n"${client.name}"\n\n',
                        style: AppTextStyle.font12Bold(),
                      ),
                      const TextSpan(
                          text: 'serão removidos.\n\nConfirme a ação.'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Apagar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ) ??
        false;

    if (result) {
      final response = await ctrl.deleteClient(client);
      if (response.isFailure) {
        return false;
      }
    }
    return result;
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
            List<ClientModel> clients = snapshot.data ?? [];

            return Stack(
              children: [
                if (clients.isNotEmpty)
                  ListView.builder(
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
                            _editClient(client);
                          } else if (direction == DismissDirection.endToStart) {
                            return await _deleteClient(client);
                          }
                          return false;
                        },
                      );
                    },
                  ),
                if (clients.isEmpty)
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 60,
                                ),
                                Text('Nenhum cliente encontrado.')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const StateLoading(),
              ],
            );
          },
        ),
      ),
    );
  }
}
