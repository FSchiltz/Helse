import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';

import 'square_text_field.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String? value)? validate;
  final FocusNode? nextFocus;
  final FocusNode? focus;
  final String? text;
  final String? error;

  const PasswordInput({
    super.key,
    this.controller,
    this.nextFocus,
    this.validate,
    this.focus,
    this.text,
    this.error,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscurePassword = true;

  void togglePasswordVisibility() => setState(() {
    _obscurePassword = !_obscurePassword;
  });

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
      onPressed: togglePasswordVisibility,
      icon: _obscurePassword
          ? const Icon(Icons.visibility_sharp)
          : const Icon(Icons.visibility_off_sharp),
    );

    return SquareTextField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      focusNode: widget.focus,
      label: widget.text ?? Translation.of(context).password,
      icon: Icons.password_sharp,
      suffixIcon: iconButton,
      type: TextInputType.visiblePassword,
      validator: widget.validate,
      onEditingComplete: () => widget.nextFocus?.requestFocus(),
      errorText: widget.error,
    );
  }
}
