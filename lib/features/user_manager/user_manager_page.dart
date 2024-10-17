import 'package:flutter/material.dart';

import '../../common/models/delivery_info.dart';
import '../show_qrcode/show_qrcode.dart';
import '/common/extensions/delivery_status_extensions.dart';
import '/components/widgets/main_drawer/custom_drawer.dart';
import '../../common/models/delivery.dart';
import '../../components/widgets/custom_app_bar/custom_app_bar.dart';
import '../add_delivery/add_delivery_page.dart';
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
  final Map<String, DeliveryInfoModel> deliveriesSelected = {};

  @override
  void initState() {
    super.initState();
  }

  void _showInMap(DeliveryModel delivery) {
    Navigator.pushNamed(context, MapPage.routeName, arguments: delivery);
  }

  void _addDelivery() {
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  Future<void> _showQRCode() async {
    for (final delivery in deliveriesSelected.values) {
      await Navigator.pushNamed(
        context,
        ShowQrcode.routeName,
        arguments: delivery,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('Gerente'),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeliveryStatus.orderRegisteredForPickup.icon,
                    DeliveryStatus.orderReservedForPickup.icon,
                  ],
                ),
              ),
              Tab(
                icon: DeliveryStatus.orderPickedUpForDelivery.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderInTransit.icon,
              ),
              Tab(
                icon: DeliveryStatus.orderClosed.icon,
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(widget.pageController),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'hero_01',
              onPressed: _showQRCode,
              child: const Icon(Icons.qr_code_2),
            ),
            const SizedBox(width: 40),
            FloatingActionButton(
              heroTag: 'hero_02',
              onPressed: _addDelivery,
              child: const Icon(Icons.delivery_dining_rounded),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ShowDeliveryList(
              action: _showInMap,
              selectedIds: deliveriesSelected,
              deliveryStatus: DeliveryStatus.orderRegisteredForPickup,
            ),
            ShowDeliveryList(
              action: _showInMap,
              selectedIds: deliveriesSelected,
              deliveryStatus: DeliveryStatus.orderPickedUpForDelivery,
            ),
            ShowDeliveryList(
              action: _showInMap,
              selectedIds: deliveriesSelected,
              deliveryStatus: DeliveryStatus.orderInTransit,
            ),
            ShowDeliveryList(
              action: _showInMap,
              selectedIds: deliveriesSelected,
              deliveryStatus: DeliveryStatus.orderDelivered,
            ),
          ],
        ),
      ),
    );
  }
}
