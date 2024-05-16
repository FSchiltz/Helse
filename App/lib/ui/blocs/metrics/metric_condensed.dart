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
        : (type.type == MetricDataType.text ? const Center() : WidgetGraph(metrics, date, settings.graph));
  }
}

class WidgetGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final GraphKind settings;

  const WidgetGraph(this.metrics, this.date, this.settings, {super.key});

  List<FlSpot> _getSpot(List<Metric> raw) {
    List<FlSpot> spots = [];

    for (final item in raw) {
      var x = double.parse(item.tag ?? "0");
      var y = (double.parse(item.$value ?? "0") * 10).roundToDouble() / 10;
      spots.add(FlSpot(x, y));
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
            barWidth: 4,
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
