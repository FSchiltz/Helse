import 'package:helse/ui/blocs/metrics/metric_grouped.dart';

class RawStats {
  final double min;
  final double max;
  final double mean;
  final List<(int, double)> values;
  RawStats(
    this.values, {
    required this.min,
    required this.max,
    required this.mean,
  });
}

class RangeList {
  final List<MetricGrouped> values;
  final double maxY;
  final List<RawStats> stats;

  RangeList({required this.values, required this.maxY, required this.stats});

  factory RangeList.empty() {
    return RangeList(values: [], maxY: 0, stats: []);
  }
}
