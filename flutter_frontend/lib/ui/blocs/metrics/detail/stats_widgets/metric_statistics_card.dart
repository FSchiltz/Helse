import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_stats.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class MetricStatisticsCard extends StatelessWidget {
  final RawStats stats;
  final String unit;

  const MetricStatisticsCard({
    super.key,
    required this.stats,
    required this.unit,
  });

  List<KeyValue> _statistics(MetricStats s, String u) {
    return [
      KeyValue(
        'Mean',
        icon: Icons.functions,
        value: '${s.mean.toStringAsFixed(2)} $u',
      ),
      KeyValue(
        'Median',
        icon: Icons.center_focus_weak_sharp,
        value: '${s.median.toStringAsFixed(2)} $u',
      ),
      KeyValue(
        'Minimum',
        icon: Icons.arrow_downward,
        value: '${s.minValue.toStringAsFixed(2)} $u',
      ),
      KeyValue(
        'Maximum',
        icon: Icons.arrow_upward,
        value: '${s.maxValue.toStringAsFixed(2)} $u',
      ),
      KeyValue(
        'Range',
        icon: Icons.swap_vert,
        value: '${s.range.toStringAsFixed(2)} $u',
      ),
      KeyValue(
        'Std Dev',
        icon: Icons.scatter_plot,
        value: s.stdDev.toStringAsFixed(2),
      ),
      KeyValue(
        '10th Percentile',
        icon: Icons.percent,
        value: '${s.p10.toStringAsFixed(2)} $u',
      ),
      KeyValue(
        '90th Percentile',
        icon: Icons.percent,
        value: '${s.p90.toStringAsFixed(2)} $u',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fullStats = MetricStats.calculate(stats);
    return CommonCard(child: KeyValueList(_statistics(fullStats, unit)));
  }
}
