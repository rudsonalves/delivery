// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AccountStore on _AccountStore, Store {
  late final _$showQRCodeAtom =
      Atom(name: '_AccountStore.showQRCode', context: context);

  @override
  bool get showQRCode {
    _$showQRCodeAtom.reportRead();
    return super.showQRCode;
  }

  @override
  set showQRCode(bool value) {
    _$showQRCodeAtom.reportWrite(value, super.showQRCode, () {
      super.showQRCode = value;
    });
  }

  late final _$_AccountStoreActionController =
      ActionController(name: '_AccountStore', context: context);

  @override
  void toogleShowQRCode() {
    final _$actionInfo = _$_AccountStoreActionController.startAction(
        name: '_AccountStore.toogleShowQRCode');
    try {
      return super.toogleShowQRCode();
    } finally {
      _$_AccountStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showQRCode: ${showQRCode}
    ''';
  }
}
