import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import 'user_form.dart';

class UserAdd extends StatefulWidget {
  final void Function()? callback;
  const UserAdd(this.callback, {super.key});

  @override
  State<UserAdd> createState() => _SignupState();
}

class _SignupState extends State<UserAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  UserType? _type;

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              UserForm(
                _type,
                controllerConFirmPassword: _controllerConFirmPassword,
                controllerEmail: _controllerEmail,
                controllerName: _controllerName,
                controllerPassword: _controllerPassword,
                controllerSurname: _controllerSurname,
                controllerUsername: _controllerUsername,
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
          person: PersonCreation(
        userName: _controllerUsername.text,
        name: _controllerName.text,
        surname: _controllerSurname.text,
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

  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerName.dispose();
    _controllerSurname.dispose();
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
