import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/event_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/common/async_data_table.dart';
import 'package:helse/ui/blocs/events/detail/events_edit.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EventDataTable extends AsyncDataTable<Event> {
  const EventDataTable({
    super.key,
    required super.count,
    this.person,
    required this.type,
    required super.reset,
    required super.callback,
  });
  final EventType type;
  final int? person;

  @override
  State<EventDataTable> createState() => _EventDataTableState();
}

class _EventDataTableState extends AsyncDataTableState<Event, EventDataTable> {
  List<DataRow> _builder(
    List<Event> items,
    List<Event> selected,
    bool extended,
  ) {
    return items
        .map(
          (m) => DataRow(
            selected: selected.contains(m),
            onSelectChanged: (v) {
              setState(() {
                if (v = true) {
                  selected.add(m);
                } else {
                  selected.remove(m);
                }
              });
            },
            cells: [
              if (extended) DataCell(Text((m.id).toString())),
              DataCell(Text('${m.description}')),
              DataCell(
                Text(DateHelper.format(m.start.toLocal(), context: context)),
              ),
              DataCell(
                Text(DateHelper.format(m.stop.toLocal(), context: context)),
              ),
              if (extended) DataCell(Text(m.tag.toString())),
              if (extended) DataCell(Text(m.source?.name ?? '')),
              DataCell(
                Row(
                  children: EventHelper.getButtons(
                    m,
                    widget.type,
                    widget.reset,
                    person: widget.person,
                    context: context,
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var extended = !UIHelpers.isMobile(context);
    var locale = Translation.of(context);
    final columns = [
      if (extended) DataColumn(label: Expanded(child: Text("Id"))),
      DataColumn(label: Expanded(child: Text(locale.description))),
      DataColumn(label: Expanded(child: Text(locale.start))),
      DataColumn(label: Expanded(child: Text(locale.stop))),
      if (extended) DataColumn(label: Expanded(child: Text(locale.tag))),
      if (extended) DataColumn(label: Expanded(child: Text(locale.source))),
      DataColumn(label: Expanded(child: Text(""))),
    ];
    final List<Widget> menu = selected.isEmpty
        ? []
        : [
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return EventsEdit(
                      widget.type,
                      widget.reset,
                      person: widget.person,
                      edit: selected,
                    );
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
                        selected,
                        person: widget.person,
                      );
                      widget.reset();
                    }, person: widget.person);
                  },
                );
              },
              icon: const Icon(Icons.delete_sharp),
            ),
          ];
    return buildTable(columns, _builder, menu, extended);
  }
}
