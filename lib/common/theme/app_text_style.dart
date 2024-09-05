import 'package:flutter/material.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle font12({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle font14Bold({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle font18Bold({Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle font22Bold({Color? color}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}
