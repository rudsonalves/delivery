import 'package:flutter/material.dart';

import '../../stores/pages/user_delivery_store.dart';
import 'user_delivery_controller.dart';

class UserDeliveryPage extends StatefulWidget {
  const UserDeliveryPage({super.key});

  @override
  State<UserDeliveryPage> createState() => _UserDeliveryPageState();
}

class _UserDeliveryPageState extends State<UserDeliveryPage> {
  final ctrl = UserDeliveryController();
  final store = UserDeliveryStore();

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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('User Delivery Page'),
        ],
      ),
    );
  }
}
