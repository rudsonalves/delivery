// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_delivery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddDeliveryStore on _AddDeliveryStore, Store {
  late final _$shopsAtom =
      Atom(name: '_AddDeliveryStore.shops', context: context);

  @override
  List<ShopModel> get shops {
    _$shopsAtom.reportRead();
    return super.shops;
  }

  @override
  set shops(List<ShopModel> value) {
    _$shopsAtom.reportWrite(value, super.shops, () {
      super.shops = value;
    });
  }

  late final _$clientsAtom =
      Atom(name: '_AddDeliveryStore.clients', context: context);

  @override
  List<ClientModel> get clients {
    _$clientsAtom.reportRead();
    return super.clients;
  }

  @override
  set clients(List<ClientModel> value) {
    _$clientsAtom.reportWrite(value, super.clients, () {
      super.clients = value;
    });
  }

  late final _$stateAtom =
      Atom(name: '_AddDeliveryStore.state', context: context);

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

  late final _$shopIdAtom =
      Atom(name: '_AddDeliveryStore.shopId', context: context);

  @override
  String? get shopId {
    _$shopIdAtom.reportRead();
    return super.shopId;
  }

  @override
  set shopId(String? value) {
    _$shopIdAtom.reportWrite(value, super.shopId, () {
      super.shopId = value;
    });
  }

  late final _$selectedClientAtom =
      Atom(name: '_AddDeliveryStore.selectedClient', context: context);

  @override
  ClientModel? get selectedClient {
    _$selectedClientAtom.reportRead();
    return super.selectedClient;
  }

  @override
  set selectedClient(ClientModel? value) {
    _$selectedClientAtom.reportWrite(value, super.selectedClient, () {
      super.selectedClient = value;
    });
  }

  late final _$searchByAtom =
      Atom(name: '_AddDeliveryStore.searchBy', context: context);

  @override
  SearchMode get searchBy {
    _$searchByAtom.reportRead();
    return super.searchBy;
  }

  @override
  set searchBy(SearchMode value) {
    _$searchByAtom.reportWrite(value, super.searchBy, () {
      super.searchBy = value;
    });
  }

  late final _$searchClientsByNameAsyncAction =
      AsyncAction('_AddDeliveryStore.searchClientsByName', context: context);

  @override
  Future<void> searchClientsByName(String name) {
    return _$searchClientsByNameAsyncAction
        .run(() => super.searchClientsByName(name));
  }

  late final _$searchClentsByPhoneAsyncAction =
      AsyncAction('_AddDeliveryStore.searchClentsByPhone', context: context);

  @override
  Future<void> searchClentsByPhone(String phone) {
    return _$searchClentsByPhoneAsyncAction
        .run(() => super.searchClentsByPhone(phone));
  }

  late final _$_AddDeliveryStoreActionController =
      ActionController(name: '_AddDeliveryStore', context: context);

  @override
  dynamic init() {
    final _$actionInfo = _$_AddDeliveryStoreActionController.startAction(
        name: '_AddDeliveryStore.init');
    try {
      return super.init();
    } finally {
      _$_AddDeliveryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getInLocalStore() {
    final _$actionInfo = _$_AddDeliveryStoreActionController.startAction(
        name: '_AddDeliveryStore.getInLocalStore');
    try {
      return super.getInLocalStore();
    } finally {
      _$_AddDeliveryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShopId(String value) {
    final _$actionInfo = _$_AddDeliveryStoreActionController.startAction(
        name: '_AddDeliveryStore.setShopId');
    try {
      return super.setShopId(value);
    } finally {
      _$_AddDeliveryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toogleSearchBy() {
    final _$actionInfo = _$_AddDeliveryStoreActionController.startAction(
        name: '_AddDeliveryStore.toogleSearchBy');
    try {
      return super.toogleSearchBy();
    } finally {
      _$_AddDeliveryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectClient(ClientModel client) {
    final _$actionInfo = _$_AddDeliveryStoreActionController.startAction(
        name: '_AddDeliveryStore.selectClient');
    try {
      return super.selectClient(client);
    } finally {
      _$_AddDeliveryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
shops: ${shops},
clients: ${clients},
state: ${state},
shopId: ${shopId},
selectedClient: ${selectedClient},
searchBy: ${searchBy}
    ''';
  }
}
