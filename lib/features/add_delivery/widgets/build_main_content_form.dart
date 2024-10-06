import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../common/models/client.dart';
import '../../../components/widgets/big_bottom.dart';
import '../../../stores/common/store_func.dart';
import '../add_delivery_controller.dart';
import '../stores/add_delivery_store.dart';

class BuildMainContentForm extends StatefulWidget {
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
  State<BuildMainContentForm> createState() => _BuildMainContentFormState();
}

class _BuildMainContentFormState extends State<BuildMainContentForm> {
  final searchByPHoneFocus = FocusNode();
  final searchByNameFocus = FocusNode();

  ReactionDisposer? _reaction;

  @override
  void initState() {
    super.initState();

    _reaction = reaction(
      (_) => widget.store.searchBy,
      (_) => FocusScope.of(context).unfocus(),
    );
  }

  @override
  void dispose() {
    searchByNameFocus.dispose();
    searchByPHoneFocus.dispose();
    _reaction?.call();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Loja'),
          Observer(builder: (context) {
            return DropdownButton<String>(
              icon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  widget.ctrl.refreshShops();
                },
              ),
              isExpanded: true,
              value: widget.ctrl.selectedShopId,
              items: widget.ctrl.shops
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  widget.ctrl.store.setShopId(value);
                }
              },
            );
          }),
          const Text('Perquisar Cliente por'),
          Observer(
            builder: (context) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RadioMenuButton<SearchMode>(
                  value: SearchMode.name,
                  groupValue: widget.ctrl.searchBy,
                  onChanged: (_) => widget.store.toogleSearchBy(),
                  child: const Text('Nome'),
                ),
                RadioMenuButton<SearchMode>(
                  value: SearchMode.phone,
                  toggleable: true,
                  groupValue: widget.ctrl.searchBy,
                  onChanged: (_) => widget.store.toogleSearchBy(),
                  child: const Text('Telefone'),
                ),
              ],
            ),
          ),
          Observer(
            builder: (context) {
              if (widget.ctrl.searchBy == SearchMode.name) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.ctrl.nameController,
                        focusNode: searchByNameFocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onSubmitted: widget.submitName,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => widget.submitName(
                        widget.ctrl.nameController.text,
                      ),
                      icon: const Icon(Icons.search),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.ctrl.phoneController,
                        focusNode: searchByPHoneFocus,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.search,
                        onSubmitted: widget.submitPhone,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => widget.submitName(
                        widget.ctrl.phoneController.text,
                      ),
                      icon: const Icon(Icons.search),
                    ),
                  ],
                );
              }
            },
          ),
          Observer(
            builder: (_) {
              ClientModel? selectedClient = widget.ctrl.store.selectedClient;

              if (widget.ctrl.state == PageState.success) {
                if (widget.ctrl.clients.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.ctrl.clients.length,
                    itemBuilder: (context, index) {
                      final client = widget.ctrl.clients[index];

                      return Card(
                        color: selectedClient?.id == client.id
                            ? colorScheme.surfaceContainerHigh
                            : null,
                        child: ListTile(
                          title: Text(client.name),
                          subtitle: Text(client.phone),
                          onTap: () => widget.ctrl.store.selectClient(client),
                        ),
                      );
                    },
                  );
                }
                return const Card(
                  child: Text('Nenhum cliente encontrado'),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          if (widget.ctrl.state == PageState.loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          const Divider(),
          Observer(
            builder: (context) => BigButton(
              enable: widget.store.isValid(),
              color: Colors.green,
              label: 'Gerar Entrega',
              onPressed: widget.createDelivery,
            ),
          ),
        ],
      ),
    );
  }
}
