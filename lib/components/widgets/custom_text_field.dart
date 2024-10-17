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

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String labelText;
  final String? hintText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? errorText;
  final bool fullBorder;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    required this.labelText,
    this.hintText,
    this.floatingLabelBehavior,
    this.onChanged,
    this.obscureText = false,
    this.errorText,
    this.fullBorder = false,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.next,
        onChanged: onChanged,
        onEditingComplete: () {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode!);
          } else {
            FocusScope.of(context).nextFocus();
          }
        },
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          floatingLabelBehavior: floatingLabelBehavior,
          label: Text(
            labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          hintText: hintText,
          errorText: errorText,
          border: fullBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
        ),
      ),
    );
  }
}
