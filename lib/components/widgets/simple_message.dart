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

enum MessageType { none, error, warning }

class SimpleMessage extends StatelessWidget {
  final String title;
  final Widget message;
  final MessageType type;

  const SimpleMessage({
    super.key,
    required this.title,
    required this.message,
    this.type = MessageType.none,
  });

  static Future<void> open(
    BuildContext context, {
    required String title,
    required Widget message,
    MessageType? type,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleMessage(
        title: title,
        message: message,
        type: type ?? MessageType.none,
      ),
    );
  }

  Icon? get typeIcon {
    switch (type) {
      case MessageType.none:
        return null;
      case MessageType.error:
        return const Icon(Icons.error, size: 60, color: Colors.red);
      case MessageType.warning:
        return const Icon(Icons.warning, size: 60, color: Colors.yellow);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(title),
      backgroundColor: colorScheme.onSecondary,
      icon: typeIcon,
      content: message,
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
