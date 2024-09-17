// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shops_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ShopsStore on _ShopsStore, Store {
  late final _$stateAtom = Atom(name: '_ShopsStore.state', context: context);

  @override
  PageState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(PageState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$_ShopsStoreActionController =
      ActionController(name: '_ShopsStore', context: context);

  @override
  dynamic setState(PageState newState) {
    final _$actionInfo =
        _$_ShopsStoreActionController.startAction(name: '_ShopsStore.setState');
    try {
      return super.setState(newState);
    } finally {
      _$_ShopsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
