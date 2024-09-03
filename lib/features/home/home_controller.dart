import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../repository/firebase/firebase_auth_repository.dart';
import '../../stores/user/user_store.dart';

class HomeController {
  StreamSubscription<User?>? _authSubscription;
  final userStore = locator<UserStore>();
  final app = locator<AppSettings>();

  bool get isLoggedIn => userStore.isLoggedIn;
  bool get isDark => app.isDark;

  init() {
    // Subscribes to user status changes
    _authSubscription = FirebaseAuthRepository.userChanges(
      notLogged: _handleNotLogged,
      logged: _handleLogged,
      onError: (error) {
        log('Authentication stream error: $error');
      },
    );
  }

  void _handleNotLogged() {
    // FIXME: settings to not logged user
  }

  void _handleLogged() {
    // FIXME: settings to logged user
  }

  void dispose() {
    _authSubscription?.cancel();
  }

  Future<void> logout() async {
    if (isLoggedIn) await userStore.logout();
  }
}
