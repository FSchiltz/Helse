import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/events_widget.dart';
import 'package:helse/ui/blocs/metrics/widget/metric_widget.dart';

class MetricGroupDetail extends StatelessWidget {
  final DateTimeRange<DateTime> date;
  final int? person;
  final Group group;
  final List<(EventType, OrderedItem)> events;
  final List<(MetricType, OrderedItem)> metrics;

  const MetricGroupDetail(
    this.date,
    this.person,
    this.group, {
    super.key,
    required this.events,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          group.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = min(
            (constraints.maxWidth - 9 - 24) / 2,
            200,
          ).toDouble();
          return SingleChildScrollView(
            child: Wrap(
              children: [
                ...metrics
                    .where((e) => e.$2.visible == true)
                    .map(
                      (type) => ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                          maxHeight: maxHeight,
                        ),
                        child: MetricWidget(
                          type.$1,
                          type.$2,
                          DateHelper.offset(date, type.$1.timeDifference),
                          key: Key(type.$1.id.toString()),
                          person: person,
                          tile: 200,
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
            ),
          );
        },
      ),
    );
  }
}
