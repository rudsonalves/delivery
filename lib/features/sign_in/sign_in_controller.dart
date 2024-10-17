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
import '../../common/utils/data_result.dart';
import '../../locator.dart';
import 'stores/sign_in_store.dart';
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
