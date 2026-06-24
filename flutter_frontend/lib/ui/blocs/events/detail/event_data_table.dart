import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/blocs/metrics/delete_metric.dart';
import 'package:helse/ui/common/pagination.dart';

class EventDataTable extends StatefulWidget {
  const EventDataTable({
    super.key,
    required this.count,
    this.person,
    required this.type,
    required this.reset,
    required this.search,
  });
  final void Function() reset;
  final EventType type;
  final int? person;
  final int count;
  final SearchEvent search;

  @override
  State<EventDataTable> createState() => _EventDataTableState();
}

class _EventDataTableState extends State<EventDataTable> {
  List<Event> _events = [];
  int _page = 0;

  @override
  void initState() {
    super.initState();

    if (widget.count > 0) {
      _search();
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return Column(
      children: [
        Pagination(
          count: widget.count,
          pageSize: 50,
          page: _page,
          callBack: (v) => setState(() {
            _page = v;
          }),
        ),
        DataTable(
          columns: [
            DataColumn(label: Expanded(child: Text("Id"))),
            DataColumn(label: Expanded(child: Text(locale.description))),
            DataColumn(label: Expanded(child: Text(locale.start))),
            DataColumn(label: Expanded(child: Text(locale.stop))),
            DataColumn(label: Expanded(child: Text(locale.tag))),
            DataColumn(label: Expanded(child: Text(locale.source))),
            DataColumn(label: Expanded(child: Text(""))),
          ],
          rows: _events
              .map(
                (m) => DataRow(
                  cells: [
                    DataCell(Text((m.id).toString())),
                    DataCell(Text('${m.description}')),
                    DataCell(
                      Text(
                        DateHelper.format(m.start.toLocal(), context: context),
                      ),
                    ),
                    DataCell(
                      Text(
                        DateHelper.format(m.stop.toLocal(), context: context),
                      ),
                    ),
                    DataCell(Text(m.tag.toString())),
                    DataCell(Text(m.source.toString())),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return EventAdd(
                                    widget.type,
                                    widget.reset,
                                    person: widget.person,
                                    edit: m,
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
                                  return DeleteMetric(() async {
                                    await Dependencies.services.event
                                        .deleteEvent(m.id);
                                    widget.reset();
                                  }, person: widget.person);
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_sharp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Future<void> _search() async {
    var events = await Dependencies.services.event.searchEvents(
      widget.person,
      widget.search,
      _page,
      50,
    );
    setState(() {
      _events = events ?? [];
    });
  }
}
