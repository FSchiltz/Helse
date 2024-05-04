import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

import '../../../../main.dart';
import '../../../../services/swagger/generated_code/swagger.enums.swagger.dart';
import '../../notification.dart';
import 'type_input.dart';

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
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
      title: const Text("Add a new user"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: const ContinuousRectangleBorder(),
          ),
          onPressed: submit,
          child: const Text("Create"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              TypeInput(
                  UserType.values,
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
      await DI.user?.updatePersonRole(widget.id, _type ?? UserType.user);

      widget.callback.call();

      if (localContext.mounted) {
        Navigator.of(localContext).pop();
      }

      Notify.show("Updated Successfully");
    } catch (ex) {
      Notify.show("Error: $ex");
    }
  }
}
