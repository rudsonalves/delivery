import 'package:delivery/common/extensions/delivery_status_extensions.dart';
import 'package:delivery/components/widgets/main_drawer/custom_drawer.dart';
import 'package:delivery/stores/common/store_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/models/delivery.dart';
import '../../common/theme/app_text_style.dart';
import '../../components/widgets/custom_app_bar/custom_app_bar.dart';
import 'stores/user_manager_store.dart';
import '../add_delivery/add_delivery_page.dart';
import '../../components/widgets/delivery_card.dart';
import '../map/map_page.dart';
import 'user_manager_controller.dart';

class UserManagerPage extends StatefulWidget {
  final PageController pageController;

  const UserManagerPage(
    this.pageController, {
    super.key,
  });

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  final ctrl = UserManagerController();
  final store = UserManagerStore();

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

  void _showInMap(DeliveryModel delivery) {
    Navigator.pushNamed(context, MapPage.routeName, arguments: delivery);
  }

  void _addDelivery() {
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('Gerente'),
          elevation: 5,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: DeliveryStatus.orderRegisteredForPickup.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderReservedForPickup.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderPickedUpForDelivery.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderInTransit.icon,
              ),
              // Tab(
              //   icon: DeliveryStatus.orderDelivered.icon,
              // ),
              Tab(
                icon: DeliveryStatus.orderClosed.icon,
              ),
              // Tab(
              //   icon: DeliveryStatus.orderReject.icon,
              // ),
            ],
          ),
        ),
        drawer: CustomDrawer(widget.pageController),
        floatingActionButton: FloatingActionButton(
          onPressed: _addDelivery,
          child: const Icon(Icons.delivery_dining_rounded),
        ),
        body: Column(
          children: [
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
                          child: Text('Nenhuma entrega encontrada!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: deliveries.length,
                        itemBuilder: (_, index) {
                          final delivery = deliveries[index];

                          return DeliveryCard(
                            delivery: delivery,
                            action: _showInMap,
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
      ),
    );
  }
}
