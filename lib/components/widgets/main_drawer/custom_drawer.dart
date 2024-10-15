import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../features/account/account_page.dart';
import '../../../features/clients/clients_page.dart';
import '../../../features/shops/shops_page.dart';
import '../../../features/sign_in/sign_in_page.dart';
import 'custom_drawer_controller.dart';
import 'custom_drawer_header.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  const CustomDrawer(
    this.pageController, {
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late final CustomDrawerController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = CustomDrawerController(widget.pageController);
  }

  @override
  void dispose() {
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

  void _stores() {
    Navigator.pop(context);
    Navigator.pushNamed(context, ShopsPage.routeName);
  }

  void _account() {
    Navigator.pop(context);
    Navigator.pushNamed(context, AccountPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.onSecondary.withOpacity(0.90),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: ListView(
        children: [
          CustomDrawerHeader(controller: ctrl),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Conta'),
            onTap: _account,
          ),
          if (ctrl.isAdmin || ctrl.isBusiness || ctrl.isManager)
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: _clients,
            ),
          if (ctrl.isAdmin || ctrl.isBusiness)
            ListTile(
              leading: const Icon(Symbols.store),
              title: const Text('Gerenciar Lojas'),
              onTap: _stores,
            ),
          if (!ctrl.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Entrar'),
              onTap: _login,
            ),
          if (ctrl.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: _logout,
            ),
        ],
      ),
    );
  }
}
