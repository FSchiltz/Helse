import 'package:flutter/material.dart';
import 'package:helse/ui/common/square_outline_input_border.dart';

class SquareTextField extends StatelessWidget {
  const SquareTextField({
    super.key,
    this.focusNode,
    required this.label,
    this.onEditingComplete,
    required this.icon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.onIconPressed,
    this.type,
    this.suffixIcon,
    this.onTap,
  });

  final void Function()? onTap;
  final IconButton? suffixIcon;
  final void Function()? onEditingComplete;
  final String label;
  final FocusNode? focusNode;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool obscureText;
  final void Function()? onIconPressed;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return TextFormField(
      validator: validator,
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      keyboardType: type ?? TextInputType.text,
      obscureText: obscureText,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixIconColor: theme.primary,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.surface,
        border: SquareOutlineInputBorder(theme.primary),
      ),
    );
  }
}
