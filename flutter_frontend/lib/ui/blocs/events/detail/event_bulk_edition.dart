import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/detail/events_edit.dart';

class EventBulkEdition extends StatelessWidget {
  final int? person;
  final List<Event> events;
  final EventType type;
  final void Function() callback;

  const EventBulkEdition({
    super.key,
    this.person,
    required this.events,
    required this.type,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${events.length} event selected'),
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return EventsEdit(type, callback, person: person, edit: events);
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
                  await Dependencies.services.event.deleteEvents(
                    events,
                    person: person,
                  );
                  callback();
                }, person: person);
              },
            );
          },
          icon: const Icon(Icons.delete_sharp),
        ),
      ],
    );
  }
}
