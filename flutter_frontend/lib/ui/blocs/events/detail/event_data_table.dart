import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/event_data_source.dart';

class EventDataTable extends StatelessWidget {
  const EventDataTable({
    super.key,
    required this.events,
    this.person,
    required this.type,
    required this.reset,
  });
  final void Function() reset;
  final EventType type;
  final int? person;
  final List<Event>? events;

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return PaginatedDataTable(
      rowsPerPage: 50,
      showEmptyRows: false,
      primary: true,
      columns: [
        DataColumn(label: Expanded(child: Text("Id"))),
        DataColumn(label: Expanded(child: Text(locale.description))),
        DataColumn(label: Expanded(child: Text(locale.start))),
        DataColumn(label: Expanded(child: Text(locale.stop))),
        DataColumn(label: Expanded(child: Text(locale.tag))),
        DataColumn(label: Expanded(child: Text(locale.source))),
        DataColumn(label: Expanded(child: Text(""))),
      ],
      source: EventDataSource(
        events ?? [],
        context,
        person,
        type,
        reset: reset,
      ),
    );
  }
}
