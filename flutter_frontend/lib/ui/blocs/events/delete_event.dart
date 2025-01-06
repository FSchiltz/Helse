import 'package:flutter/material.dart';

class DeleteEvent extends StatelessWidget {
  final Function callback;
  const DeleteEvent(this.callback, {super.key, int? person});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_sharp),
      title: const Text('Delete the event ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await callback();
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}