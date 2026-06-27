import 'dart:math';

import 'package:helse/helpers/metrics/range_list.dart';

class MetricStats {
  MetricStats({
    this.minValue = 0,
    this.maxValue = 0,
    this.mean = 0,
    this.median = 0,
    this.p01 = 0,
    this.p10 = 0,
    this.p90 = 0,
    this.p99 = 0,
    this.coefficientOfVariation = 0,
    this.stdDev = 0,
  });

  factory MetricStats.calculate(RawStats stats) {
    // first sort the value
    if (stats.values.isEmpty) {
      return MetricStats();
    }

    final sorted = stats.values.map((e) => e.$2).toList()..sort();

    // do all stats that need the sorted version

    final median = (sorted.length.isOdd)
        ? sorted[sorted.length ~/ 2]
        : (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2;

    final p10 = percentile(0.1, sorted);
    final p90 = percentile(0.9, sorted);

    final p01 = percentile(0.01, sorted);
    final p99 = percentile(0.99, sorted);

    // loop once more to finish the stats
    double variance =
        stats.values
            .map((v) => pow(v.$2 - stats.mean, 2))
            .reduce((a, b) => a + b) /
        stats.values.length;
    final stdDev = sqrt(variance);
    final double coefficientOfVariation = (stats.mean == 0)
        ? 0
        : (stdDev / stats.mean) * 100;

    return MetricStats(
      minValue: stats.min,
      maxValue: stats.max,
      mean: stats.mean,
      median: median,
      p01: p01,
      p10: p10,
      p90: p90,
      p99: p99,
      coefficientOfVariation: coefficientOfVariation,
      stdDev: stdDev,
    );
  }

  final double minValue;
  final double maxValue;
  final double mean;
  final double median;
  final double p01;
  final double p10;
  final double p90;
  final double p99;
  final double stdDev;
  final double coefficientOfVariation;

  double get range => maxValue - minValue;

  static double percentile(double p, List<double> sorted) {
    final index = p * (sorted.length - 1);

    final lower = index.floor();
    final upper = index.ceil();

    if (lower == upper) {
      return sorted[lower];
    }

    final fraction = index - lower;

    return sorted[lower] + ((sorted[upper] - sorted[lower]) * fraction);
  }
}
