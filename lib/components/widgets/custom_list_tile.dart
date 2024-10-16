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
