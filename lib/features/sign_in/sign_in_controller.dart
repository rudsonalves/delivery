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
  final focusNode = FocusNode();
  final nextFocusNode = FocusNode();

  UserModel? get currentUser => store.currentUser;
  bool get isLoggedIn => store.isLoggedIn;
  bool get isValid => pageStore.isValid;
  UserState get state => store.state;
  bool get userStatus => store.userStatus;

  Future<void> init() async {}

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    focusNode.dispose();
    nextFocusNode.dispose();
  }

  Future<DataResult<UserModel>> signIn() async {
    return await store.signIn(emailController.text, passwordController.text);
  }

  Future<void> sendPasswordResetEmail() async {
    await store.auth.sendPasswordResetEmail(pageStore.email!);
  }

  Future<void> resendVerificationEmail() async {
    await store.auth.sendSignInLinkToEmail(pageStore.email!);
  }
}
