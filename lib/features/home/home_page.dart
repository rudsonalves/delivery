import 'dart:math';

import 'package:flutter/material.dart';

import '/features/home/widgets/home_drawer.dart';
import '../../locator.dart';
import '../delivery_person/delivery_person_page.dart';
import '../sign_in/sign_in_page.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ctrl = HomeController();
  final random = Random();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  @override
  void dispose() {
    ctrl.dispose();
    disposeDependencies();

    super.dispose();
  }

  void _logout() async {
    Navigator.pop(context);
    await ctrl.logout();
    if (!ctrl.isLoggedIn) {
      if (mounted) Navigator.pushNamed(context, SignInPage.routeName);
    }
  }

  void _login() {
    Navigator.pop(context);
    Navigator.pushNamed(context, SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: ctrl.app.toogleBrightness,
            icon: ValueListenableBuilder(
                valueListenable: ctrl.app.brightnessNotifier,
                builder: (context, __, _) {
                  return Icon(ctrl.isDark ? Icons.dark_mode : Icons.light_mode);
                }),
          ),
        ],
      ),
      drawer: HomeDrawer(
        controller: ctrl,
        login: _login,
        logout: _logout,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, DeliveryPersonPage.routeName),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
