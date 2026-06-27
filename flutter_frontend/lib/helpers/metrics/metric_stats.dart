import 'dart:math';

class MetricStats {
  MetricStats({
    this.minValue = 0,
    this.maxValue = 0,
    this.mean = 0,
    this.median = 0,
    this.p10 = 0,
    this.p90 = 0,
    this.coefficientOfVariation = 0,
    this.stdDev = 0,
    required this.outliers,
  });

  factory MetricStats.calculate(
    List<double> values, {
    required double min,
    required double max,
    required double mean,
  }) {
    // first sort the value
    if (values.isEmpty) {
      return MetricStats(outliers: []);
    }
    final sorted = values..sort();

    // do all stats that need the sorted version

    final median = (sorted.length.isOdd)
        ? sorted[sorted.length ~/ 2]
        : (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2;

    final p10 = percentile(0.1, sorted);
    final p90 = percentile(0.9, sorted);

    final p01 = percentile(0.01, sorted);
    final p99 = percentile(0.99, sorted);

    final outliers = values.where((v) => v < p01 || v > p99).toList();

    // loop once more to finish the stats
    double variance =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
        values.length;
    final stdDev = sqrt(variance);
    final double coefficientOfVariation = (mean == 0)
        ? 0
        : (stdDev / mean) * 100;

    return MetricStats(
      minValue: min,
      maxValue: max,
      mean: mean,
      median: median,
      p10: p10,
      p90: p90,
      coefficientOfVariation: coefficientOfVariation,
      stdDev: stdDev,
      outliers: outliers,
    );
  }

  final double minValue;
  final double maxValue;
  final double mean;
  final double median;
  final double p10;
  final double p90;
  final double stdDev;
  final double coefficientOfVariation;
  final List<double> outliers;

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
