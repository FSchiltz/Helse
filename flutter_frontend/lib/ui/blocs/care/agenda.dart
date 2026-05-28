import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/blocs/calendar/calendar_view.dart';

class Agenda extends StatelessWidget {
  const Agenda({super.key});

  Future<List<CalendarEvent>> _getData(DateTime day) async {
    var start = DateTime(day.year, day.month, day.day);
    var end = DateTime(
      day.year,
      day.month,
      day.day,
    ).add(const Duration(days: 1));

    var events = await Dependencies.services.event.agenda(start, end) ?? [];
    return events
        .map(
          (x) => CalendarEvent(
            from: x.start,
            to: x.stop,
            value: x.description ?? '',
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      _getData,
      DateTimeRange<DateTime>(start: DateTime(1900), end: DateTime(3000)),
    );
  }
}
