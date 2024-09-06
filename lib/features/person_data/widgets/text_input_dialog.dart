// Copyright (C) 2024 Rudson Alves
//
// This file is part of bgbazzar.
//
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String message;
  final TextInputType? keyboardType;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String? hintText;

  const TextInputDialog({
    super.key,
    required this.title,
    required this.message,
    this.keyboardType,
    this.labelText,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.hintText,
  });

  static Future open(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => TextInputDialog(
        title: title,
        message: message,
      ),
    );
  }

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      backgroundColor: colorScheme.onSecondary,
      content: Column(
        children: [
          Text(widget.message),
          TextField(
            controller: inputController,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              floatingLabelBehavior: widget.floatingLabelBehavior,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context, '');
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, inputController.text);
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
