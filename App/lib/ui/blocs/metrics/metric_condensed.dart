import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:helse/logic/settings/ordered_item.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';

class MetricCondensed extends StatelessWidget {
  final List<Metric> metrics;
  final MetricType type;
  final DateTimeRange date;
  final OrderedItem settings;

  const MetricCondensed(this.metrics, this.type, this.settings, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return metrics.isEmpty
        ? Center(
            child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
          )
        : (type.type == MetricDataType.text
            ? ListView.builder(itemCount: metrics.length, itemBuilder: (x, y) => Text(metrics[y].$value ?? ""))
            : WidgetGraph(metrics, date, settings.graph));
  }
}

class WidgetGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final GraphKind settings;
  static const int valueCount = 24;

  const WidgetGraph(this.metrics, this.date, this.settings, {super.key});

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
      var hour = _hourBetween(first, metric.date!.toLocal());
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

    List<FlSpot> spots = [];

    for (final (index, item) in means.indexed) {
      if (item != null) {
        spots.add(FlSpot(index.toDouble(), item));
      }
    }

    return spots;
  }

  List<BarChartGroupData> _getBar(List<Metric> raw) {
    var spots = _getSpot(raw);

    // now we have the min and max Y and X value, we can build the spots
    List<BarChartGroupData> bar = [];

    for (final item in spots) {
      bar.add(BarChartGroupData(x: item.x.toInt(), barRods: [BarChartRodData(toY: item.y)]));
    }

    return bar;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0), child: _getGraph());
  }

  Widget _getGraph() {
    if (settings == GraphKind.bar) {
      return BarChart(
        BarChartData(
          barTouchData: BarTouchData(enabled: false),
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
          barGroups: _getBar(metrics),
        ),
      );
    } else {
      return LineChart(LineChartData(
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
            isCurved: true,
            curveSmoothness: 0.2,
            dotData: const FlDotData(show: false),
          )
        ],
      ));
    }
  }
}
