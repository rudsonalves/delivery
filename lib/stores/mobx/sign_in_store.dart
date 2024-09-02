import 'package:mobx/mobx.dart';

import '/stores/mobx/generic_functions.dart';

part 'sign_in_store.g.dart';

// ignore: library_private_types_in_public_api
class SignInStore = _SignInStore with _$SignInStore;

abstract class _SignInStore with Store {
  @observable
  String? email;

  @observable
  String? errorEmail;

  @observable
  String? password;

  @observable
  String? errorPassword;

  @action
  void setEmail(String value) {
    email = value;
    _validateEmail();
  }

  @action
  void _validateEmail() {
    errorEmail = StoreFunc.itsNotEmail(email)
        ? 'Por favor, insira um email válido'
        : null;
  }

  @action
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
