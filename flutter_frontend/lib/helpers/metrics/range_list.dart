import 'package:helse/helpers/metrics/metric_stats.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';

class RangeList {
  final List<MetricGrouped> values;
  final double min;
  final double max;
  final MetricStats stats;

  RangeList({
    required this.values,
    required this.min,
    required this.max,
    required this.stats,
  });

  factory RangeList.empty() {
    return RangeList(
      values: [],
      min: 0,
      max: 0,
      stats: MetricStats(outliers: []),
    );
  }
}
