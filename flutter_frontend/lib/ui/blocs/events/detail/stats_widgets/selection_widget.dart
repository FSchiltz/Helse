import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class SelectionWidget extends StatelessWidget {
  const SelectionWidget({
    super.key,
    required this.event,
    required this.reset,
    required this.person,
    required this.type,
  });

  final Event event;
  final void Function() reset;
  final int? person;
  final EventType type;

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return CommonCard(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Selected: '),
          Text('(${event.id})'),
          Text(' ${event.description} '),
          Text(
            locale.range(
              DateHelper.format(event.start.toLocal(), context: context),
              DateHelper.format(event.stop.toLocal(), context: context),
            ),
          ),
          if (event.tag != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(event.tag.toString()),
            ),
          SizedBox(
            width: 40,
            child: IconButton(
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
          ),
          SizedBox(
            width: 40,
            child: IconButton(
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
          ),
        ],
      ),
    );
  }
}
