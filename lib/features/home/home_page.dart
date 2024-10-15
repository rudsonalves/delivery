import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../components/widgets/main_drawer/custom_drawer.dart';
import '../../stores/user/user_store.dart';
import '../user_delivery/user_delivery_page.dart';
import '/features/user_business/user_business_page.dart';
import '/features/user_manager/user_manager_page.dart';
import '/features/user_admin/user_admin_page.dart';
import '../../locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userStore = locator<UserStore>();
  UserModel? get currentUser => userStore.currentUser;
  UserRole? get role => currentUser?.role;

  late final PageController pageController;
  final random = Random();

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: role?.index ?? 0);
  }

  @override
  void dispose() {
    disposeDependencies();
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(ctrl.pageTitle),
      //   centerTitle: true,
      //   elevation: 5,
      //   actions: [
      //     ValueListenableBuilder(
      //       valueListenable: ctrl.app.brightnessNotifier,
      //       builder: (context, value, _) => IconButton(
      //         isSelected: value == Brightness.dark,
      //         onPressed: ctrl.app.toogleBrightness,
      //         icon: const Icon(Icons.light_mode),
      //         selectedIcon: const Icon(Icons.dark_mode),
      //       ),
      //     ),
      //   ],
      // ),
      drawer: CustomDrawer(pageController),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          UserAdminPage(pageController),
          UserBusinessPage(pageController),
          UserDeliveryPage(pageController),
          UserManagerPage(pageController),
        ],
      ),
    );
  }
}
