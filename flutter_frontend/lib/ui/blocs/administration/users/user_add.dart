import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/users/userright_input.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'user_form.dart';

class UserAdd extends StatefulWidget {
  final void Function()? callback;
  final Person? edit;

  const UserAdd(this.callback, {super.key, this.edit});

  @override
  State<UserAdd> createState() => _SignupState();
}

class _SignupState extends PopupSubmitState<UserAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  List<UserType> _type = [];

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      _controllerUsername.text = edit.userName ?? '';
      _controllerEmail.text = edit.email ?? '';
      _controllerName.text = edit.name ?? '';
      _controllerSurname.text = edit.surname ?? '';
      _type = edit.types ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Add a new user"),
      actions: [submitButton(locale.create, _submit)],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserRightInput(
                value: _type,
                UserType.values.where((e) => e.index > 0).toList(),
                (value) => setState(() {
                  _type = value;
                }),
              ),
              const SizedBox(height: UIConstants.formPad),
              UserForm(
                _type,
                controllerConFirmPassword: (widget.edit != null)
                    ? null
                    : _controllerConFirmPassword,
                controllerEmail: _controllerEmail,
                controllerName: _controllerName,
                controllerPassword: (widget.edit != null)
                    ? null
                    : _controllerPassword,
                controllerSurname: _controllerSurname,
                controllerUsername: _controllerUsername,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    var edit = widget.edit;
    if (edit != null) {
      await Dependencies.services.user.updatePerson(
        UpdatePerson(
          id: edit.id,
          types: _type,
          name: _controllerName.text,
          surname: _controllerSurname.text,
          email: _controllerEmail.text,
        ),
      );
    } else {
      // save the user
      var result = await Dependencies.services.user.addPerson(
        PersonCreation(
          userName: _controllerUsername.text,
          name: _controllerName.text,
          surname: _controllerSurname.text,
          password: _controllerPassword.text,
          email: _controllerEmail.text,
          types: _type,
        ),
      );

      if (result == null) {
        throw StateError("No user created");
      }

      if (result.user == null) {
        throw StateError("The person was only added as a patient");
      }
    }

    widget.callback?.call();
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
