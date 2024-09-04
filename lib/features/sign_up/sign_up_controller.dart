import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../components/custons_text_controllers/masked_text_controller.dart';
import '../../locator.dart';
import '../../stores/mobx/sign_up_store.dart';
import '../../stores/user/user_store.dart';

class SignUpController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) #####-####');

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
      phone: pageStore.phoneNumber!,
      password: pageStore.password!,
      role: pageStore.role,
    );

    await store.signUp(user);
  }
}
