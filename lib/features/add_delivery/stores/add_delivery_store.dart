// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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

  bool isValid() {
    return selectedClient?.id != null && shopId != null;
  }
}
