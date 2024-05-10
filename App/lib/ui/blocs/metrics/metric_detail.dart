import 'package:flutter/material.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_graph.dart';

import '../../../logic/settings/ordered_item.dart';

class MetricDetailPage extends StatelessWidget {
  const MetricDetailPage({
    super.key,
    required this.metrics,
    required this.date,
    required this.type,
    required this.settings,
  });

  final DateTimeRange date;
  final List<Metric> metrics;
  final MetricType type;
  final OrderedItem settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${type.name}', style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0, top: 60.0),
        child: metrics.isEmpty
            ? Center(
                child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
              )
            : (type.type == MetricDataType.text
                ? ListView(
                    children: metrics
                        .map((metric) => Row(
                              children: [Text(metric.$value ?? ''), Text(MetricHelper.getMetricText(metric))],
                            ))
                        .toList(),
                  )
                : MetricGraph(metrics, date, settings)),
      )),
    );
  }
}
