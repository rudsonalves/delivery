import 'package:flutter/material.dart';

import 'user_delivery_controller.dart';

class UserDeliveryPage extends StatefulWidget {
  const UserDeliveryPage({super.key});

  @override
  State<UserDeliveryPage> createState() => _UserDeliveryPageState();
}

class _UserDeliveryPageState extends State<UserDeliveryPage> {
  final ctrl = UserDeliveryController();

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
