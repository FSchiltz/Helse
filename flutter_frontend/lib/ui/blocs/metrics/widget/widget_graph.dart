import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';

class WidgetGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange range;
  final GraphKind settings;
  final MetricType type;
  final int tile;
  final double? width;

  const WidgetGraph(
    this.metrics,
    this.range,
    this.type,
    this.settings, {
    super.key,
    required this.tile,
    this.width,
  });

  List<FlSpot> _getSpot(List<Metric> raw) {
    List<FlSpot> spots = [];
    final bucketLength = range.duration.inMilliseconds / tile;

    final groups = List<MetricGrouped>.generate(tile, (index) {
      final start = range.start.add(
        Duration(milliseconds: (index * bucketLength).toInt()),
      );
      var date = start.add(Duration(milliseconds: (bucketLength / 2).toInt()));
      return MetricGrouped(date, 0, []);
    });

    for (var metric in raw) {
      final value = double.parse(metric.value);
      // find the bucket
      final duration = metric.date.difference(range.start);
      final index = (duration.inMilliseconds / bucketLength).toInt();
      final bucket = groups[index];
      // if it does not exists create it
      bucket.value = (bucket.value + value) / 2;
    }

    for (final item in groups) {
      var y = item.value;
      if (settings == GraphKind.line && y == 0) {
        // skip empty items for line graph to make it pretty
        continue;
      }
      var x = item.date.millisecondsSinceEpoch.toDouble();
      spots.add(FlSpot(x, y));
    }

    return spots;
  }

  List<BarChartGroupData> _getBar(List<Metric> raw, Color color) {
    var spots = _getSpot(raw);

    // now we have the min and max Y and X value, we can build the spots
    List<BarChartGroupData> bar = [];

    for (final item in spots) {
      bar.add(
        BarChartGroupData(
          x: item.x.toInt(),
          barRods: [
            BarChartRodData(toY: item.y, color: color, width: width ?? 2),
          ],
        ),
      );
    }

    return bar;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _getGraph(context),
    );
  }

  Widget _getGraph(BuildContext context) {
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metric,
      context,
    );
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
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: _getBar(metrics, color),
        ),
      );
    } else {
      return LineChart(
        LineChartData(
          minX: range.start.millisecondsSinceEpoch.toDouble(),
          maxX: range.end.millisecondsSinceEpoch.toDouble(),
          lineTouchData: const LineTouchData(enabled: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              barWidth: width ?? 3,
              color: color,
              spots: _getSpot(metrics),
              isCurved: true,
              curveSmoothness: 0.02,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      color: color,
                      strokeColor: color,
                      radius: barData.spots.length > 1 ? 0 : 2,
                      strokeWidth: 0,
                    ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
