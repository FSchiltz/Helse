import 'package:flutter/material.dart';
import 'package:helse/services/swagger_generated_code/swagger.swagger.dart';

import '../../../logic/metrics/metrics_logic.dart';

class MetricWidget extends StatefulWidget {
  final MetricType _type;
  final DateTime _date;

  const MetricWidget(MetricType type, DateTime date, {super.key})
      : _type = type,
        _date = date;

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

  Future<List<Metric>> _getData() async {
    var utc = widget._date.toUtc();
    var date = DateTime(utc.year, utc.month, utc.day);
    var end = date.add(const Duration(days: 1));
    return await MetricsLogic().getMetric(_id, date, end);
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
              children: [
                FutureBuilder(
                    future: _getData(),
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
                          return MetricGraph(metrics);
                        }
                      }
                      return const CircularProgressIndicator();
                    })
              ],
            )),
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
