import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/events/events_graph.dart';

class EventDetailPage extends StatelessWidget {
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
  final List<Event> summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail of ${type.name}', style: Theme.of(context).textTheme.displaySmall),
          //child: DateRangeInput((x) => {}, date),
        ),
        body: EventGraph(summary, date));
  }
}
