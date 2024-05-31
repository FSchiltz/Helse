import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/events/events_graph.dart';

import '../../../logic/d_i.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.date,
    required this.type,
    required this.person,
  });

  final DateTimeRange date;
  final EventType type;
  final int? person;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  List<Event>? _events;

  Future<List<Event>?> _getData() async {
    try {
      if (widget.type.id == null) {
        _events = List<Event>.empty();
        return _events;
      }

      var date = widget.date;
      var start = DateTime(date.start.year, date.start.month, date.start.day);
      var end = DateTime(date.end.year, date.end.month, date.end.day).add(const Duration(days: 1));

      _events = await DI.event?.events(widget.type.id, start, end, person: widget.person);
      return _events;
    } catch (ex) {
      Notify.showError("$ex");
    }
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
          //child: DateRangeInput((x) => {}, date),
        ),
        body: FutureBuilder(
            future: _getData(),
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
                return EventGraph(events, widget.date);
              }
              return const HelseLoader();
            }));
  }
}
