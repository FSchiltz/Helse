import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_graph.dart';
import 'package:helse/ui/blocs/metrics/metric_widget.dart';

class MetricDetailPage extends StatelessWidget {
  const MetricDetailPage({
    super.key,
    required this.widget,
    required this.metrics,
  });

  final MetricWidget widget;
  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${widget.type.name}',
            style: Theme.of(context).textTheme.displaySmall),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 80),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: MetricGraph(metrics, widget.type.unit, widget.date, true),
        ),
      ),
    );
  }
}
