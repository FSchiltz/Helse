import 'package:flutter/material.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/blocs/events/events_grid.dart';
import 'package:helse/ui/blocs/metrics/metric_group_detail.dart';
import 'package:helse/ui/blocs/metrics/metric_widgets_grid.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class WidgetGroups extends StatelessWidget {
  final int? person;
  final Group group;
  final DateTimeRange date;
  final List<(MetricType, OrderedItem)> metrics;
  final List<(EventType, OrderedItem)> events;

  const WidgetGroups({
    super.key,
    required this.date,
    required this.group,
    this.person,
    required this.metrics,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    var color = Dependencies.theme.stateColor(
      "${group.id}",
      StateType.metricGroup,
      context,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 6),
              Text(
                group.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(width: 12),
              _openAll(context),
            ],
          ),
          MetricWidgetsGrid(
            date: date,
            person: person,
            types: metrics.where((e) => e.$2.showOnDashboard == true).toList(),
            tile: 60,
          ),
          EventsGrid(
            date: date,
            person: person,
            types: events.where((e) => e.$2.visible == true).toList(),
          ),
        ],
      ),
    );
  }

  IconButton _openAll(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) =>
              MetricGroupDetail(date, person, group, types: metrics),
        ),
      ),
      icon: const Icon(Icons.open_in_new_sharp),
    );
  }
}
