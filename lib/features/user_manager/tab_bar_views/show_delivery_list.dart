import 'package:flutter/material.dart';

import '../../../common/models/delivery.dart';
import '../../../common/models/delivery_info.dart';
import '../../../common/theme/app_text_style.dart';
import '../../../components/widgets/delivery_card.dart';
import '../../../stores/common/store_func.dart';
import 'manager_store.dart';
import 'manager_controller.dart';

class ShowDeliveryList extends StatefulWidget {
  final void Function(DeliveryModel)? action;
  final void Function(DeliveryModel)? select;
  final DeliveryStatus deliveryStatus;
  final Map<String, DeliveryInfoModel> selectedIds;

  const ShowDeliveryList({
    super.key,
    required this.deliveryStatus,
    required this.selectedIds,
    this.action,
    this.select,
  });

  @override
  State<ShowDeliveryList> createState() => _ShowDeliveryListState();
}

class _ShowDeliveryListState extends State<ShowDeliveryList> {
  final ctrl = ManagerController();
  final ManagerStore store = ManagerStore();

  @override
  void initState() {
    super.initState();

    ctrl.init(
      store: store,
      status: widget.deliveryStatus,
      selectedIds: widget.selectedIds,
    );
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      bool selected =
                          widget.selectedIds.containsKey(delivery.id!);

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
    );
  }
}
