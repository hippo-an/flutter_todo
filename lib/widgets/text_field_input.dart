import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    super.key,
    required this.controller,
    required this.label,
    required this.textInputType,
    required this.isPassword,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType textInputType;
  final bool isPassword;
  final IconButton? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        label: Text(label),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: suffixIcon,
        counter: const SizedBox.shrink()
      ),
      maxLines: 1,
      maxLength: 30,
      keyboardType: textInputType,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      obscureText: isPassword,
    );
  }
}
