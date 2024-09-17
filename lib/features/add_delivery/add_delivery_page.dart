import 'package:flutter/material.dart';

import 'add_delivery_controller.dart';

class AddDeliveryPage extends StatefulWidget {
  const AddDeliveryPage({super.key});

  static const routeName = '/ad_delivery';

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  final ctrl = AddDeliveryController();

  void _backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitação de Entrega'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }
}
