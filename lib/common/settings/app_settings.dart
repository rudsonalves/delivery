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

import '/locator.dart';
import '../../services/local_storage_service.dart';

class AppSettings {
  final _brightness = ValueNotifier<Brightness>(Brightness.dark);
  final _localStore = locator<LocalStorageService>();

  bool _adminChecked = false;

  Brightness get brightness => _brightness.value;
  ValueNotifier<Brightness> get brightnessNotifier => _brightness;
  bool get isDark => _brightness.value == Brightness.dark;
  bool get adminChecked => _adminChecked;

  Future<void> init() async {
    await _localStore.init();
    await loading();
  }

  Future<void> loading() async {
    _brightness.value = _localStore.isDark ? Brightness.dark : Brightness.light;
    _adminChecked = _localStore.adminChecked;
  }

  Future<void> toogleBrightness() async {
    _brightness.value = _brightness.value == Brightness.light
        ? Brightness.dark
        : Brightness.light;

    await _localStore.setIsDark(isDark);
  }

  Future<void> checkAdminChecked() async {
    _adminChecked = true;
    await _localStore.setAdminChecked(_adminChecked);
  }
}
