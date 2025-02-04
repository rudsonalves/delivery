// Copyright (C) 2024 Rudson Alves
//
// This file is part of delivery.
//
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '/common/models/delivery.dart';
import 'common/models/shop.dart';
import 'features/account/account_page.dart';
import 'features/add_delivery/add_delivery_page.dart';
import 'features/add_shop/add_shop_page.dart';
import 'features/delivery_qrcode/delivery_qrcode.dart';
import 'features/map/map_page.dart';
import 'features/qrcode_read/qrcode_read_page.dart';
import 'features/show_qrcode/show_qrcode.dart';
import 'features/splash/splash_page.dart';
import 'features/home/home_page.dart';
import 'common/models/client.dart';
import 'common/settings/app_settings.dart';
import 'common/theme/theme.dart';
import 'common/theme/util.dart';
import 'features/add_client/add_cliend_page.dart';
import 'features/clients/clients_page.dart';
import 'features/person_data/person_data_page.dart';
import 'features/sign_in/sign_in_page.dart';
import 'features/sign_up/sign_up_page.dart';
import 'features/shops/shops_page.dart';
import 'features/user_delivery/delivery_map/delivery_map_page.dart';
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
              ClientsPage.routeName: (_) => const ClientsPage(),
              AddDeliveryPage.routeName: (_) => const AddDeliveryPage(),
              ShopsPage.routeName: (_) => const ShopsPage(),
              AccountPage.routeName: (_) => const AccountPage(),
              QRCodeReadPage.routeName: (_) => const QRCodeReadPage(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case DeliveryMapPage.routeName:
                  return MaterialPageRoute(builder: (_) {
                    final deliveries =
                        settings.arguments as List<DeliveryModel>;
                    return DeliveryMapPage(deliveries);
                  });
                case ShowQrcode.routeName:
                  return MaterialPageRoute(builder: (_) {
                    final delivery = settings.arguments as dynamic;
                    return ShowQrcode(delivery);
                  });
                case DeliveryQrcode.routeName:
                  return MaterialPageRoute(builder: (_) {
                    final delivery = settings.arguments as DeliveryModel;
                    return DeliveryQrcode(delivery);
                  });
                case MapPage.routeName:
                  return MaterialPageRoute(builder: (_) {
                    final delivery = settings.arguments as DeliveryModel;
                    return MapPage(delivery);
                  });
                case AddClientPage.routeName:
                  return MaterialPageRoute(builder: (_) {
                    final client = settings.arguments as ClientModel?;
                    return AddClientPage(client);
                  });
                case AddShopPage.routeName:
                  return MaterialPageRoute(builder: (_) {
                    final shop = settings.arguments as ShopModel?;
                    return AddShopPage(shop);
                  });
                default:
                  return null;
              }
            },
          );
        });
  }
}
