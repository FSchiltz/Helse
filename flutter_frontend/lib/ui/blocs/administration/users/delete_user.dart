import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class DeleteUser extends StatelessWidget {
  final Function callback;
  final Person person;

  const DeleteUser(this.callback, {super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return AlertDialog(
      icon: const Icon(Icons.delete_sharp),
      title: Text(locale.deleteUser),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(locale.cancel),
        ),
        TextButton(
          onPressed: () async {
            await callback();

            if (context.mounted) {
              Navigator.pop(context, 'OK');
            }
          },
          child: Text(locale.ok),
        ),
      ],
    );
  }
}
