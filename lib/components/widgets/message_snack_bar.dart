import 'package:delivery/common/theme/app_text_style.dart';
import 'package:flutter/material.dart';

void showMessageSnackBar(BuildContext context,
    {required String message, int time = 5}) {
  final colorScheme = Theme.of(context).colorScheme;
  final snackBar = SnackBar(
    backgroundColor: colorScheme.primaryContainer,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    content: Text(
      message,
      style: AppTextStyle.font14Bold(color: colorScheme.onSurface),
    ),
    duration: Duration(seconds: time),
    action: SnackBarAction(
      label: 'Fechar',
      textColor: colorScheme.surfaceTint,
      onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
