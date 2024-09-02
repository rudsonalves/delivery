import 'package:flutter/material.dart';

class AppSettings {
  final _brightness = ValueNotifier<Brightness>(Brightness.dark);

  Brightness get brightness => _brightness.value;
  ValueNotifier<Brightness> get brightnessNotifier => _brightness;
  bool get isDark => _brightness.value == Brightness.dark;

  void toogleBrightness() =>
      _brightness.value = _brightness.value == Brightness.light
          ? Brightness.dark
          : Brightness.light;
}
