import 'package:flutter/material.dart';

import '/features/home/home_page.dart';
import 'common/settings/app_settings.dart';
import 'common/theme/theme.dart';
import 'common/theme/util.dart';
import 'features/delivery_person/delivery_person_page.dart';

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  final appSettings = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);

    return ValueListenableBuilder(
        valueListenable: appSettings.brightnessNotifier,
        builder: (context, brightness, _) {
          return MaterialApp(
            theme:
                brightness == Brightness.light ? theme.light() : theme.dark(),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
            routes: {
              HomePage.routeName: (_) => const HomePage(),
              DeliveryPersonPage.routeName: (_) => const DeliveryPersonPage(),
            },
          );
        });
  }
}
