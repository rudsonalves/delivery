import 'dart:developer';

import 'package:flutter/material.dart';

import '/features/qrcode_read/qrcode_read_page.dart';
import '../../../../common/theme/app_text_style.dart';
import '../../../../components/widgets/delivery_card.dart';
import '../../../../stores/common/store_func.dart';
import 'deliveries_controller.dart';
import 'deliveries_store.dart';

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({super.key});

  @override
  State<DeliveriesPage> createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  final store = DeliveriesStore();
  final ctrl = DeliveriesController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  void dispose() {
    ctrl.dispose();
    store.dispose();
    super.dispose();
  }

  Future<void> _addDeliveries() async {
    final result = await Navigator.pushNamed(context, QRCodeReadPage.routeName)
        as Map<String, dynamic>?;
    if (result != null) {
      log('Result Id: ${result['id']}');
      ctrl.catchDeliveryById(result['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: store.state,
            builder: (context, _) {
              switch (store.state.value) {
                case PageState.initial:
                case PageState.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case PageState.success:
                  final deliveries = store.deliveries;
                  if (deliveries.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma entrega em andamento!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: deliveries.length,
                    itemBuilder: (_, index) {
                      final delivery = deliveries[index];

                      return DeliveryCard(
                        delivery: delivery,
                        button: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.place,
                            color: Colors.red,
                          ),
                        ),
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
              }
            },
          ),
          Positioned(
            right: 20,
            top: 20,
            child: FloatingActionButton(
              onPressed: _addDeliveries,
              child: const Icon(Icons.loupe),
            ),
          ),
        ],
      ),
    );
  }
}
