import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class MetricGrouped {
  final List<Metric> metrics;
  final DateTime date;
  double value;
  double max;
  double min;

  MetricGrouped(
    this.date,
    this.value,
    this.metrics, {
    this.max = 0,
    this.min = 0,
  });
}
