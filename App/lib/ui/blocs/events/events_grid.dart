import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import 'events_widget.dart';

class EventsGrid extends StatelessWidget {
  const EventsGrid({
    super.key,
    required this.types,
    required this.date,
    this.person,
  });

  final List<EventType> types;
  final DateTimeRange date;
  final int? person;

  @override
  Widget build(BuildContext context) {
    return types.isEmpty
        ? const LinearProgressIndicator()
        : ListView(
            shrinkWrap: true,
            children: types.map((type) => EventWidget(type, date, key: Key(type.id?.toString() ?? ""), person: person)).toList(),
          );
  }
}
