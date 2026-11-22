import 'package:flutter_test/flutter_test.dart';
import 'package:helse/helpers/metrics/metric_validation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';

void main() {
  test('validates number metrics', () {
    expect(validateMetricValue('12.5', MetricDataType.number), isNull);
    expect(
      validateMetricValue('not a number', MetricDataType.number),
      MetricValueIssue.invalidNumber,
    );
  });

  test('validates number range count and values', () {
    expect(
      validateMetricValue('120;80', MetricDataType.numberrange, valueCount: 2),
      isNull,
    );
    expect(
      validateMetricValue('120', MetricDataType.numberrange, valueCount: 2),
      MetricValueIssue.insufficientRangeValues,
    );
    expect(
      validateMetricValue(
        '120;invalid',
        MetricDataType.numberrange,
        valueCount: 2,
      ),
      MetricValueIssue.invalidRangeNumber,
    );
  });
}
