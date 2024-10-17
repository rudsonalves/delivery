// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/settings/app_settings.dart';
import '../../locator.dart';
import 'stores/sign_up_store.dart';
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
