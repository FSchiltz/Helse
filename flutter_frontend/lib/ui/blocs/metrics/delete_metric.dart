import 'package:flutter/material.dart';

class DeleteMetric extends StatelessWidget {
  final Function callback;
  const DeleteMetric(this.callback, {super.key, int? person});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_sharp),
      title: const Text('Delete the metric ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await callback();
            if (context.mounted) {
              Navigator.pop(context, 'OK');
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
