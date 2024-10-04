import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../common/models/client.dart';
import '../../../common/models/shop.dart';
import '../../../stores/common/store_func.dart';

part 'add_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class AddDeliveryStore = _AddDeliveryStore with _$AddDeliveryStore;

enum SearchMode { name, phone }

enum NoShopState { unknowError, noShops, ready, waiting }

abstract class _AddDeliveryStore with Store {
  @observable
  ObservableList<ShopModel> shops = ObservableList<ShopModel>();

  @observable
  ObservableList<ClientModel> clients = ObservableList<ClientModel>();

  @observable
  PageState state = PageState.initial;

  @observable
  String? errorMessage;

  @observable
  String? shopId;

  @observable
  ClientModel? selectedClient;

  @observable
  SearchMode searchBy = SearchMode.phone;

  @observable
  NoShopState noShopsState = NoShopState.waiting;

  @action
  void setNoShopState(NoShopState newState) {
    noShopsState = newState;
  }

  @action
  void setError(String? message) {
    errorMessage = message;
    setState(PageState.error);
  }

  @action
  void setState(PageState newState) {
    state = newState;
  }

  @action
  void setShopId(String id) {
    shopId = id;
  }

  @action
  void setShops(List<ShopModel> newShops) {
    shops = ObservableList<ShopModel>.of(newShops);
    noShopsState = shops.isEmpty ? NoShopState.noShops : NoShopState.ready;
  }

  @action
  void setClients(List<ClientModel> newClients) {
    clients = ObservableList<ClientModel>.of(newClients);
  }

  @action
  void toogleSearchBy() {
    searchBy = searchBy == SearchMode.name ? SearchMode.phone : SearchMode.name;
  }

  @action
  void selectClient(ClientModel client) {
    selectedClient = client;
    log(selectedClient!.id ?? '');
  }

  @action
  void reset() {
    state = PageState.initial;
    noShopsState = NoShopState.waiting;
    errorMessage = null;
    shops.clear();
    clients.clear();
    shopId = null;
    selectedClient = null;
    searchBy = SearchMode.name;
  }
}
