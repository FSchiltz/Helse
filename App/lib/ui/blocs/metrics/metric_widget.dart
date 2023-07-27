import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../main.dart';
import '../../../services/swagger_generated_code/swagger.swagger.dart';

class MetricWidget extends StatefulWidget {
  final MetricType _type;
  final DateTimeRange _date;

  const MetricWidget(MetricType type, DateTimeRange date, {super.key})
      : _type = type,
        _date = date;

  @override
  State<MetricWidget> createState() => _MetricWidgetState(_type.id, _type.unit);
}

class _MetricWidgetState extends State<MetricWidget> {
  late List<Metric>? metrics;
  final int _id;
  final String? _unit;

  _MetricWidgetState(int? id, String? unit)
      : _id = id ?? -1,
        _unit = unit;

  @override
  void initState() {
    metrics = null;
    super.initState();
    _getData();
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

  Future<List<Metric>?> _getData() async {
    var startUtc = widget._date.start.toUtc();
    var start = DateTime(startUtc.year, startUtc.month, startUtc.day);

    var endUtc = widget._date.end.toUtc();
    var end = DateTime(endUtc.year, endUtc.month, endUtc.day).add(const Duration(days: 1));

    var metrics = await AppState.metricsLogic?.getMetric(_id, start, end);
    metrics?.sort(_sort);
    return metrics;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
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
                final last = metrics.isNotEmpty ? metrics.last : null;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(widget._type.name ?? "", style: Theme.of(context).textTheme.titleMedium),
                          Text((last?.value ?? "") + (_unit ?? ""), style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                      Expanded(
                        child: MetricGraph(metrics, _unit),
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

class MetricGraph extends StatelessWidget {
  final List<Metric> _metrics;
  final String? _unit;

  const MetricGraph(List<Metric> metrics, String? unit, {super.key})
      : _metrics = metrics,
        _unit = unit;

  @override
  Widget build(BuildContext context) {
    return _unit == null
        ? ListView.builder(
            itemCount: _metrics.length,
            itemBuilder: (context, index) {
              return Text(_metrics[index].value ?? "");
            },
          )
        : _Graph(_metrics);
  }
}

class _Graph extends StatelessWidget {
  final List<Metric> metrics;
  final double scale = 1;

  const _Graph(this.metrics);

  int _hourBetween(DateTime from, DateTime to) {
    return to.difference(from).inHours;
  }

  List<FlSpot> _getSpot(List<Metric> raw) {
    // find the first and last
    var first = raw.first.date;
    var last = raw.last.date;

    if (first == null || last == null) return List<FlSpot>.empty();

    var period = max(_hourBetween(first, last) / 24, 1);

    var groups = <int, List<Metric>>{};
    for (var metric in raw) {
      if (metric.date == null) continue;

      // calculte the spot
      var hour = _hourBetween(first, metric.date!);
      var key = hour ~/ period;
      var spot = groups[key];
      if (spot == null) {
        spot = [];
        groups[key] = spot;
      }
      spot.add(metric);
    }

    // for all spots, we take the mean
    var mean = groups.values.map((x) => x.map((m) => m.value != null ? double.parse(m.value!) : 0).average).toList();

    var yMin = mean.min;
    var yMax = max(mean.max - yMin, 1);

    // now we have the min and max Y and X value, we can build the spots
    List<FlSpot> spots = [];

    for (final (index, item) in mean.indexed) {
      var y = (item - yMin) / yMax;
      spots.add(FlSpot(index * scale, y));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return metrics.isEmpty
        ? const Text("No data")
        : FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.9,
            child: LineChart(
              LineChartData(
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 0.5,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSpot(metrics),
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
  }
}
