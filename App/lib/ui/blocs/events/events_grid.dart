import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import 'events_widget.dart';

class EventsGrid extends StatelessWidget {
  const EventsGrid({
    super.key,
    required this.types,
    required this.date,
  });

  final List<EventType> types;
  final DateTimeRange date;

  @override
  Widget build(BuildContext context) {
    return types.isEmpty
        ? const CircularProgressIndicator()
        : ListView(
            shrinkWrap: true,
            children: types.map((type) => EventWidget(type, date, key: Key(type.id?.toString() ?? ""))).toList(),
          );
  }
}
