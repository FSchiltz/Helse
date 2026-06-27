import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_stats.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class MetricOutliers extends StatelessWidget {
  final MetricStats stats;
  final String unit;

  const MetricOutliers({super.key, required this.stats, required this.unit});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: KeyValueList(
        stats.outliers.take(10)
            .map(
              (e) => KeyValue(
                'Outliers',
                icon: Icons.warning_amber_sharp,
                value: e.toString(),
              ),
            )
            .toList(),
      ),
    );
  }
}
