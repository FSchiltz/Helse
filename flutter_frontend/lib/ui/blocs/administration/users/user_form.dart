import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/password_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.enums.swagger.dart';
import '../../../common/inputs/square_text_field.dart';

class UserForm extends StatefulWidget {
  final List<UserType> types;

  final TextEditingController? controllerUsername;
  final TextEditingController? controllerEmail;
  final TextEditingController? controllerPassword;
  final TextEditingController? controllerConFirmPassword;
  final TextEditingController controllerName;
  final TextEditingController controllerSurname;
  final TextEditingController? controllerIdentifier;

  const UserForm(
    this.types, {
    super.key,
    this.controllerUsername,
    this.controllerEmail,
    this.controllerPassword,
    this.controllerConFirmPassword,
    required this.controllerName,
    required this.controllerSurname,
    this.controllerIdentifier,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return Column(
      children: [
        SquareTextField(
          controller: widget.controllerName,
          label: locale.name,
          icon: Icons.person_sharp,
          validator: validateUser,
        ),
        const SizedBox(height: UIConstants.formPad),
        SquareTextField(
          controller: widget.controllerSurname,
          label: locale.surname,
          icon: Icons.person_sharp,
        ),
        if (widget.controllerIdentifier != null)
          const SizedBox(height: UIConstants.formPad),
        if (widget.controllerIdentifier != null)
          SquareTextField(
            controller: widget.controllerIdentifier,
            label: locale.identifier,
            icon: Icons.person_sharp,
          ),
        if (widget.controllerEmail != null)
          const SizedBox(height: UIConstants.formPad),
        if (widget.controllerEmail != null)
          SquareTextField(
            controller: widget.controllerEmail,
            focusNode: _focusNodeEmail,
            label: locale.email,
            icon: Icons.email_sharp,
            validator: validateEmail,
            onEditingComplete: () => _focusNodePassword.requestFocus(),
          ),
        if (widget.controllerUsername != null)
          const SizedBox(height: UIConstants.formPad),
        if (widget.controllerUsername != null)
          UserNameInput(
            controller: widget.controllerUsername,
            nextFocus: _focusNodePassword,
            validate: validateUser,
          ),
        if (widget.controllerPassword != null)
          const SizedBox(height: UIConstants.formPad),
        if (widget.controllerPassword != null)
          PasswordInput(
            controller: widget.controllerPassword,
            nextFocus: _focusNodeConfirmPassword,
            validate: validatePassword,
            focus: _focusNodePassword,
          ),
        if (widget.controllerPassword != null)
          const SizedBox(height: UIConstants.formPad),
        if (widget.controllerPassword != null)
          PasswordInput(
            text: Translation.of(context).confirmpassword,
            controller: widget.controllerConFirmPassword,
            focus: _focusNodeConfirmPassword,
            validate: validateConfirmPassword,
          ),
      ],
    );
  }

  void togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? validateConfirmPassword(String? value) {
    // patient don't have password
    if (widget.types.isEmpty) return null;

    if (value == null || value.isEmpty) {
      return "Please enter password.";
    } else if (value != widget.controllerPassword?.text) {
      return "Password doesn't match.";
    }
    return null;
  }

  String? validatePassword(String? value) {
    // patient don't have password
    if (widget.types.isEmpty) return null;

    if (value == null || value.isEmpty) {
      return "Please enter password.";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (!(value.contains('@') && value.contains('.'))) {
      return "Invalid email";
    }
    return null;
  }

  String? validateUser(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter username.";
    }

    return null;
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }
}

class UserNameInput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final String? Function(String? value) validate;

  const UserNameInput({
    super.key,
    this.focus,
    this.controller,
    this.nextFocus,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareTextField(
      label: locale.username,
      icon: Icons.person_sharp,
      controller: controller,
      type: TextInputType.name,
      focusNode: focus,
      validator: validate,
      onEditingComplete: () => nextFocus?.requestFocus(),
    );
  }
}
