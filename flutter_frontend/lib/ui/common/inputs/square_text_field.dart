import 'package:flutter/material.dart';

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
    this.onChanged,
    this.errorText,
    this.enabled,
  });

  final bool? enabled;
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
  final void Function(String value)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: TextFormField(
        validator: validator,
        controller: controller,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        keyboardType: type ?? TextInputType.text,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
        enabled: enabled,
        
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: false,
          maintainLabelSize: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          fillColor: theme.surfaceContainerLow,
          prefixIcon: Icon(icon),
          prefixIconColor: theme.primary,
          suffixIcon: suffixIcon,
          filled: true,
          errorText: errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: theme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: theme.outline),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
