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

import 'dart:math';

import 'package:flutter/material.dart';

import '/common/extensions/user_role_extensions.dart';
import '/common/theme/app_text_style.dart';
import 'custom_drawer_controller.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    required this.controller,
  });

  final CustomDrawerController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final random = Random();

    return DrawerHeader(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/images/delivery_0${random.nextInt(5)}.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: controller.isDark
                    ? colorScheme.onSecondary.withOpacity(0.7)
                    : colorScheme.secondary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/delivery_name.png',
                height: 26,
              ),
              const SizedBox(height: 5),
            ],
          ),
          if (controller.isLoggedIn)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    controller.currentUser!.name,
                    style: AppTextStyle.font22Bold(),
                  ),
                ),
                Builder(
                  builder: (context) {
                    String title = controller.currentUser!.role.displayName;
                    IconData icon = controller.currentUser!.role.iconData;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          title,
                          style: AppTextStyle.font12(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
