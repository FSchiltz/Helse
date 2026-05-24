import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../helpers/date.dart';
import '../../../logic/d_i.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'events_add.dart';
import 'events_graph.dart';
import 'events_summary.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.date,
    required this.type,
    required this.person,
    required this.summary,
  });

  final DateTimeRange date;
  final EventType type;
  final int? person;
  final List<EventSummary> summary;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Event? _event;

  Future<List<Event>> _getData(bool refresh) async {
    if (widget.type.id == null) {
      return [];
    }

    var date = widget.date;
    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(
      date.end.year,
      date.end.month,
      date.end.day,
    ).add(const Duration(days: 1));

    return await DI.event.events(
          widget.type.id,
          start,
          end,
          person: widget.person,
        ) ??
        [];
  }

  @override
  void initState() {
    super.initState();
  }

  void _selectionChanged(Event event) {
    setState(() {
      _event = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    var id = _event?.id;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 32,
              child: IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return EventAdd(
                        _resetEvents,
                        widget.type,
                        person: widget.person,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add_sharp),
              ),
            ),
          ),
        ],
        title: Text(
          'Detail of ${widget.type.name}',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: LoadingBuilder(
        _getData,
        builder: (context, data, reset) {
          final event = _event;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventsSummary(widget.summary, widget.date),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                shadowColor: Theme.of(context).colorScheme.shadow,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Selected${event != null ? ' (${event.id})' : ''}:',
                        ),
                      ),
                      if (event != null)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(event.description.toString()),
                        ),
                      if (event != null)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'from ${DateHelper.format(event.start?.toLocal(), context: context)} to ${DateHelper.format(event.stop?.toLocal(), context: context)}',
                          ),
                        ),
                      if (event != null && event.tag != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(event.tag.toString()),
                        ),
                      if (event != null)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return EventAdd(
                                    reset,
                                    widget.type,
                                    person: widget.person,
                                    edit: event,
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit_sharp),
                          ),
                        ),
                      if (id != null)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteEvent(() async {
                                    await DI.event.deleteEvent(id);
                                    reset();
                                    setState(() {
                                      _event = null;
                                    });
                                  }, person: widget.person);
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_sharp),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              EventGraph(data, widget.date, _selectionChanged),
            ],
          );
        },
      ),
    );
  }

  void _resetEvents() {
    setState(() {
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;
}
