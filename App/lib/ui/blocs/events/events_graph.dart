import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';


class EventGraph extends StatelessWidget {
  final List<Event> events;
  final DateTimeRange date;

  const EventGraph(this.events,  this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return (events.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(events[index].description ?? ""),
                      Text(events[index].start.toString()),
                      Text(events[index].stop.toString()),
                    ],
                  );
                },
              ));
  }
}
