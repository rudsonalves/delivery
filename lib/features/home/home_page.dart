import 'package:flutter/material.dart';

import '../../common/settings/app_settings.dart';
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
  final app = locator<AppSettings>();
  final ctrl = HomeController();

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
      drawer: Drawer(
        backgroundColor: app.isDark
            ? colorScheme.onSecondary.withOpacity(0.90)
            : colorScheme.onPrimary.withOpacity(0.90),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset(
                'assets/images/delivery_01.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                Navigator.pop(context);
                await ctrl.logout();
                if (!ctrl.isLoggedIn) {
                  if (context.mounted) {
                    Navigator.pushNamed(context, SignInPage.routeName);
                  }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, DeliveryPersonPage.routeName),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
