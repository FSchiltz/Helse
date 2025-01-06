import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

class MetricHelper {

  static String getMetricText(Metric metric) {
    String tag = '';

    if (metric.tag != null) tag += ': ${metric.tag}';
    if (metric.source != null && metric.source != FileTypes.none) {
      tag += '(${metric.source?.name})';
    }
    return tag;
  }
}
