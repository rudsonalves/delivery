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
import '/components/widgets/main_drawer/custom_drawer.dart';
import '../../common/models/delivery.dart';
import '../../components/widgets/custom_app_bar/custom_app_bar.dart';
import '../map/map_page.dart';
import 'tab_bar_views/show_delivery_list.dart';

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
  void _showInMap(DeliveryModel delivery) {
    Navigator.pushNamed(context, MapPage.routeName, arguments: delivery);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('Gerente'),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: DeliveryStatus.orderReservedForPickup.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderPickedUpForDelivery.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderInTransit.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderDelivered.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderClosed.icon,
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(widget.pageController),
        body: TabBarView(
          children: [
            ShowDeliveryList(
              action: _showInMap,
              status: DeliveryStatus.orderReservedForPickup,
            ),
            ShowDeliveryList(
              action: _showInMap,
              status: DeliveryStatus.orderPickedUpForDelivery,
            ),
            ShowDeliveryList(
              action: _showInMap,
              status: DeliveryStatus.orderInTransit,
            ),
            ShowDeliveryList(
              action: _showInMap,
              status: DeliveryStatus.orderDelivered,
            ),
            ShowDeliveryList(
              action: _showInMap,
              status: DeliveryStatus.orderClosed,
            ),
          ],
        ),
      ),
    );
  }
}
