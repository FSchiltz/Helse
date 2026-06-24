import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/events_add.dart';

class EventAddButton extends StatelessWidget {
  final EventType type;
  final void Function() callback;
  final int? person;
  const EventAddButton(this.type, this.callback, {super.key, this.person});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return EventAdd(type, callback, person: person);
            },
          );
        },
        icon: const Icon(Icons.add_sharp),
      ),
    );
  }
}
