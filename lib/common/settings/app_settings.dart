import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keyIsDark = 'isDark';
const keyAdminChecked = 'checkedAdmin';

class AppSettings {
  final _brightness = ValueNotifier<Brightness>(Brightness.dark);
  late final SharedPreferences _prefs;
  bool _adminChecked = false;

  Brightness get brightness => _brightness.value;
  ValueNotifier<Brightness> get brightnessNotifier => _brightness;
  bool get isDark => _brightness.value == Brightness.dark;
  bool get adminChecked => _adminChecked;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loading();
  }

  Future<void> loading() async {
    _brightness.value = (_prefs.getBool(keyIsDark) ?? true)
        ? Brightness.dark
        : Brightness.light;
    _adminChecked = _prefs.getBool(keyAdminChecked) ?? false;
  }

  Future<void> toogleBrightness() async {
    _brightness.value = _brightness.value == Brightness.light
        ? Brightness.dark
        : Brightness.light;

    await updateIsDark();
  }

  Future<void> updateIsDark() async {
    await _prefs.setBool(keyIsDark, isDark);
  }

  Future<void> checkAdminChecked() async {
    _adminChecked = true;
    await _prefs.setBool(keyAdminChecked, _adminChecked);
  }
}
