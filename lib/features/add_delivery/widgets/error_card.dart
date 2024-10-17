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

import '../../../common/theme/app_text_style.dart';

class ErrorCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData iconData;
  final Color? color;

  const ErrorCard({
    super.key,
    required this.title,
    required this.message,
    required this.iconData,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Card(
            color: colorScheme.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      title,
                      style: AppTextStyle.font16Bold(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Icon(
                      iconData,
                      size: 80,
                      color: color,
                    ),
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
