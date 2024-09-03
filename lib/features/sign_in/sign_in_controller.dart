import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../locator.dart';
import '../../stores/mobx/sign_in_store.dart';
import '../../stores/user/user_store.dart';

class SignInController {
  final store = locator<UserStore>();
  final pageStore = SignInStore();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserModel? get currentUser => store.currentUser;
  bool get isLoggedIn => store.isLoggedIn;
  bool get isValid => pageStore.isValid;
  UserState get state => store.state;

  Future<void> init() async {
    store.initializeUser();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn() async {
    await store.login(emailController.text, passwordController.text);
  }
}
