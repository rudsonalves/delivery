import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/firebase/firebase_auth_repository.dart';

class HomeController {
  StreamSubscription<User?>? _authSubscription;

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
}
