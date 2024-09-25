import 'package:delivery/components/widgets/big_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/pages/add_delivery_store.dart';
import '../../stores/pages/common/store_func.dart';
import 'add_delivery_controller.dart';

class AddDeliveryPage extends StatefulWidget {
  const AddDeliveryPage({super.key});

  static const routeName = '/ad_delivery';

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  final ctrl = AddDeliveryController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  void _backPage() {
    Navigator.pop(context);
  }

  void _submitName(String name) {
    ctrl.pageStore.searchClientsByName(name);
  }

  void _submitPhone(String phone) {
    ctrl.pageStore.searchClentsByPhone(phone);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitação de Entrega'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Observer(
            builder: (context) {
              final selectedClientId = ctrl.selectedClient?.id;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Origem'),
                  DropdownButton<String>(
                    icon: const Icon(Icons.store),
                    isExpanded: true,
                    value: ctrl.selectedShopId,
                    items: ctrl.shops
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(item.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ctrl.pageStore.setShopId(value);
                      }
                    },
                  ),
                  const Text('Selecione o Destino'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RadioMenuButton<SearchMode>(
                        value: SearchMode.name,
                        groupValue: ctrl.searchBy,
                        onChanged: (_) => ctrl.toogleSearchBy(),
                        child: const Text('Nome'),
                      ),
                      RadioMenuButton<SearchMode>(
                        value: SearchMode.phone,
                        toggleable: true,
                        groupValue: ctrl.searchBy,
                        onChanged: (_) => ctrl.toogleSearchBy(),
                        child: const Text('Telefone'),
                      ),
                    ],
                  ),
                  if (ctrl.searchBy == SearchMode.name)
                    TextField(
                      controller: ctrl.nameController,
                      keyboardType: TextInputType.text,
                      onSubmitted: _submitName,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                      ),
                    ),
                  if (ctrl.searchBy == SearchMode.phone)
                    TextField(
                      controller: ctrl.phoneController,
                      keyboardType: TextInputType.phone,
                      onSubmitted: _submitPhone,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                      ),
                    ),
                  if (ctrl.state == PageState.success)
                    Builder(
                      builder: (_) {
                        if (ctrl.clients.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ctrl.clients.length,
                            itemBuilder: (context, index) {
                              final client = ctrl.clients[index];

                              return Card(
                                color: selectedClientId == client.id
                                    ? colorScheme.surfaceContainerHigh
                                    : null,
                                child: ListTile(
                                  title: Text(client.name),
                                  subtitle: Text(client.phone),
                                  onTap: () =>
                                      ctrl.pageStore.selectClient(client),
                                ),
                              );
                            },
                          );
                        }
                        return const Card(
                          child: Text('Nenhum cliente encontrado'),
                        );
                      },
                    ),
                  if (ctrl.state == PageState.loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  const Divider(),
                  BigButton(
                    color: Colors.green,
                    label: 'Gerar Entrega',
                    onPressed: ctrl.createDelivery,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
