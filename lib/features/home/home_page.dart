import 'dart:math';

import 'package:flutter/material.dart';

import '../neaby_deliveries/neaby_deliveries_page.dart';
import '/features/user_business/user_business_page.dart';
import '/features/user_manager/user_manager_page.dart';
import '/features/user_admin/user_admin_page.dart';
import '../account/account_page.dart';
import '../shops/shops_page.dart';
import '../clients/clients_page.dart';
import 'widgets/home_drawer.dart';
import '../../locator.dart';
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
        title: Text(ctrl.pageTitle),
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
        stores: _storesPage,
        account: _accountPage,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: ctrl.pageController,
        children: const [
          UserAdminPage(),
          UserBusinessPage(),
          NeabyDeliveriesPage(),
          UserManagerPage(),
        ],
      ),
    );
  }
}
