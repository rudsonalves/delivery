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
