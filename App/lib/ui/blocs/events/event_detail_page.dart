import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';

import '../../../helpers/date.dart';
import '../../../logic/d_i.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
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
  List<Event>? _events;
  Event? _event;

  Future<List<Event>?>? _dataFuture;

  Future<List<Event>?> _getData() async {
    try {
      if (widget.type.id == null) {
        _events = List<Event>.empty();
        return _events;
      }

      var date = widget.date;
      var start = DateTime(date.start.year, date.start.month, date.start.day);
      var end = DateTime(date.end.year, date.end.month, date.end.day).add(const Duration(days: 1));

      _events = await DI.event.events(widget.type.id, start, end, person: widget.person);
      return _events;
    } catch (ex) {
      Notify.showError("$ex");
    }
    return _events;
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = _getData();
  }

  void _resetEvents() {
    setState(() {
      _events = [];
    });
    _dataFuture = _getData();
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
          title: Row(
            children: [
              Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(width: 20),
              SizedBox(
                width: 40,
                child: IconButton(
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return EventAdd(_resetEvents, widget.type, person: widget.person);
                          });
                    },
                    icon: const Icon(Icons.add_sharp)),
              )
            ],
          ),
        ),
        body: FutureBuilder(
            future: _dataFuture,
            builder: (ctx, snapshot) {
              // Checking if future is resolved
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                }

                final events = (snapshot.hasData) ? snapshot.data as List<Event> : List<Event>.empty();
                return Column(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 120,
                          child: EventsSummary(
                            widget.summary,
                            widget.date,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Selected:'),
                        ),
                        if (_event != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_event!.id.toString()),
                          ),
                        if (_event != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateHelper.format(_event!.start?.toLocal(), context: ctx)),
                          ),
                        if (_event != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateHelper.format(_event!.stop?.toLocal(), context: ctx)),
                          ),
                        if (_event != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_event!.description.toString()),
                          ),
                        if (_event != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_event!.tag.toString()),
                          ),
                        if (_event != null)
                          SizedBox(
                            width: 40,
                            child: IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EventAdd(_resetEvents, widget.type, person: widget.person, edit: _event);
                                      });
                                },
                                icon: const Icon(Icons.edit_sharp)),
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
                                          _resetEvents();
                                          setState(() {
                                            _event = null;
                                          });
                                        }, person: widget.person);
                                      });
                                },
                                icon: const Icon(Icons.delete_sharp)),
                          ),
                      ],
                    ),
                    EventGraph(events, widget.date, _selectionChanged),
                  ],
                );
              }
              return const HelseLoader();
            }));
  }
}
