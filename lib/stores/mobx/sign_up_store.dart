import 'package:mobx/mobx.dart';

part 'sign_up_store.g.dart';

enum Status { initial, loading, success, error }

// ignore: library_private_types_in_public_api
class SignUpStore = _SignUpStore with _$SignUpStore;

abstract class _SignUpStore with Store {
  @observable
  String? name;

  @observable
  String? errorName;

  @observable
  String? email;

  @observable
  String? errorEmail;

  @observable
  String? password;

  @observable
  String? errorPassword;

  @observable
  String? checkPassword;

  @observable
  String? errorCheckPassword;

  @action
  void setName(String value) {
    name = value;
    validateName();
  }

  @action
  void validateName() {
    errorName = (name == null || name!.isEmpty) ? 'Nome é obrigatório' : null;
  }

  @action
  void setEmail(String value) {
    email = value;
    validateEmail();
  }

  @action
  void validateEmail() {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    errorEmail = (email == null || email!.isEmpty || !regex.hasMatch(email!))
        ? 'E-mail válido'
        : null;
  }

  @action
  void setPassword(String value) {
    password = value;
    validatePassword();
  }

  @action
  void validatePassword() {
    if (password == null || password!.length < 6) {
      errorPassword = 'Senha menor que 6 caracteres';
      return;
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');
    errorPassword =
        regex.hasMatch(password!) ? null : 'Senha deve conter números e letras';
  }

  @action
  void setCheckPassword(String value) {
    checkPassword = value;
    validateCheckPassword();
  }

  @action
  void validateCheckPassword() {
    errorCheckPassword = (password == null || password != checkPassword)
        ? 'Senhas diferem!'
        : null;
  }
}
