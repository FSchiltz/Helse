import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/blocs/events/events_widget.dart';
import 'package:helse/ui/blocs/metrics/metric_group_detail.dart';
import 'package:helse/ui/blocs/metrics/widget/metric_widget.dart';

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
          LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = min(
                (constraints.maxWidth - 9 - 24) / 2,
                200,
              ).toDouble();
              final maxWidth = maxHeight;
              return Wrap(
                runSpacing: 6,
                spacing: 6,
                children: [
                  ...metrics
                      .where((e) => e.$2.showOnDashboard == true)
                      .map(
                        (type) => ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                          ),
                          child: MetricWidget(
                            type.$1,
                            type.$2,
                            DateHelper.offset(date, type.$1.timeDifference),
                            key: Key(type.$1.id.toString()),
                            person: person,
                            tile: 60,
                          ),
                        ),
                      ),
                  ...events.where((e) => e.$2.visible == true).map((type) {
                    return EventWidget(
                      type.$1,
                      DateHelper.offset(date, type.$1.timeDifference),
                      key: Key(type.$1.id.toString()),
                      person: person,
                    );
                  }),
                ],
              );
            },
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
