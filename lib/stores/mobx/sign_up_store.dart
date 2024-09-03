import 'package:mobx/mobx.dart';

import '../../common/models/user.dart';
import 'common/generic_functions.dart';

part 'sign_up_store.g.dart';

// ignore: library_private_types_in_public_api
class SignUpStore = _SignUpStore with _$SignUpStore;

abstract class _SignUpStore with Store {
  String? name;

  @observable
  String? errorName;

  String? email;

  @observable
  String? errorEmail;

  String? phoneNumber;

  @observable
  String? errorPhoneNumber;

  String? password;

  @observable
  String? errorPassword;

  String? checkPassword;

  @observable
  String? errorCheckPassword;

  @observable
  UserRole role = UserRole.delivery;

  void setName(String value) {
    name = value;
    _validateName();
  }

  @action
  void _validateName() {
    errorName = (name == null || name!.isEmpty) ? 'Nome é obrigatório' : null;
  }

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

  void setPhone(String value) {
    phoneNumber = value;
    _validatePhoneNumber();
  }

  @action
  void _validatePhoneNumber() {
    errorPhoneNumber = null;
    final numbers = phoneNumber!.replaceAll(RegExp(r'[^\d]'), '');
    if (numbers.length != 11) {
      errorPhoneNumber = 'Número de telefone inválido';
    }
  }

  void setPassword(String value) {
    password = value;
    _validatePassword();
  }

  @action
  void _validatePassword() {
    if (password == null || password!.length < 6) {
      errorPassword = 'Senha menor que 6 caracteres';
      return;
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');
    errorPassword =
        regex.hasMatch(password!) ? null : 'Senha deve conter números e letras';
  }

  void setCheckPassword(String value) {
    checkPassword = value;
    _validateCheckPassword();
  }

  @action
  void _validateCheckPassword() {
    errorCheckPassword = (password == null || password != checkPassword)
        ? 'Senhas diferem!'
        : null;
  }

  @action
  void setRole(UserRole value) {
    role = value;
  }

  bool get isValid {
    _validateName();
    _validateEmail();
    _validatePhoneNumber();
    _validatePassword();
    _validateCheckPassword();

    return errorName == null &&
        errorEmail == null &&
        errorPhoneNumber == null &&
        errorPassword == null &&
        errorCheckPassword == null;
  }

  @action
  void reset() {
    name = null;
    email = null;
    phoneNumber = null;
    password = null;
    checkPassword = null;
    errorName = null;
    errorEmail = null;
    errorPhoneNumber = null;
    errorPassword = null;
    errorCheckPassword = null;
  }
}
