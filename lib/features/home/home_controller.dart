import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../stores/user/user_store.dart';

class HomeController {
  StreamSubscription<User?>? _authSubscription;
  final userStore = locator<UserStore>();
  final app = locator<AppSettings>();

  bool get isLoggedIn => userStore.isLoggedIn;
  bool get isDark => app.isDark;
  UserModel? get currentUser => userStore.currentUser;

  init() {}

  void dispose() {
    _authSubscription?.cancel();
  }

  Future<void> logout() async {
    if (isLoggedIn) await userStore.logout();
  }
}
