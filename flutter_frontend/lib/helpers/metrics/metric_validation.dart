import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

enum MetricValueIssue {
  invalidNumber,
  insufficientRangeValues,
  invalidRangeNumber,
}

MetricValueIssue? validateMetricValue(
  String value,
  MetricDataType? type, {
  int? valueCount,
}) {
  switch (type) {
    case MetricDataType.number:
      return double.tryParse(value) == null
          ? MetricValueIssue.invalidNumber
          : null;
    case MetricDataType.numberrange:
      final values = value.split(';');
      if (values.length < (valueCount ?? 0)) {
        return MetricValueIssue.insufficientRangeValues;
      }
      if (values.any((item) => double.tryParse(item) == null)) {
        return MetricValueIssue.invalidRangeNumber;
      }
      return null;
    default:
      return null;
  }
}
