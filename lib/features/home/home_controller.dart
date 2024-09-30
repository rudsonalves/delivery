import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../stores/user/user_store.dart';

class HomeController {
  final userStore = locator<UserStore>();
  final app = locator<AppSettings>();

  late final PageController pageController;

  bool get isLoggedIn => userStore.isLoggedIn;
  bool get isDark => app.isDark;
  bool get isAdmin => userStore.isAdmin;
  bool get isBusiness => userStore.isBusiness;
  bool get isManager => userStore.isManager;
  bool get isDelivery => userStore.isDeliveryman;

  bool get doesNotHavePhone =>
      currentUser!.phone == null || currentUser!.phone!.isEmpty;
  UserModel? get currentUser => userStore.currentUser;

  UserRole? get role => currentUser?.role;

  String pageTitle = 'None';

  init() {
    // if (isLoggedIn) {
    //   store.setHasPhone(currentUser!.phone != null);
    //   store.setHasAddress(currentUser!.address != null);
    // }

    _setPageTitle();
    pageController = PageController(initialPage: role?.index ?? 0);
  }

  void dispose() {
    pageController.dispose();
  }

  void _setPageTitle() {
    switch (role) {
      case null:
        pageTitle = 'Usuário não logado';
        break;
      case UserRole.admin:
        pageTitle = 'Administrador';
        break;
      case UserRole.business:
        pageTitle = 'Comerciante';
        break;
      case UserRole.delivery:
        pageTitle = 'Entregador';
        break;
      case UserRole.manager:
        pageTitle = 'Gerente de Entregas';
        break;
    }
  }

  Future<void> logout() async {
    if (isLoggedIn) {
      await userStore.logout();
    }
  }
}
