import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/common/square_dialog.dart';

import '../../../../services/swagger/generated_code/swagger.enums.swagger.dart';
import '../../../common/notification.dart';
import '../../../common/type_input.dart';

class ChangeRole extends StatefulWidget {
  final void Function() callback;
  final UserType type;
  final int id;

  const ChangeRole(this.callback, this.type, this.id, {super.key});

  @override
  State<ChangeRole> createState() => _ChangeRoleState();
}

class _ChangeRoleState extends State<ChangeRole> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  UserType? _type;

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
              TypeInput(
                  value: widget.type,
                  UserType.values.map((x) => DropDownItem(x, x.name)).toList(),
                  (value) => setState(() {
                        _type = value;
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
      await DI.user.updatePersonRole(widget.id, _type ?? UserType.user);

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
