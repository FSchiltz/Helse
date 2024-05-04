import 'package:flutter/material.dart';
import 'package:helse/ui/helpers/square_outline_input_border.dart';

class SquareTextField extends StatelessWidget {
  const SquareTextField({
    super.key,
    this.focusNode,
    required this.theme,
    required this.label,
    this.onEditingComplete,
    required this.icon,
    required this.controller,
    this.validator,
  });

  final void Function()? onEditingComplete;
  final String label;
  final FocusNode? focusNode;
  final ColorScheme theme;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: SquareOutlineInputBorder(theme.primary),
      ),
    );
  }
}
