import 'package:flutter/material.dart';
import 'package:helse/services/swagger_generated_code/swagger.swagger.dart';

import '../../../logic/metrics/metrics_logic.dart';

class MetricWidget extends StatefulWidget {
  final MetricType _type;

  const MetricWidget(MetricType type, {super.key}) : _type = type;

  @override
  State<MetricWidget> createState() => _MetricWidgetState(_type.id);
}

class _MetricWidgetState extends State<MetricWidget> {
  late List<Metric>? metrics;
  final int _id;

  _MetricWidgetState(int? id) : _id = id ?? -1;
  @override
  void initState() {
    metrics = null;
    super.initState();
    _getData();
  }

  void _getData() async {
    var now = DateTime.now().toUtc();
    var model = await MetricsLogic().getMetric(_id, now.add(const Duration(days: -1)), now.add(const Duration(days: 1)));
    setState(() {
      metrics = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(widget._type.name ?? "", style: Theme.of(context).textTheme.headlineMedium),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [metrics == null ? const CircularProgressIndicator() : MetricGraph(metrics!)],
            ))
          ],
        ),
      ),
    );
  }
}

class MetricGraph extends StatelessWidget {
  final List<Metric> _metrics;
  const MetricGraph(List<Metric> metrics, {super.key}) : _metrics = metrics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          itemCount: _metrics.length,
          itemBuilder: (context, index) {
            return Text(_metrics[index].value ?? "");
          },
        ),
      ),
    );
  }
}
