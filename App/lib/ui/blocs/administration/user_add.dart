import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';

class UserAdd extends StatefulWidget {
  final void Function()? callback;
  const UserAdd(this.callback, {super.key});

  @override
  State<UserAdd> createState() => _SignupState();
}

class _SignupState extends State<UserAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword = TextEditingController();

  bool _obscurePassword = true;
  UserType? _type;

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        icon: _obscurePassword ? const Icon(Icons.visibility_sharp) : const Icon(Icons.visibility_off_sharp));

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
      title: const Text("Add a new user"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: submit,
          child: const Text("Register"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              _TypeInput(
                  UserType.values,
                  (value) => setState(() {
                        _type = value;
                      })),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerUsername,
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
                validator: validadateUser,
                onEditingComplete: () => _focusNodeEmail.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerEmail,
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
                controller: _controllerPassword,
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
                controller: _controllerConFirmPassword,
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
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // save the user
      await AppState.authenticationLogic?.createAccount(
          person: Person(
        userName: _controllerUsername.text,
        password: _controllerPassword.text,
        email: _controllerEmail.text,
        type: _type,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 200,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text("Added Successfully"),
        ),
      );

      _formKey.currentState?.reset();
      widget.callback?.call();
      Navigator.of(context).pop();
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password.";
    } else if (value != _controllerPassword.text) {
      return "Password doesn't match.";
    }
    return null;
  }

  String? validatePassword(String? value) {
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

  String? validadateUser(String? value) {
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
    _controllerUsername.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }
}

class _TypeInput extends StatelessWidget {
  final List<UserType> types;
  final void Function(UserType?) callback;

  const _TypeInput(this.types, this.callback);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      onChanged: callback,
      items: types.map((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.list_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
