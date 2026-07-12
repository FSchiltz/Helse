import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/common/timeline/timeline_graph.dart';
import 'package:helse/ui/common/timeline/timeline_node.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class EventsTimelineGraph extends StatelessWidget {
  final List<Event> events;
  final DateTimeRange date;
  final void Function(List<Event> event)? onselect;

  final double widthCoef;
  const EventsTimelineGraph(
    this.events,
    this.date, {
    super.key,
    this.onselect,
    this.widthCoef = 2,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineGraph(
      events
          .map(
            (e) =>
                TimelineNode<Event>(e.start, e.stop, e.description ?? '', [e]),
          )
          .toList(),
      date,
      onselect: onselect,
      widthCoef: widthCoef,
      getColor: (label) {
        return Dependencies.theme.stateColor(
          label,
          StateType.eventValue,
          context,
        );
      },
    );
  }
}
