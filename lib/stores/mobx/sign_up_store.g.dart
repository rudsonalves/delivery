// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on _SignUpStore, Store {
  late final _$nameAtom = Atom(name: '_SignUpStore.name', context: context);

  @override
  String? get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String? value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$errorNameAtom =
      Atom(name: '_SignUpStore.errorName', context: context);

  @override
  String? get errorName {
    _$errorNameAtom.reportRead();
    return super.errorName;
  }

  @override
  set errorName(String? value) {
    _$errorNameAtom.reportWrite(value, super.errorName, () {
      super.errorName = value;
    });
  }

  late final _$emailAtom = Atom(name: '_SignUpStore.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$errorEmailAtom =
      Atom(name: '_SignUpStore.errorEmail', context: context);

  @override
  String? get errorEmail {
    _$errorEmailAtom.reportRead();
    return super.errorEmail;
  }

  @override
  set errorEmail(String? value) {
    _$errorEmailAtom.reportWrite(value, super.errorEmail, () {
      super.errorEmail = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_SignUpStore.password', context: context);

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$errorPasswordAtom =
      Atom(name: '_SignUpStore.errorPassword', context: context);

  @override
  String? get errorPassword {
    _$errorPasswordAtom.reportRead();
    return super.errorPassword;
  }

  @override
  set errorPassword(String? value) {
    _$errorPasswordAtom.reportWrite(value, super.errorPassword, () {
      super.errorPassword = value;
    });
  }

  late final _$checkPasswordAtom =
      Atom(name: '_SignUpStore.checkPassword', context: context);

  @override
  String? get checkPassword {
    _$checkPasswordAtom.reportRead();
    return super.checkPassword;
  }

  @override
  set checkPassword(String? value) {
    _$checkPasswordAtom.reportWrite(value, super.checkPassword, () {
      super.checkPassword = value;
    });
  }

  late final _$errorCheckPasswordAtom =
      Atom(name: '_SignUpStore.errorCheckPassword', context: context);

  @override
  String? get errorCheckPassword {
    _$errorCheckPasswordAtom.reportRead();
    return super.errorCheckPassword;
  }

  @override
  set errorCheckPassword(String? value) {
    _$errorCheckPasswordAtom.reportWrite(value, super.errorCheckPassword, () {
      super.errorCheckPassword = value;
    });
  }

  late final _$_SignUpStoreActionController =
      ActionController(name: '_SignUpStore', context: context);

  @override
  void setName(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateName() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.validateName');
    try {
      return super.validateName();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateEmail() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.validateEmail');
    try {
      return super.validateEmail();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validatePassword() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.validatePassword');
    try {
      return super.validatePassword();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCheckPassword(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setCheckPassword');
    try {
      return super.setCheckPassword(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateCheckPassword() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.validateCheckPassword');
    try {
      return super.validateCheckPassword();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
errorName: ${errorName},
email: ${email},
errorEmail: ${errorEmail},
password: ${password},
errorPassword: ${errorPassword},
checkPassword: ${checkPassword},
errorCheckPassword: ${errorCheckPassword}
    ''';
  }
}
