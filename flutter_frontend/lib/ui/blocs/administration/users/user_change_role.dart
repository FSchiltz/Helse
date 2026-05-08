import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/administration/users/userright_input.dart';
import 'package:helse/ui/common/square_dialog.dart';

import '../../../common/notification.dart';

class ChangeRole extends StatefulWidget {
  final void Function() callback;
  final List<UserType> types;
  final int id;

  const ChangeRole(this.callback, this.types, this.id, {super.key});

  @override
  State<ChangeRole> createState() => _ChangeRoleState(types);
}

class _ChangeRoleState extends State<ChangeRole> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<UserType> types;
  
  _ChangeRoleState(this.types);

  @override
  Widget build(BuildContext context) {
    return SquareDialog(
      title: const Text("Change role"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: const ContinuousRectangleBorder(),
          ),
          onPressed: submit,
          child: const Text("Update"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              UserRightInput(
                  value: types,
                  UserType.values.toList(),
                  (value) => setState(() {
                        types = value;
                      })),
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    var localContext = context;
    try {
      // save the user
      await DI.user.updatePerson(UpdatePerson(id: widget.id, types: types.where((x)=> x != UserType.swaggerGeneratedUnknown).toList()));

      widget.callback.call();

      if (localContext.mounted) {
        Navigator.of(localContext).pop();
      }

      Notify.show("Updated Successfully");
    } catch (ex) {
      Notify.showError("$ex");
    }
  }
}
