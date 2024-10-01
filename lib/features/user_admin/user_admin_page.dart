import 'package:delivery/features/user_admin/user_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/models/delivery.dart';
import '../add_delivery/add_delivery_page.dart';
import '../../components/widgets/delivery_card.dart';
import '../map/map_page.dart';

class UserAdminPage extends StatefulWidget {
  const UserAdminPage({super.key});

  @override
  State<UserAdminPage> createState() => _UserAdminPageState();
}

class _UserAdminPageState extends State<UserAdminPage> {
  final ctrl = UserAdminController();

  @override
  void initState() {
    super.initState();
    ctrl.init();
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
    // Navigator.pushNamed(context, PersonDataPage.routeName);
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addDelivery,
        child: const Icon(Icons.delivery_dining_rounded),
      ),
      body: Observer(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8),
          child: StreamBuilder<List<DeliveryModel>>(
            stream: ctrl.deliveryRepository.getByShopId('HM8z3Rwzv7ZPK5qlOWcq'),
            builder: (context, snapshot) {
              List<DeliveryModel> deliveries = snapshot.data ?? [];

              return ListView.builder(
                itemCount: deliveries.length,
                itemBuilder: (context, index) {
                  final delivery = deliveries[index];

                  return DeliveryCard(
                    delivery: delivery,
                    showInMap: _showInMap,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
