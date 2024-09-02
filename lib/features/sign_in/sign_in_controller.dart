import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../stores/mobx/sign_in_store.dart';
import '../../stores/user/user_store.dart';

class SignInController {
  final userStore = locator<UserStore>();
  final store = SignInStore();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  User? get currentUser => userStore.currentUser;
  bool get isLoggedIn => userStore.isLoggedIn;
  bool get isValid => store.isValid;
  UserState get state => userStore.state;

  Future<void> init() async {
    userStore.initializeUser();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn() async {
    await userStore.login(emailController.text, passwordController.text);
  }
}
