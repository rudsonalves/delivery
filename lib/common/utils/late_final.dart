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

import 'dart:developer';

class LateFinal<T> {
  late final T _value;
  bool _isInitialized = false;

  /// Set the value of the late final.
  set value(T value) {
    if (_isInitialized) {
      log('Value has already been initialized and cannot be modified.');
      return;
    }
    _value = value;
    _isInitialized = true;
  }

  /// Get the value of the late final. Throws an error if accessed before initialization.
  T get value {
    if (!_isInitialized) {
      throw StateError('Value has not been initialized.');
    }
    return _value;
  }

  /// Check if the value has been initialized.
  bool get isInitialized => _isInitialized;
}
