import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';

class MetricSummarry extends StatelessWidget {
  final List<Metric> metrics;
  final String? unit;
  final DateTimeRange date;

  const MetricSummarry(this.metrics, this.unit, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return unit == null
        ? (metrics.isEmpty
            ? Center(
                child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
              )
            : ListView.builder(
                itemCount: metrics.length,
                itemBuilder: (context, index) {
                  return Text(metrics[index].$value ?? "");
                },
              ))
        : WidgetGraph(metrics, date);
  }
}

class WidgetGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  static const int valueCount = 24;

  const WidgetGraph(this.metrics, this.date, {super.key});

  int _hourBetween(DateTime from, DateTime to) {
    return to.difference(from).inHours;
  }

  List<FlSpot> _getSpot(List<Metric> raw) {
    // find the first and last
    var first = date.start;
    var last = date.end;

    var hours = _hourBetween(first, last);
    var period = max(hours / valueCount, 1);

    var groups = <int, List<Metric>>{};
    for (var metric in raw) {
      if (metric.date == null) continue;

      // calculate the spot
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
    List<double?> means = [];
    for (int i = 0; i < valueCount; i++) {
      var group = groups[i]?.where((element) => element.$value != null).map((m) => double.parse(m.$value!)) ?? [];

      var mean = group.isEmpty ? null : group.average;
      means.add(mean);
    }

    // now we have the min and max Y and X value, we can build the spots
    List<FlSpot> spots = [];

    for (final (index, item) in means.indexed) {
      if (item != null) {
        spots.add(FlSpot(index * 1, item));
      }
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return metrics.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: const FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSpot(metrics),
                    color: theme.primary,
                    barWidth: 2,
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
