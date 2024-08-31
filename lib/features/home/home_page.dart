import 'package:flutter/material.dart';

import '../../common/settings/app_settings.dart';
import '../delivery_person/delivery_person_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final app = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: app.toogleBrightness,
            icon: ValueListenableBuilder(
                valueListenable: app.brightnessNotifier,
                builder: (context, __, _) {
                  return Icon(app.isDark ? Icons.dark_mode : Icons.light_mode);
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, DeliveryPersonPage.routeName),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
