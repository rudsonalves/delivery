import 'package:flutter/material.dart';

import '../../../components/widgets/big_bottom.dart';
import '../../../stores/common/store_func.dart';
import '../add_delivery_controller.dart';
import '../stores/add_delivery_store.dart';

class BuildMainContentForm extends StatelessWidget {
  final AddDeliveryController ctrl;
  final AddDeliveryStore store;
  final void Function(String) submitName;
  final void Function(String) submitPhone;
  final Future<void> Function() createDelivery;

  const BuildMainContentForm({
    super.key,
    required this.ctrl,
    required this.store,
    required this.submitName,
    required this.submitPhone,
    required this.createDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedClientId = ctrl.selectedClient?.id;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Origem'),
          DropdownButton<String>(
            icon: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ctrl.refreshShops();
              },
            ),
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
                ctrl.store.setShopId(value);
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
                onChanged: (_) => store.toogleSearchBy(),
                child: const Text('Nome'),
              ),
              RadioMenuButton<SearchMode>(
                value: SearchMode.phone,
                toggleable: true,
                groupValue: ctrl.searchBy,
                onChanged: (_) => store.toogleSearchBy(),
                child: const Text('Telefone'),
              ),
            ],
          ),
          if (ctrl.searchBy == SearchMode.name)
            TextField(
              controller: ctrl.nameController,
              keyboardType: TextInputType.text,
              onSubmitted: submitName,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
              ),
            ),
          if (ctrl.searchBy == SearchMode.phone)
            TextField(
              controller: ctrl.phoneController,
              keyboardType: TextInputType.phone,
              onSubmitted: submitPhone,
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
                          onTap: () => ctrl.store.selectClient(client),
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
            onPressed: createDelivery,
          ),
        ],
      ),
    );
  }
}
