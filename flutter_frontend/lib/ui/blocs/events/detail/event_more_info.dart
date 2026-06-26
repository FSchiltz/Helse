import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';

class EventMoreInfo extends StatelessWidget {
  final Event event;
  final EventType type;
  final void Function() reset;
  final int? person;

  const EventMoreInfo(
    this.type,
    this.reset, {
    super.key,
    required this.event,
    this.person,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      actions: [
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return EventAdd(type, reset, person: person, edit: event);
              },
            );
          },
          icon: const Icon(Icons.edit_sharp),
        ),
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return DeleteEvent(() async {
                  await Dependencies.services.event.deleteEvent(event.id);
                  reset();
                }, person: person);
              },
            );
          },
          icon: const Icon(Icons.delete_sharp),
        ),
      ],
      icon: const Icon(Icons.open_in_new_sharp),
      title: Text(
        locale.detailof(event.id.toString()),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text('m'),
    );
  }
}
