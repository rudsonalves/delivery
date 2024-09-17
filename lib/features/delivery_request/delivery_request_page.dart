import 'package:flutter/material.dart';

import '/features/add_delivery/add_delivery_page.dart';
import 'delivery_request_controller.dart';

class DeliveryRequestPage extends StatefulWidget {
  const DeliveryRequestPage({super.key});

  static const routeName = '/delivery_request';

  @override
  State<DeliveryRequestPage> createState() => _DeliveryRequestPageState();
}

class _DeliveryRequestPageState extends State<DeliveryRequestPage> {
  final ctrl = DeliveryRequestController();

  void _addDelivery() {
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  void _backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDelivery,
        child: const Icon(Icons.add),
      ),
    );
  }
}
