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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.next,
        onChanged: onChanged,
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
