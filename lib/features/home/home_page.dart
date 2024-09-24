import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../account_page/account_page.dart';
import '../shops/shops_page.dart';
import '/features/delivery_request/delivery_request_page.dart';
import '/features/clients/clients_page.dart';
import '/features/home/widgets/home_drawer.dart';
import '../../locator.dart';
import '../person_data/person_data_page.dart';
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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (ctrl.doesNotHavePhone) {
        if (kDebugMode) return;
        Navigator.pushNamed(context, PersonDataPage.routeName);
      }
    });

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
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          SignInPage.routeName,
        );
      }
    }
  }

  void _login() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, SignInPage.routeName);
  }

  void _clients() {
    Navigator.pop(context);
    Navigator.pushNamed(context, ClientsPage.routeName);
  }

  void _deliceryRequest() {
    Navigator.pop(context);
    Navigator.pushNamed(context, DeliveryRequestPage.routeName);
  }

  void _storesPage() {
    Navigator.pop(context);
    Navigator.pushNamed(context, ShopsPage.routeName);
  }

  void _accountPage() {
    Navigator.pop(context);
    Navigator.pushNamed(context, AccountPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        elevation: 5,
        actions: [
          ValueListenableBuilder(
            valueListenable: ctrl.app.brightnessNotifier,
            builder: (context, value, _) => IconButton(
              isSelected: value == Brightness.dark,
              onPressed: ctrl.app.toogleBrightness,
              icon: const Icon(Icons.light_mode),
              selectedIcon: const Icon(Icons.dark_mode),
            ),
          ),
        ],
      ),
      drawer: HomeDrawer(
        controller: ctrl,
        clients: _clients,
        login: _login,
        logout: _logout,
        deliceryRequest: _deliceryRequest,
        stores: _storesPage,
        account: _accountPage,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, PersonDataPage.routeName),
        child: const Icon(Icons.delivery_dining_rounded),
      ),
      body: Observer(
        builder: (context) => const Column(),
      ),
    );
  }
}
