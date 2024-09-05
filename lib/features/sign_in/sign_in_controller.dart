import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../../stores/mobx/sign_in_store.dart';
import '../../stores/user/user_store.dart';

class SignInController {
  final store = locator<UserStore>();
  final app = locator<AppSettings>();
  final pageStore = SignInStore();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserModel? get currentUser => store.currentUser;
  bool get isLoggedIn => store.isLoggedIn;
  bool get isValid => pageStore.isValid;
  UserState get state => store.state;

  Future<void> init() async {
    await store.initializeUser();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<DataResult<UserModel>> signIn() async {
    return await store.signIn(emailController.text, passwordController.text);
  }
}
