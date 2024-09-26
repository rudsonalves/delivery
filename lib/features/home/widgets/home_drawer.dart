import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../home_controller.dart';
import 'custom_drawer_header.dart';

class HomeDrawer extends StatelessWidget {
  final HomeController controller;
  final void Function() login;
  final void Function() logout;
  final void Function() clients;
  final void Function() stores;
  final void Function() account;

  const HomeDrawer({
    super.key,
    required this.controller,
    required this.login,
    required this.logout,
    required this.clients,
    required this.stores,
    required this.account,
  });

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
          CustomDrawerHeader(controller: controller),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Conta'),
            onTap: account,
          ),
          if (controller.isAdmin ||
              controller.isBusiness ||
              controller.isManager)
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: clients,
            ),
          if (controller.isAdmin || controller.isBusiness)
            ListTile(
              leading: const Icon(Symbols.store),
              title: const Text('Gerenciar Lojas'),
              onTap: stores,
            ),
          if (!controller.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Entrar'),
              onTap: login,
            ),
          if (controller.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: logout,
            ),
        ],
      ),
    );
  }
}
