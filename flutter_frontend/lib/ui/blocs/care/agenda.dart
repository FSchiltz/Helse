import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/calendar/calendar_view.dart';
import 'package:table_calendar/table_calendar.dart';

class Agenda extends StatelessWidget {
  final List<Person> data;
  final bool compact;
  const Agenda(this.data, {super.key, this.compact = false});

  Future<List<CalendarGroup>> _getData(DateTime day) async {
    var start = DateTime(day.year, day.month, day.day);
    var end = DateTime(
      day.year,
      day.month,
      day.day,
    ).add(const Duration(days: 1));

    var events = await Dependencies.services.event.agenda(start, end) ?? [];
    return events.groupListsBy((e) => e.person).entries.map((e) {
      var person = data.firstWhere((x) => x.id == e.key);
      return CalendarGroup(
        name: '${person.name} ${person.surname}',
        events: e.value
            .map(
              (x) => CalendarEvent(
                from: x.start,
                to: x.stop,
                value: '${x.description}',
              ),
            )
            .toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      _getData,
      DateTimeRange<DateTime>(start: DateTime(1900), end: DateTime(3000)),
      format: CalendarFormat.week,
      compact: compact,
    );
  }
}
