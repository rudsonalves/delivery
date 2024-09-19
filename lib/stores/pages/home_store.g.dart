// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$hasPhoneAtom =
      Atom(name: '_HomeStore.hasPhone', context: context);

  @override
  bool get hasPhone {
    _$hasPhoneAtom.reportRead();
    return super.hasPhone;
  }

  @override
  set hasPhone(bool value) {
    _$hasPhoneAtom.reportWrite(value, super.hasPhone, () {
      super.hasPhone = value;
    });
  }

  late final _$hasAddressAtom =
      Atom(name: '_HomeStore.hasAddress', context: context);

  @override
  bool get hasAddress {
    _$hasAddressAtom.reportRead();
    return super.hasAddress;
  }

  @override
  set hasAddress(bool value) {
    _$hasAddressAtom.reportWrite(value, super.hasAddress, () {
      super.hasAddress = value;
    });
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  dynamic setHasPhone(bool value) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setHasPhone');
    try {
      return super.setHasPhone(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setHasAddress(bool value) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setHasAddress');
    try {
      return super.setHasAddress(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hasPhone: ${hasPhone},
hasAddress: ${hasAddress}
    ''';
  }
}
