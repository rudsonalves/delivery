import 'dart:math';

import 'package:flutter/material.dart';

import '/common/extensions/user_role_extensions.dart';
import '/common/theme/app_text_style.dart';
import '../home_controller.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    required this.controller,
  });

  final HomeController controller;

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
