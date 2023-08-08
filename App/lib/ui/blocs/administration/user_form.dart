import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.enums.swagger.dart';

class UserForm extends StatefulWidget {
  final UserType? type;

  final TextEditingController controllerUsername;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final TextEditingController controllerConFirmPassword;
  final TextEditingController controllerName;
  final TextEditingController controllerSurname;

  const UserForm(
    this.type, {
    super.key,
    required this.controllerUsername,
    required this.controllerEmail,
    required this.controllerPassword,
    required this.controllerConFirmPassword,
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
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        icon: _obscurePassword ? const Icon(Icons.visibility_sharp) : const Icon(Icons.visibility_off_sharp));

    return Column(
      children: [
        TextFormField(
          controller: widget.controllerName,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Name",
            prefixIcon: const Icon(Icons.person_sharp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: validateUser,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controllerSurname,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Surname",
            prefixIcon: const Icon(Icons.person_sharp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (widget.type != null && widget.type != UserType.patient) ...[
          TextFormField(
            controller: widget.controllerEmail,
            focusNode: _focusNodeEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: const Icon(Icons.email_sharp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: validateEmail,
            onEditingComplete: () => _focusNodePassword.requestFocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controllerUsername,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Username",
              prefixIcon: const Icon(Icons.person_sharp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: validateUser,
            onEditingComplete: () => _focusNodeEmail.requestFocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controllerPassword,
            obscureText: _obscurePassword,
            focusNode: _focusNodePassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.password_sharp),
              suffixIcon: iconButton,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: validatePassword,
            onEditingComplete: () => _focusNodeConfirmPassword.requestFocus(),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: validateConfirmPassword,
          ),
        ],
      ],
    );
  }

  String? validateConfirmPassword(String? value) {
    // patient don't have password
    if (widget.type == UserType.patient) return null;

    if (value == null || value.isEmpty) {
      return "Please enter password.";
    } else if (value != widget.controllerPassword.text) {
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
