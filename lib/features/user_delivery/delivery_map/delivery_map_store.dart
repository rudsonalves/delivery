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
  final state = ValueNotifier<PageState>(PageState.initial);

  String? errorMessage;

  void dispose() {
    state.dispose();
  }

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
