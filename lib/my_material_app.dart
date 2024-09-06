import 'package:delivery/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

import '/features/home/home_page.dart';
import 'common/settings/app_settings.dart';
import 'common/theme/theme.dart';
import 'common/theme/util.dart';
import 'features/person_data/person_data_page.dart';
import '/features/sign_in/sign_in_page.dart';
import '/features/sign_up/sign_up_page.dart';
import 'locator.dart';

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  final appSettings = locator<AppSettings>();

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
            // home: const HomePage(),
            initialRoute: SplashPage.routeName,
            routes: {
              SplashPage.routeName: (_) => const SplashPage(),
              HomePage.routeName: (_) => const HomePage(),
              SignUpPage.routeName: (_) => const SignUpPage(),
              SignInPage.routeName: (_) => const SignInPage(),
              PersonDataPage.routeName: (_) => const PersonDataPage(),
            },
          );
        });
  }
}
