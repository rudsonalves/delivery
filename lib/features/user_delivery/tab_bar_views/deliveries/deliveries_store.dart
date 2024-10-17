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

import 'package:flutter/foundation.dart';

import '../../../../common/models/delivery.dart';
import '../../../../stores/common/store_func.dart';

class DeliveriesStore {
  final state = ValueNotifier<PageState>(PageState.initial);

  final List<DeliveryModel> deliveries = [];

  String? errorMessage;

  void setPageState(PageState newState) {
    state.value = newState;
  }

  void setDeliveries(List<DeliveryModel> newDeliveries) {
    deliveries.clear();
    deliveries.addAll(newDeliveries);
  }

  void dispose() {
    state.dispose();
  }

  void setError(String? err) {
    errorMessage = err;
    setPageState(PageState.error);
  }
}
