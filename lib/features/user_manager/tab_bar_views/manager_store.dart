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

import 'package:delivery/common/models/shop.dart';
import 'package:flutter/material.dart';

import '../../../common/models/delivery.dart';
import '../../../stores/common/store_func.dart';

class ManagerStore {
  final state = ValueNotifier<PageState>(PageState.initial);

  final List<DeliveryModel> deliveries = [];

  String? errorMessage;

  String? shopId;

  final shops = ValueNotifier<List<ShopModel>>([]);

  setShops(List<ShopModel> newShops) {
    shops.value = newShops;
  }

  void setPageState(PageState newState) {
    state.value = newState;
  }

  void setShopId(String value) {
    shopId = value;
  }

  void setDeliveries(List<DeliveryModel> newDeliveries) {
    deliveries.clear();
    deliveries.addAll(newDeliveries);
  }

  void setError(String message) {
    errorMessage = message;
    setPageState(PageState.error);
  }

  void dispose() {
    state.dispose();
    shops.dispose();
  }
}
