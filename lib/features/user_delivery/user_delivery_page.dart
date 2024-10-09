import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/widgets/delivery_card.dart';
import '/common/extensions/delivery_status_extensions.dart';
import '/common/models/delivery.dart';
import '/common/theme/app_text_style.dart';
import '/locator.dart';
import '../../stores/common/store_func.dart';
import 'stores/user_delivery_store.dart';
import '../../stores/user/user_store.dart';
import 'user_delivery_controller.dart';

class UserDeliveryPage extends StatefulWidget {
  const UserDeliveryPage({super.key});

  @override
  State<UserDeliveryPage> createState() => _UserDeliveryPageState();
}

class _UserDeliveryPageState extends State<UserDeliveryPage> {
  final store = UserDeliveryStore();
  final ctrl = UserDeliveryController();
  final _currentUser = locator<UserStore>().currentUser;

  final double _initialRadius = 5.0;

  late final String userId;

  @override
  void initState() {
    super.initState();

    if (_currentUser == null || _currentUser.id == null) {
      store.setError('Usuário não autenticado.');
      return;
    }
    userId = _currentUser.id!;

    // Initialize the location and search for deliveries
    ctrl.init(
      store: store,
      userId: userId,
      radiusInKm: _initialRadius,
    );
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  // Function to display delivery details
  void _showDeliveryDetails(DeliveryModel delivery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(delivery.clientName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Endereço: ${delivery.clientAddress}'),
            const SizedBox(height: 10),
            Text('Status: ${delivery.status.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ctrl.refresh(store.radiusInKm);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Observer(
                  builder: (_) =>
                      Text('Raio: ${store.radiusInKm.toStringAsFixed(1)} km'),
                ),
                Expanded(
                  child: Observer(
                    builder: (_) => Slider(
                      min: 1.0,
                      max: 20.0,
                      divisions: 19,
                      value: store.radiusInKm,
                      label: '${store.radiusInKm.toStringAsFixed(1)} km',
                      onChanged: (value) {
                        ctrl.updateRadius(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    final deliveries = store.deliveries;
                    if (deliveries.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma entrega próxima encontrada!'),
                      );
                    }

                    return ListView.builder(
                      itemCount: deliveries.length,
                      itemBuilder: (_, index) {
                        final delivery = deliveries[index];

                        return DeliveryCard(
                          delivery: delivery,
                          action: _showDeliveryDetails,
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
                              ctrl.refresh(store.radiusInKm);
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
    );
  }
}
