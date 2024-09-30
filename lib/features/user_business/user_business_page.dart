import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/components/widgets/delivery_card.dart';
import '/features/user_business/user_business_controller.dart';
import '../../common/models/delivery.dart';
import '../add_delivery/add_delivery_page.dart';
import '../map/map_page.dart';

class UserBusinessPage extends StatefulWidget {
  const UserBusinessPage({super.key});

  @override
  State<UserBusinessPage> createState() => _UserBusinessPageState();
}

class _UserBusinessPageState extends State<UserBusinessPage> {
  final ctrl = UserBusinessController();

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
          child: ctrl.currentUser != null
              ? StreamBuilder<List<DeliveryModel>>(
                  stream: ctrl.deliveryRepository
                      .streamDeliveryByOwnerId(ctrl.currentUser!.id!),
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
                )
              : null,
        ),
      ),
    );
  }
}
