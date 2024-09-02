import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../locator.dart';
import '../../stores/mobx/sign_up_store.dart';
import '../../stores/user/user_store.dart';

class SignUpController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  // final phoneController = MaskedTextController(mask: '(##) #####-####');

  final singUpStore = SignUpStore();
  final userStore = locator<UserStore>();

  UserState get state => userStore.state;
  bool get isValid => singUpStore.isValid;

  void init() {
    userStore.setState(UserState.stateSuccess);
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
  }

  Future<void> signUp() async {
    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
      // phone: phoneController.text,
      password: passwordController.text,
    );

    await userStore.signUp(user);
  }
}
