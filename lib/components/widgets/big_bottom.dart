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
