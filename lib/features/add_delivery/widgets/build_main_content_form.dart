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
  final Future<void> Function() addClient;
  final Future<void> Function(ClientModel?) editClient;

  const BuildMainContentForm({
    super.key,
    required this.ctrl,
    required this.store,
    required this.submitName,
    required this.submitPhone,
    required this.createDelivery,
    required this.addClient,
    required this.editClient,
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
          const Text(
            'Perquisar Cliente por',
            textAlign: TextAlign.center,
          ),
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
          const SizedBox(height: 12),
          Observer(
            builder: (_) {
              ClientModel? selectedClient = widget.ctrl.store.selectedClient;
              final length = widget.ctrl.clients.length < 4
                  ? widget.ctrl.clients.length
                  : 3;

              if (widget.ctrl.state == PageState.success) {
                if (widget.ctrl.clients.isNotEmpty) {
                  return Column(
                    children: [
                      OverflowBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: widget.addClient,
                            label: const Icon(Icons.add),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => widget
                                .editClient(widget.ctrl.store.selectedClient),
                            label: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 112 * length.toDouble(),
                        child: ListView.builder(
                          itemCount: widget.ctrl.clients.length,
                          itemBuilder: (context, index) {
                            final client = widget.ctrl.clients[index];
                            bool isSelected = selectedClient?.id == client.id;

                            return Card(
                              color: isSelected
                                  ? colorScheme.surfaceContainerHighest
                                  : null,
                              child: ListTile(
                                title: Text(client.name),
                                subtitle: Text(
                                  '${client.phone}\n${client.addressString}',
                                ),
                                trailing: Icon(
                                  isSelected
                                      ? Icons.task_alt_rounded
                                      : Icons.circle_outlined,
                                ),
                                onTap: () =>
                                    widget.ctrl.store.selectClient(client),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Card(
                  margin: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'Entre com Nome/Fone acima para busca cliente.',
                      textAlign: TextAlign.center,
                    ),
                  ),
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
