import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class MetricGrouped {
  final List<Metric> metrics;
  final DateTime date;
  List<double> value;

  MetricGrouped(this.date, this.value, this.metrics);
}
