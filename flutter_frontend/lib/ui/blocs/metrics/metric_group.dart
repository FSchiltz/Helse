import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class MetricGrouped {
  final List<Metric> metrics;
  final DateTime date;
  final double value;
  final double max;
  final double min;

  const MetricGrouped(
    this.date,
    this.value,
    this.metrics, {
    this.max = 0,
    this.min = 0,
  });
}
