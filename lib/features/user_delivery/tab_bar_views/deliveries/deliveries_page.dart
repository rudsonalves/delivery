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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../common/models/delivery.dart';
import '../../delivery_map/delivery_map_page.dart';
import '/features/qrcode_read/qrcode_read_page.dart';
import '../../../../common/theme/app_text_style.dart';
import '../../../../components/widgets/delivery_card.dart';
import '../../../../stores/common/store_func.dart';
import 'deliveries_controller.dart';
import 'deliveries_store.dart';

class DeliveriesPage extends StatefulWidget {
  final DeliveryStatus status;
  const DeliveriesPage(
    this.status, {
    super.key,
  });

  @override
  State<DeliveriesPage> createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  final store = DeliveriesStore();
  final ctrl = DeliveriesController();

  @override
  void initState() {
    super.initState();

    ctrl.init(
      store: store,
      status: widget.status,
    );
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

  Future<void> _createRoutes() async {
    await ctrl.createBasicRoutes();
    if (mounted) {
      await Navigator.pushNamed(context, DeliveryMapPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  final deliveries = ctrl.deliveries;
                  if (deliveries.isEmpty) {
                    return const Center(
                      child:
                          Text('Scanneie os QRCode reservados no fornecedor.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: deliveries.length,
                    itemBuilder: (_, index) {
                      final delivery = deliveries[index];

                      return DeliveryCard(
                        delivery: delivery,
                        // button: IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     Icons.place,
                        //     color: Colors.red,
                        //   ),
                        // ),
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
            bottom: 20,
            right: 20,
            child: ValueListenableBuilder(
                valueListenable: store.deliveries,
                builder: (context, deliveries, _) {
                  return Row(
                    children: [
                      if (deliveries.isNotEmpty)
                        FloatingActionButton(
                          onPressed: _createRoutes,
                          heroTag: 'hero_01',
                          backgroundColor: colorScheme.onPrimaryFixedVariant
                              .withOpacity(0.5),
                          child: const Icon(Icons.location_on_sharp),
                        ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        onPressed: _addDeliveries,
                        heroTag: 'hero_02',
                        backgroundColor:
                            colorScheme.onPrimaryFixedVariant.withOpacity(0.5),
                        child: const Icon(Icons.loupe),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
