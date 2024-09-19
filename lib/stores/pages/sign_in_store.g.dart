// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignInStore on _SignInStore, Store {
  late final _$errorEmailAtom =
      Atom(name: '_SignInStore.errorEmail', context: context);

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
      Atom(name: '_SignInStore.errorPassword', context: context);

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

  late final _$_SignInStoreActionController =
      ActionController(name: '_SignInStore', context: context);

  @override
  bool isEmailValid() {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore.isEmailValid');
    try {
      return super.isEmailValid();
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validateEmail() {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore._validateEmail');
    try {
      return super._validateEmail();
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validatePassword() {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore._validatePassword');
    try {
      return super._validatePassword();
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo =
        _$_SignInStoreActionController.startAction(name: '_SignInStore.reset');
    try {
      return super.reset();
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
errorEmail: ${errorEmail},
errorPassword: ${errorPassword}
    ''';
  }
}
