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

import 'package:delivery/common/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final String stringTitle;
  final Widget subtitle;
  final Widget? trailing;

  const CustomListTile({
    super.key,
    this.leading,
    required this.stringTitle,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final double leftMargin = leading != null ? 0 : 8;
    final double rightMargin = trailing != null ? 0 : 8;

    return Padding(
      padding: EdgeInsets.fromLTRB(leftMargin, 8, 8, rightMargin),
      child: Row(
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    stringTitle,
                    style: AppTextStyle.font18(),
                  ),
                ),
                subtitle,
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
