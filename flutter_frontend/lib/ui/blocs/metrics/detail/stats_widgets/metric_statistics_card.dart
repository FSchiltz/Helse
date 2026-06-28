import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_stats.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_histogram.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_information.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/ui_constants.dart';

class MetricStatisticsCard extends StatelessWidget {
  final RawStats stats;

  final MetricType type;

  const MetricStatisticsCard({
    super.key,
    required this.stats,

    required this.type,
  });

  List<KeyValue> _statistics(MetricStats s, String u) {
    return [
      KeyValue(
        'Mean',
        icon: Icons.update,
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fullStats = MetricStats.calculate(stats);
    final theme = Theme.of(context);
    return CommonCard(
      child: Column(
        spacing: UIConstants.headerPad,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: UIConstants.formPad),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: MetricInformation(
              _statistics(fullStats, type.unit.code),
              type: type,
            ),
          ),
          MetricHistogram(stats, type),
        ],
      ),
    );
  }
}
