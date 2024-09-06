import 'package:delivery/features/add_client/add_cliend_page.dart';
import 'package:flutter/material.dart';

import 'clients_controller.dart';

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
        onPressed: () => Navigator.pushNamed(context, AddCliendPage.routeName),
        label: const Text('Adicionar Cliente'),
        icon: const Icon(Icons.person_add),
      ),
      body: Column(),
    );
  }
}
