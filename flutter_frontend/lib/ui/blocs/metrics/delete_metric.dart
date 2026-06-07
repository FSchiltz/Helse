import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';

class DeleteMetric extends StatelessWidget {
  final Function callback;
  const DeleteMetric(this.callback, {super.key, int? person});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return AlertDialog(
      icon: const Icon(Icons.delete_sharp),
      title: Text(locale.deleteMetric),
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
