import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/helpers/string_helper.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class MetricTextHistogram extends StatelessWidget {
  final TextStats stats;
  final MetricType type;
  const MetricTextHistogram(this.stats, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metric,
      context,
    );

    final List<BarChartGroupData> bars = [];
    int i = 0;
    for (final step in stats.histogram.entries) {
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              label: BarChartRodLabel(text: step.key.wrap(count: 10), style: Theme.of(context).textTheme.labelSmall),
              toY: step.value.length.toDouble(),
              color: color,
              width: 12,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
      );

      i++;
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
              sideTitles: SideTitles(showTitles: true, reservedSize: 36),
            ),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
