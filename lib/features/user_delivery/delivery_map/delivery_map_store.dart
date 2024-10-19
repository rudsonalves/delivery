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

import 'package:flutter/material.dart';

import '../../../stores/common/store_func.dart';

class DeliveryMapStore {
  final int lenght;

  DeliveryMapStore(this.lenght);

  final state = ValueNotifier<PageState>(PageState.initial);
  final count = ValueNotifier<int>(1);

  String? errorMessage;

  void dispose() {
    state.dispose();
    count.dispose();
  }

  void incrementCount() {
    final newCount = count.value + 1;
    count.value = newCount > lenght ? 1 : newCount;
  }

  void resetCount() => count.value = 1;

  void setPageState(PageState state) {
    this.state.value = state;
    if (state != PageState.error) {
      errorMessage = null;
    }
  }

  void setError(String message) {
    errorMessage = message;
    setPageState(PageState.error);
  }
}
