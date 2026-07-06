import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class MetricHistogram extends StatelessWidget {
  final RawStats stats;
  final MetricType type;
  const MetricHistogram(this.stats, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metric,
      context,
    );
    final Map<int, double> steps = {};
    final double step = (stats.max - stats.min) / 100;
    if (step > 0) {
      for (final value in stats.values) {
        final index = ((value.$2 - stats.min) / step).toInt();
        steps[index] = (steps[index] ?? 0) + 1;
      }
    }

    final List<BarChartGroupData> bars = [];
    for (final step in steps.entries) {
      bars.add(
        BarChartGroupData(
          x: step.key.toInt(),
          barRods: [
            BarChartRodData(
              toY: step.value,
              color: color,
              width: 2,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 420,
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: bars,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 0),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 0),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
