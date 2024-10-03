import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/common/store_func.dart';
import '../../components/widgets/dismissible_help_row.dart';
import 'stores/clients_store.dart';
import '/common/theme/app_text_style.dart';
import '../../common/models/client.dart';
import 'clients_controller.dart';
import '/features/add_client/add_cliend_page.dart';
import 'widgets/dismissible_client.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  static const routeName = '/clients';

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final store = ClientsStore();
  final ctrl = ClientsController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  Future<void> _editClient(ClientModel client) async {
    await ctrl.editClient(context, client);
  }

  void _addClient() => Navigator.pushNamed(context, AddClientPage.routeName);

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
        onPressed: _addClient,
        label: const Text('Adicionar Cliente'),
        icon: const Icon(Icons.person_add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const DismissibleHelpRow(),
            Expanded(
              child: Observer(
                builder: (_) {
                  switch (store.state) {
                    case PageState.initial:
                    case PageState.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case PageState.success:
                      final clients = store.clients;
                      if (clients.isEmpty) {
                        return const Center(
                          child: Text('Nenhum cliente encontrado!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];
                          return DismissibleClient(
                            ctrl: ctrl,
                            editClient: _editClient,
                            deleteClient: _deleteClient,
                            client: client,
                          );
                        },
                      );
                    case PageState.error:
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              store.errorMessage ?? 'Ocorreu um erro.',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.font16Bold(color: Colors.red),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () {
                                // ctrl.refresh(userId, store.radiusInKm);
                              },
                              label: const Text('Tentar Novamente.'),
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
