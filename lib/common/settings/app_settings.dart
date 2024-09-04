import 'package:delivery/locator.dart';
import 'package:flutter/material.dart';

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
