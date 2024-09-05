import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import '../../stores/mobx/sign_up_store.dart';
import '../../stores/user/user_store.dart';

class SignUpController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  final pageStore = SignUpStore();
  final store = locator<UserStore>();
  final app = locator<AppSettings>();

  UserState get state => store.state;
  bool get isValid => pageStore.isValid;
  bool get isLoggedIn => store.isLoggedIn;
  bool get adminChecked => app.adminChecked;

  void init() {
    store.setState(UserState.stateSuccess);
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
  }

  Future<void> signUp() async {
    final user = UserModel(
      name: pageStore.name!,
      email: pageStore.email!,
      password: pageStore.password!,
      role: pageStore.role,
    );

    await store.signUp(user);
    await store.sendSignInLinkToEmail(user.email);
  }
}
