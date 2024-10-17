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

import '../../../common/models/shop_delivery_info.dart';
import '../../../stores/common/store_func.dart';

part 'user_delivery_store.g.dart';

// ignore: library_private_types_in_public_api
class UserDeliveryStore = _UserDeliveryStore with _$UserDeliveryStore;

abstract class _UserDeliveryStore with Store {
  @observable
  PageState state = PageState.initial;

  @observable
  ObservableList<ShopDeliveryInfo> deliveries =
      ObservableList<ShopDeliveryInfo>();

  @observable
  String? errorMessage;

  @observable
  double radiusInKm = 5.0; // Default radius

  @action
  void setState(PageState newState) {
    state = newState;
  }

  @action
  void setDeliveries(List<ShopDeliveryInfo> newDeliveries) {
    deliveries = ObservableList<ShopDeliveryInfo>.of(newDeliveries);
  }

  @action
  void setError(String message) {
    errorMessage = message;
    setState(PageState.error);
  }

  @action
  void cleanError() {
    errorMessage = null;
    setState(PageState.initial);
  }

  @action
  void setRadius(double newRadius) {
    radiusInKm = newRadius;
  }
}
