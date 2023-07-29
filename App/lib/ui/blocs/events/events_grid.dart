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
        : GridView.extent(
            shrinkWrap: true,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            maxCrossAxisExtent: 800.0,
            children: types.map((type) => EventWidget(type, date, key: Key(type.id?.toString() ?? ""))).toList(),
          );
  }
}
