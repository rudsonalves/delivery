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

import '../../common/theme/app_text_style.dart';

void showMessageSnackBar(
  BuildContext context, {
  String? title,
  TextStyle? titleStyle,
  String? msg,
  Widget? msgWidget,
  TextStyle? msgStyle,
  int time = 5,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: colorScheme.primary,
    backgroundColor: colorScheme.primaryContainer,
    // behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    content: Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Text(title,
                style: titleStyle ??
                    AppTextStyle.font22Bold(color: colorScheme.primary)),
          if (msg != null)
            Text(
              msg,
              style: msgStyle ??
                  AppTextStyle.font14Bold(
                    color: colorScheme.onSurface,
                  ),
            ),
          if (msgWidget != null) msgWidget,
        ],
      ),
    ),
    duration: Duration(seconds: time),
    animation: CurvedAnimation(
      parent: AnimationController(
        vsync: ScaffoldMessenger.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      curve: Curves.easeInOutBack,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
