import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/event_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

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
      actions: EventHelper.getButtons(
        event,
        type,
        reset,
        context: context,
        open: false,
      ),
      icon: const Icon(Icons.open_in_new_sharp),
      title: Text(
        locale.detailof(event.id.toString()),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: KeyValueList([
        KeyValue(locale.id, value: event.id.toString()),
        KeyValue(locale.description, value: event.description),
        KeyValue(
          locale.start,
          value: DateHelper.format(event.start, context: context),
        ),
        KeyValue(
          locale.stop,
          value: DateHelper.format(event.stop, context: context),
        ),
        KeyValue(locale.tag, value: event.tag),
        KeyValue(locale.source, value: event.source?.name),
        KeyValue("Source id", value: event.sourceId),
        KeyValue(
          locale.notificationTime,
          value: DateHelper.format(event.notificationTime, context: context),
        ),
      ]),
    );
  }
}
