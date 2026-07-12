import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';
import 'package:helse/ui/common/timeline/timeline_graph.dart';
import 'package:helse/ui/common/timeline/timeline_node.dart';

class MetricTimelineGraph extends StatelessWidget {
  final List<MetricGrouped> metrics;
  final MetricType type;
  final DateTimeRange date;
  final void Function(List<Metric> metric)? onselect;
  final double widthCoef;

  const MetricTimelineGraph(
    this.metrics,
    this.date,
    this.type, {
    super.key,
    this.onselect,
    this.widthCoef = 2,
  });

  @override
  Widget build(BuildContext context) {
    final color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metric,
      context,
    );

    return TimelineGraph(
      metrics
          .map((e) => TimelineNode<Metric>(e.date, e.date, '', e.metrics))
          .toList(),
      date,
      onselect: onselect,
      widthCoef: widthCoef,
      getColor: (label) => color,
      link: false,
      rowHeight: 58,
    );
  }
}
