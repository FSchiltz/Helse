import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';

class MetricCondensed extends StatelessWidget {
  final List<Metric> metrics;
  final MetricType type;
  final DateTimeRange date;
  final OrderedItem settings;
  final int tile;

  const MetricCondensed(
    this.metrics,
    this.type,
    this.settings,
    this.date, {
    super.key,
    required this.tile,
  });

  @override
  Widget build(BuildContext context) {
    return metrics.isEmpty
        ? Center(
            child: Text(
              Translation.of(context).nodata,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : (type.type == MetricDataType.text
              ? Center(child: Text(metrics.last.value))
              : WidgetGraph(
                  metrics,
                  date,
                  type,
                  settings.graph ?? GraphKind.text,
                  tile: tile,
                ));
  }
}
