import 'dart:math';

import 'package:flutter/material.dart';

import '../home_controller.dart';

class HomeDrawer extends StatelessWidget {
  final HomeController controller;
  final void Function() login;
  final void Function() logout;

  const HomeDrawer({
    super.key,
    required this.controller,
    required this.login,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final random = Random();

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
          DrawerHeader(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/delivery_0${random.nextInt(5)}.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.isDark
                          ? colorScheme.onSecondary.withOpacity(0.7)
                          : colorScheme.secondary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 10),
                  child: Image.asset('assets/images/delivery_name.png'),
                ),
              ],
            ),
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
