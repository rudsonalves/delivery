// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on _SignUpStore, Store {
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

  late final _$roleAtom = Atom(name: '_SignUpStore.role', context: context);

  @override
  UserRole get role {
    _$roleAtom.reportRead();
    return super.role;
  }

  @override
  set role(UserRole value) {
    _$roleAtom.reportWrite(value, super.role, () {
      super.role = value;
    });
  }

  late final _$_SignUpStoreActionController =
      ActionController(name: '_SignUpStore', context: context);

  @override
  void _validateName() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore._validateName');
    try {
      return super._validateName();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validateEmail() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore._validateEmail');
    try {
      return super._validateEmail();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validatePassword() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore._validatePassword');
    try {
      return super._validatePassword();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validateCheckPassword() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore._validateCheckPassword');
    try {
      return super._validateCheckPassword();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRole(UserRole value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setRole');
    try {
      return super.setRole(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo =
        _$_SignUpStoreActionController.startAction(name: '_SignUpStore.reset');
    try {
      return super.reset();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
errorName: ${errorName},
errorEmail: ${errorEmail},
errorPassword: ${errorPassword},
errorCheckPassword: ${errorCheckPassword},
role: ${role}
    ''';
  }
}
