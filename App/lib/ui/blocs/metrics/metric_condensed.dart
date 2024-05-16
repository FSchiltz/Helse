import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
        : (type.type == MetricDataType.text ? const Center() : WidgetGraph(metrics, date, settings.graph, type.summaryType ?? MetricSummary.latest));
  }
}

class WidgetGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final GraphKind settings;
  final MetricSummary type;

  const WidgetGraph(this.metrics, this.date, this.settings, this.type, {super.key});

  List<FlSpot> _getSpot(List<Metric> raw, MetricSummary type) {
    List<FlSpot> spots = [];

    for (final item in raw) {
      spots.add(FlSpot(double.parse(item.tag ?? "0"), (double.parse(item.$value ?? "0") * 10).roundToDouble() / 10));
    }

    return spots;
  }

  List<BarChartGroupData> _getBar(List<Metric> raw, MetricSummary type) {
    var spots = _getSpot(raw, type);

    // now we have the min and max Y and X value, we can build the spots
    List<BarChartGroupData> bar = [];

    for (final item in spots) {
      bar.add(BarChartGroupData(x: item.x.toInt(), barRods: [BarChartRodData(toY: item.y)]));
    }

    return bar;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0), child: _getGraph(type));
  }

  Widget _getGraph(MetricSummary type) {
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
          barGroups: _getBar(metrics, type),
        ),
      );
    } else {
      return LineChart(LineChartData(
        minX: 0,
        maxX: 16,
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
            spots: _getSpot(metrics, type),
            isCurved: true,
            curveSmoothness: 0.2,
            dotData: const FlDotData(show: false),
          )
        ],
      ));
    }
  }
}
