import 'package:delivery/common/extensions/delivery_status_extensions.dart';
import 'package:delivery/features/user_delivery/tab_bar_views/deliveries/deliveries_page.dart';
import 'package:delivery/features/user_delivery/tab_bar_views/reservations/reservations_page.dart';
import 'package:flutter/material.dart';

import '../../common/models/delivery.dart';
import '../../components/widgets/custom_app_bar/custom_app_bar.dart';
import '../../components/widgets/main_drawer/custom_drawer.dart';

class UserDeliveryPage extends StatefulWidget {
  final PageController pageController;
  const UserDeliveryPage(
    this.pageController, {
    super.key,
  });

  @override
  State<UserDeliveryPage> createState() => _UserDeliveryPageState();
}

class _UserDeliveryPageState extends State<UserDeliveryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('Entregador'),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeliveryStatus.orderRegisteredForPickup.icon,
                    DeliveryStatus.orderReservedForPickup.icon,
                  ],
                ),
                child: const Text('Reservas'),
              ),
              Tab(
                icon: DeliveryStatus.orderInTransit.icon,
                child: const Text('Entregas'),
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(widget.pageController),
        body: TabBarView(
          children: [
            ReservationsPage(widget.pageController),
            const DeliveriesPage(),
          ],
        ),
      ),
    );
  }
}
