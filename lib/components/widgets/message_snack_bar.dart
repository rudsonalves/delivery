import 'package:flutter/material.dart';

void showMessageSnackBar(BuildContext context,
    {required Widget message, int time = 3}) {
  final colorScheme = Theme.of(context).colorScheme;
  final snackBar = SnackBar(
    backgroundColor: colorScheme.primaryContainer,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    content: message,
    duration: Duration(seconds: time),
    action: SnackBarAction(
      label: 'Fechar',
      onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
