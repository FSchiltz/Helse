import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/administration/users/userright_input.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';

class ChangeRole extends StatefulWidget {
  final void Function() callback;
  final List<UserType> types;
  final int id;

  const ChangeRole(this.callback, this.types, this.id, {super.key});

  @override
  State<ChangeRole> createState() => _ChangeRoleState();
}

class _ChangeRoleState extends PopupSubmitState<ChangeRole> {
  List<UserType> types = [];

  @override
  void initState() {
    super.initState();

    types = widget.types;
  }

  _ChangeRoleState();

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Change role"),
      actions: [submitButton(locale.update, _submit)],
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserRightInput(
                value: types,
                UserType.values.where((e) => e.index > 0).toList(),
                (value) => setState(() {
                  types = value;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    // save the user
    await Dependencies.services.user.updatePerson(
      UpdatePerson(
        id: widget.id,
        types: types
            .where((x) => x != UserType.swaggerGeneratedUnknown)
            .toList(),
      ),
    );

    widget.callback.call();
  }
}
