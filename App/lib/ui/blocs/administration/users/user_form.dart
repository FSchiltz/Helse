import 'package:flutter/material.dart';
import 'package:helse/ui/theme/square_outline_input_border.dart';

import '../../../../services/swagger/generated_code/swagger.enums.swagger.dart';
import '../../../theme/square_text_field.dart';

class UserForm extends StatefulWidget {
  final UserType? type;

  final TextEditingController? controllerUsername;
  final TextEditingController? controllerEmail;
  final TextEditingController? controllerPassword;
  final TextEditingController? controllerConFirmPassword;
  final TextEditingController controllerName;
  final TextEditingController controllerSurname;

  const UserForm(
    this.type, {
    super.key,
    this.controllerUsername,
    this.controllerEmail,
    this.controllerPassword,
    this.controllerConFirmPassword,
    required this.controllerName,
    required this.controllerSurname,
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
    var iconButton = IconButton(
        onPressed: togglePassword,
        icon: _obscurePassword
            ? const Icon(Icons.visibility_sharp)
            : const Icon(Icons.visibility_off_sharp));
    var theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SquareTextField(
          controller: widget.controllerName,
          label: "Name",
          icon: Icons.person_sharp,
          validator: validateUser,
          theme: theme,
        ),
        const SizedBox(height: 10),
        SquareTextField(
            controller: widget.controllerSurname,
            label: "Surname",
            icon: Icons.person_sharp,
            theme: theme),
        if (widget.type != null && widget.type != UserType.patient) ...[
          const SizedBox(height: 10),
          SquareTextField(
            controller: widget.controllerEmail,
            focusNode: _focusNodeEmail,
            label: "Email",
            icon: Icons.email_sharp,
            theme: theme,
            validator: validateEmail,
            onEditingComplete: () => _focusNodePassword.requestFocus(),
          ),
          const SizedBox(height: 10),
          UserNameInput(
            controller: widget.controllerUsername,
            nextFocus: _focusNodePassword,
            validate: validateUser,
          ),
          const SizedBox(height: 10),
          PasswordInput(
            controller: widget.controllerPassword,
            nextFocus: _focusNodeConfirmPassword,
            validate: validatePassword,
            focus: _focusNodePassword,
            obscurePassword: _obscurePassword,
            toggleCallback: togglePassword,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controllerConFirmPassword,
            obscureText: _obscurePassword,
            focusNode: _focusNodeConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              prefixIcon: const Icon(Icons.password_sharp),
              suffixIcon: iconButton,
              suffixIconColor: theme.primary,
              prefixIconColor: theme.primary,
              filled: true,
              fillColor: theme.surface,
              border: SquareOutlineInputBorder(theme.primary),
            ),
            validator: validateConfirmPassword,
          ),
        ],
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
    if (widget.type == UserType.patient) return null;

    if (value == null || value.isEmpty) {
      return "Please enter password.";
    } else if (value != widget.controllerPassword?.text) {
      return "Password doesn't match.";
    }
    return null;
  }

  String? validatePassword(String? value) {
    // patient don't have password
    if (widget.type == UserType.patient) return null;

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

class PasswordInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String? value)? validate;
  final FocusNode? nextFocus;
  final FocusNode? focus;
  final bool obscurePassword;
  final void Function()? toggleCallback;

  const PasswordInput({
    super.key,
    this.controller,
    this.nextFocus,
    this.validate,
    this.focus,
    required this.obscurePassword,
    this.toggleCallback,
  });

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        onPressed: toggleCallback,
        icon: obscurePassword
            ? const Icon(Icons.visibility_sharp)
            : const Icon(Icons.visibility_off_sharp));
    var theme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      focusNode: focus,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.password_sharp),
        prefixIconColor: theme.primary,
        suffixIcon: iconButton,
        suffixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
      validator: validate,
      onEditingComplete: () => nextFocus?.requestFocus(),
    );
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
    var theme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      focusNode: focus,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: const Icon(Icons.person_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
      validator: validate,
      onEditingComplete: () => nextFocus?.requestFocus(),
    );
  }
}
