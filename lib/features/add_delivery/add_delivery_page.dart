import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/components/widgets/big_bottom.dart';
import '../../common/theme/app_text_style.dart';
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
  final store = AddDeliveryStore();

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

  void _backPage() {
    Navigator.pop(context);
  }

  void _submitName(String name) {
    ctrl.searchClientsByName(name);
  }

  void _submitPhone(String phone) {
    ctrl.searchClentsByPhone(phone);
  }

  Future<void> _createDelivery() async {
    await ctrl.createDelivery();
    if (mounted) Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Observer(
          builder: (context) {
            final selectedClientId = ctrl.selectedClient?.id;

            switch (ctrl.noShopsState) {
              case NoShopState.unknowError:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Card(
                        color: colorScheme.surfaceContainerHigh,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                'Erro desconhecido.\n',
                                style: AppTextStyle.font16Bold(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  size: 80,
                                  color: Colors.red[400],
                                ),
                              ),
                              const Text(
                                'Está tendo algum problema com a conexão.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Por favor, tente mais tarde.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              case NoShopState.noShops:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Card(
                        color: colorScheme.surfaceContainerHigh,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Lojas não Encontradas',
                                style: AppTextStyle.font16Bold(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Icon(
                                  Icons.work_off_outlined,
                                  size: 60,
                                  color: Colors.orange[400],
                                ),
                              ),
                              const Text(
                                'Sua conta não possui lojas associadas.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Aguarde'
                                ' até que um proprietário associe sua conta'
                                ' a gerência de entregas de uma de suas lojas.',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              case NoShopState.ready:
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
                                          ctrl.store.selectClient(client),
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
                        onPressed: _createDelivery,
                      ),
                    ],
                  ),
                );
              case NoShopState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
