import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../theme/loader.dart';
import '../../theme/notification.dart';
import 'events_add.dart';
import 'events_graph.dart';

class EventWidget extends StatefulWidget {
  final EventType type;
  final DateTimeRange date;
  final int? person;

  const EventWidget(this.type, this.date, {super.key, this.person});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  List<Event>? _events;

  _EventWidgetState();

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

  void _resetEvents() {
    setState(() {
      _events = [];
    });
  }

  Future<List<Event>?> _getData() async {
    try {
      if (widget.type.id == null) {
        _events = List<Event>.empty();
        return _events;
      }

      var date = widget.date;
      var start = DateTime(date.start.year, date.start.month, date.start.day);
      var end = DateTime(date.end.year, date.end.month, date.end.day)
          .add(const Duration(days: 1));

      _events = await DI.event
          ?.events(widget.type.id, start, end, person: widget.person);
      _events?.sort(_sort);
      return _events;
    } catch (ex) {
      Notify.show("Error: $ex");
    }
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(widget.type.name ?? "",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return EventAdd(_resetEvents, widget.type,
                              person: widget.person);
                        });
                  },
                  icon: const Icon(Icons.add_sharp))
            ],
          ),
          FutureBuilder(
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
    
                  final events = (snapshot.hasData)
                      ? snapshot.data as List<Event>
                      : List<Event>.empty();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EventGraph(events, widget.date),
                  );
                }
                return const HelseLoader();
              })
        ],
      ),
    );
  }
}
