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

class AppTextStyle {
  AppTextStyle._();

  static TextStyle font12Height({Color? color, double? height}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
    );
  }

  static TextStyle font12({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle font12Bold({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle font14SemiBold({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
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

  static TextStyle font14({Color? color}) {
    return TextStyle(
      fontSize: 14,
      color: color,
    );
  }

  static TextStyle font15({Color? color}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle font15Bold({Color? color}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle font16({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle font16Bold({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle font18({Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
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
