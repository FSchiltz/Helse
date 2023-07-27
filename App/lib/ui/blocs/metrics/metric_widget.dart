import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger_generated_code/swagger.swagger.dart';
import 'metric_graph.dart';

class MetricWidget extends StatefulWidget {
  final MetricType type;
  final DateTimeRange date;

  const MetricWidget(this.type, this.date, {super.key});

  @override
  State<MetricWidget> createState() => _MetricWidgetState();
}

class _MetricWidgetState extends State<MetricWidget> {
  late List<Metric>? metrics;

  _MetricWidgetState();

  @override
  void initState() {
    metrics = null;
    super.initState();
    _getData(widget.type.id);
  }

  int _sort(Metric m1, Metric m2) {
    var a = m1.date;
    var b = m2.date;
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return -1;
    } else if (b == null) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  }

  Future<List<Metric>?> _getData(int? id) async {
    if (id == null) return List<Metric>.empty();

    var startUtc = widget.date.start.toUtc();
    var start = DateTime(startUtc.year, startUtc.month, startUtc.day);

    var endUtc = widget.date.end.toUtc();
    var end = DateTime(endUtc.year, endUtc.month, endUtc.day).add(const Duration(days: 1));

    var metrics = await AppState.metricsLogic?.getMetric(id, start, end);
    metrics?.sort(_sort);
    return metrics;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
          future: _getData(widget.type.id),
          builder: (ctx, snapshot) {
            // Checking if future is resolved
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final metrics = snapshot.data as List<Metric>;
                final last = metrics.isNotEmpty ? metrics.last : null;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(widget.type.name ?? "", style: Theme.of(context).textTheme.titleMedium),
                          Text((last?.value ?? "") + (widget.type.unit ?? ""), style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                      Expanded(
                        child: MetricGraph(metrics, widget.type.unit, widget.date),
                      )
                    ],
                  ),
                );
              }
            }
            return const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 5, child: LinearProgressIndicator()),
              ],
            );
          }),
    );
  }
}
