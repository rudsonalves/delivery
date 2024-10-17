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

import 'package:mobx/mobx.dart';

import '../../../stores/common/store_func.dart';

part 'sign_in_store.g.dart';

// ignore: library_private_types_in_public_api
class SignInStore = _SignInStore with _$SignInStore;

abstract class _SignInStore with Store {
  String? email;

  @observable
  String? errorEmail;

  String? password;

  @observable
  String? errorPassword;

  void setEmail(String value) {
    email = value;
    _validateEmail();
  }

  @action
  bool isEmailValid() {
    _validateEmail();
    return errorEmail == null;
  }

  @action
  void _validateEmail() {
    errorEmail = StoreFunc.itsNotEmail(email)
        ? 'Por favor, insira um email válido'
        : null;
  }

  void setPassword(String value) {
    password = value;
    _validatePassword();
  }

  @action
  void _validatePassword() {
    errorPassword = (password == null || password!.length < 6)
        ? 'Senha menor que 6 caracteres'
        : null;
  }

  bool get isValid {
    _validatePassword();
    _validatePassword();

    return errorEmail == null && errorPassword == null;
  }

  @action
  void reset() {
    email = null;
    password = null;
    errorEmail = null;
    errorPassword = null;
  }
}
