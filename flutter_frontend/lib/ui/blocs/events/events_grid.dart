import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/logic/theme_helper.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'events_widget.dart';

class EventsGrid extends StatelessWidget {
  const EventsGrid({
    super.key,
    required this.date,
    this.person,
    required this.types,
  });

  final DateTimeRange date;
  final int? person;
  final List<(EventType, OrderedItem)> types;

  @override
  Widget build(BuildContext context) {
    var childs = types.map((type) {
      var color = Dependencies.theme.stateColor(
        "${type.$1.id}",
        StateType.events,
        context,
      );
      return EventWidget(
        type.$1,
        DateHelper.offset(date, type.$1.timeDifference),
        key: Key(type.$1.id.toString()),
        person: person,
      );
    }).toList();

    return Align(
      alignment: AlignmentGeometry.topLeft,
      child: Wrap(
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.start,
        spacing: 24,
        runSpacing: 16,
        children: childs,
      ),
    );
  }
}
