import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../events/events_graph.dart';
import '../loader.dart';

class Agenda extends StatefulWidget {
  final DateTimeRange date;
  const Agenda({super.key, required this.date});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  List<Event>? events;

  Future<List<Event>?> _getData() async {
    if (events != null) {
      return events;
    }

    var date = widget.date;

    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(date.end.year, date.end.month, date.end.day).add(const Duration(days: 1));

    events = await AppState.eventLogic?.agenda(start, end);

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text("Agenda", style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
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

                final events = (snapshot.hasData) ? snapshot.data as List<Event> : List<Event>.empty();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventGraph(events, widget.date),
                );
              }
              return const HelseLoader();
            }),
      ],
    );
  }
}
