import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/event_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class SelectionWidget extends StatelessWidget {
  const SelectionWidget({
    super.key,
    required this.selected,
    required this.reset,
    required this.person,
    required this.type,
  });

  final List<Event> selected;
  final void Function() reset;
  final int? person;
  final EventType type;

  @override
  Widget build(BuildContext context) {
    final event = selected;
    return CommonCard(
      child: event.isEmpty
          ? SizedBox.shrink()
          : Column(
              children: selected
                  .map((e) => EventTile(e, type, reset, person: person))
                  .toList(),
            ),
    );
  }
}

class EventTile extends StatelessWidget {
  final Event event;
  final void Function() reset;
  final int? person;
  final EventType type;

  const EventTile(this.event, this.type, this.reset, {super.key, this.person});

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Selected: '),
        Text('(${event.id})'),
        Text(' ${event.description} '),
        Text(
          locale
              .range(
                DateHelper.format(event.start.toLocal(), context: context),
                DateHelper.format(event.stop.toLocal(), context: context),
              )
              .toLowerCase(),
        ),
        if (event.tag != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(event.tag.toString()),
          ),

        ...EventHelper.getButtons(
          event,
          type,
          reset,
          person: person,
          context: context,
        ),
      ],
    );
  }
}
