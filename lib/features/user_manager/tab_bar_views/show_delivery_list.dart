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

import '../../../common/models/delivery.dart';
import '../../../common/models/delivery_info.dart';
import '../../../common/theme/app_text_style.dart';
import '../../../components/widgets/delivery_card.dart';
import '../../../stores/common/store_func.dart';
import '../../add_delivery/add_delivery_page.dart';
import '../../show_qrcode/show_qrcode.dart';
import 'manager_store.dart';
import 'manager_controller.dart';

class ShowDeliveryList extends StatefulWidget {
  final void Function(DeliveryModel)? action;
  final void Function(DeliveryModel)? select;
  final DeliveryStatus status;

  const ShowDeliveryList({
    super.key,
    required this.status,
    this.action,
    this.select,
  });

  @override
  State<ShowDeliveryList> createState() => _ShowDeliveryListState();
}

class _ShowDeliveryListState extends State<ShowDeliveryList> {
  final ctrl = ManagerController();
  final ManagerStore store = ManagerStore();
  final Map<String, DeliveryInfoModel> selectedIds = {};

  @override
  void initState() {
    super.initState();

    ctrl.init(
      store: store,
      status: widget.status,
      selectedIds: selectedIds,
    );
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void _addDelivery() {
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  Future<void> _showQRCode() async {
    for (final delivery in selectedIds.values) {
      await Navigator.pushNamed(
        context,
        ShowQrcode.routeName,
        arguments: delivery,
      );
    }
    ctrl.clearSelections();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListenableBuilder(
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
                          child: Text('Nenhuma entrega encontrada!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: deliveries.length,
                        itemBuilder: (_, index) {
                          final delivery = deliveries[index];
                          bool selected = selectedIds.containsKey(delivery.id!);

                          return DeliveryCard(
                            delivery: delivery,
                            selected: selected,
                            onTap: ctrl.toggleSelection,
                            button: IconButton(
                              onPressed: widget.action != null
                                  ? () => widget.action!(delivery)
                                  : null,
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
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.status.index <=
                  DeliveryStatus.orderReservedForPickup.index)
                FloatingActionButton(
                  heroTag: 'hero_01',
                  backgroundColor:
                      colorScheme.onPrimaryFixedVariant.withOpacity(0.5),
                  onPressed: _showQRCode,
                  child: const Icon(Icons.qr_code_2),
                ),
              const SizedBox(width: 20),
              FloatingActionButton(
                backgroundColor:
                    colorScheme.onPrimaryFixedVariant.withOpacity(0.5),
                heroTag: 'hero_02',
                onPressed: _addDelivery,
                child: const Icon(Icons.delivery_dining_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
