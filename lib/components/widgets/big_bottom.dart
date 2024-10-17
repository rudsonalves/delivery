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

class BigButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final IconData? iconData;
  final bool enable;

  const BigButton({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.iconData,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonal(
              focusNode: focusNode,
              onPressed: enable ? onPressed : null,
              style: ButtonStyle(
                shape: ButtonStyleButton.allOrNull(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(
                  enable
                      ? color.withOpacity(.3)
                      : colorScheme.secondaryContainer,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconData != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          iconData,
                          size: 22,
                        ),
                      ),
                    Text(
                      label,
                      style: AppTextStyle.font18(
                        color: enable
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
