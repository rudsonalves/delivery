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
