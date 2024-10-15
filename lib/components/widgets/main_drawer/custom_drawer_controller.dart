import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/models/user.dart';
import '../../../common/settings/app_settings.dart';
import '../../../locator.dart';
import '../../../stores/user/user_store.dart';

class CustomDrawerController {
  late final PageController pageController;

  CustomDrawerController(this.pageController);

  final userStore = locator<UserStore>();
  final app = locator<AppSettings>();

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

  String get pageTitle {
    switch (role) {
      case null:
        return 'Usuário não logado';
      case UserRole.admin:
        return 'Administrador';
      case UserRole.business:
        return 'Comerciante';
      case UserRole.delivery:
        return 'Entregador';
      case UserRole.manager:
        return 'Gerente de Entregas';
    }
  }

  Future<void> logout() async {
    if (isLoggedIn) {
      await userStore.logout();
    }
  }
}
