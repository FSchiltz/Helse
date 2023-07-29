import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import 'events_graph.dart';

class EventWidget extends StatefulWidget {
  final EventType type;
  final DateTimeRange date;

  const EventWidget(this.type, this.date, {super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  late List<Event>? _events;
  late DateTimeRange? _date;

  _EventWidgetState();

  @override
  void initState() {
    _events = null;
    _date = null;
    super.initState();
  }

  int _sort(Event m1, Event m2) {
    var a = m1.stop;
    var b = m2.stop;
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return -1;
    } else if (b == null) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  }

  Future<List<Event>?> _getData(int? id) async {
    if (id == null) {
      _events = List<Event>.empty();
      return _events;
    }

    // if the date has not changed, no call to the backend
    var date = _date;
    if (date != null && widget.date.start.compareTo(date.start) == 0 && widget.date.end.compareTo(date.end) == 0) return _events;

    date = widget.date;
    _date = date;

    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(date.end.year, date.end.month, date.end.day).add(const Duration(days: 1));

    _events = await AppState.eventLogic?.getEvent(id, start, end);
    _events?.sort(_sort);
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
          future: _getData(widget.type.id),
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
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final events = snapshot.data as List<Event>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.type.name ?? "", style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: EventGraph(events, widget.date),
                      )
                    ],
                  ),
                );
              }
            }
            return const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
          }),
    );
  }
}
