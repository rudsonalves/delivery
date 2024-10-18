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

import '/common/extensions/delivery_status_extensions.dart';
import '/features/user_delivery/tab_bar_views/deliveries/deliveries_page.dart';
import '/features/user_delivery/tab_bar_views/reservations/reservations_page.dart';
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
      length: 3,
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
                icon: DeliveryStatus.orderPickedUpForDelivery.icon,
                child: const Text('Preparando'),
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
            const DeliveriesPage(DeliveryStatus.orderPickedUpForDelivery),
            const Center(child: Text('Delivery')),
          ],
        ),
      ),
    );
  }
}
