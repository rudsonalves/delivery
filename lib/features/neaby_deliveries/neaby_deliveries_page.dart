import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/common/extensions/delivery_status_extensions.dart';
import '/common/models/delivery.dart';
import '/common/theme/app_text_style.dart';
import '/locator.dart';
import '/stores/pages/common/store_func.dart';
import '/stores/pages/nearby_deliveries_store.dart';
import '../../stores/user/user_store.dart';
import 'neaby_deliveries_controller.dart';

class NeabyDeliveriesPage extends StatefulWidget {
  const NeabyDeliveriesPage({super.key});

  @override
  State<NeabyDeliveriesPage> createState() => _NeabyDeliveriesPageState();
}

class _NeabyDeliveriesPageState extends State<NeabyDeliveriesPage> {
  final store = NearbyDeliveriesStore();
  late final NeabyDeliveriesController ctrl;
  final _currentUser = locator<UserStore>().currentUser;
  late final String userId;
  final double _initialRadius = 5.0;

  @override
  void initState() {
    super.initState();

    userId = _currentUser?.id ?? '';

    ctrl = NeabyDeliveriesController(store: store);
    // Initialize the location and search for deliveries
    ctrl.init(userId, _initialRadius);
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
              ctrl.refresh(userId, store.radiusInKm);
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
                        ctrl.updateRadius(value, userId);
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
                switch (store.pageState) {
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

                        return ListTile(
                          title: Text(delivery.clientName),
                          subtitle: Text(delivery.clientAddress),
                          trailing: Text(delivery.status.displayName),
                          onTap: () {
                            _showDeliveryDetails(delivery);
                          },
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
                              ctrl.refresh(userId, store.radiusInKm);
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
