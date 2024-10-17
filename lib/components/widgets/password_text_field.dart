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

class PasswordTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool fullBorder;
  final void Function(String)? onChanged;
  final void Function()? onFieldSubmitted;
  final String? errorText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  const PasswordTextField({
    super.key,
    required this.labelText,
    this.hintText,
    required this.controller,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.fullBorder = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorText,
    this.floatingLabelBehavior,
    this.focusNode,
    this.nextFocus,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  final notVisible = ValueNotifier<bool>(true);
  final FocusNode iconButtonFocusNode = FocusNode(canRequestFocus: false);

  @override
  void dispose() {
    notVisible.dispose();
    iconButtonFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ValueListenableBuilder(
        valueListenable: notVisible,
        builder: (context, value, _) {
          return TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            focusNode: widget.focusNode,
            obscureText: value,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              errorText: widget.errorText,
              label: Text(
                widget.labelText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              hintText: widget.hintText,
              border: widget.fullBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              floatingLabelBehavior: widget.floatingLabelBehavior,
              suffixIcon: IconButton(
                isSelected: notVisible.value,
                focusNode: iconButtonFocusNode,
                onPressed: () {
                  notVisible.value = !notVisible.value;
                },
                icon: const Icon(Icons.visibility),
                selectedIcon: const Icon(Icons.visibility_off),
              ),
            ),
            onChanged: widget.onChanged,
            onFieldSubmitted: (value) {
              if (widget.nextFocus != null) {
                FocusScope.of(context).requestFocus(widget.nextFocus);
              } else if (widget.textInputAction == TextInputAction.done) {
                FocusScope.of(context).unfocus();
                if (widget.onFieldSubmitted != null) {
                  widget.onFieldSubmitted!();
                }
              }
            },
          );
        },
      ),
    );
  }
}
