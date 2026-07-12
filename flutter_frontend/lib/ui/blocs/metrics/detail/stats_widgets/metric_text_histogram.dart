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
  final void Function(List<Metric>)? onselect;
  const MetricTextHistogram(this.stats, this.type, {super.key, this.onselect});

  @override
  Widget build(BuildContext context) {
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metric,
      context,
    );

    final List<BarChartGroupData> bars = [];
    for (final step in stats.histogram.indexed) {
      bars.add(
        BarChartGroupData(
          x: step.$1,
          barRods: [
            BarChartRodData(
              label: BarChartRodLabel(
                text: step.$2.label.wrap(count: 10),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              toY: step.$2.metrics.length.toDouble(),
              color: color,
              width: 12,
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
          barTouchData: BarTouchData(
            enabled: true,
            touchCallback: (onselect == null)
                ? null
                : (event, data) {
                    if (event is FlTapUpEvent) {
                      final spot = data?.spot?.touchedBarGroupIndex;
                      if (spot != null) {
                        final selection = stats.histogram[spot];
                        onselect?.call(selection.metrics);
                      }
                    }
                  },
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = stats.histogram[groupIndex];
                return BarTooltipItem(
                  '${item.metrics.length} ${item.label}',
                  Theme.of(context).textTheme.bodyMedium!,
                );
              },
            ),
          ),
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
