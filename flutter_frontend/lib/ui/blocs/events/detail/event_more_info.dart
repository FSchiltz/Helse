import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';

class EventMoreInfo extends StatelessWidget {
  final Event event;
  const EventMoreInfo({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      icon: const Icon(Icons.details_sharp),
      title: Text(
        locale.detailof(locale.events),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text('m'),
    );
  }
}
