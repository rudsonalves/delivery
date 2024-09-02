import 'package:flutter/material.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle font14Bold({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}
