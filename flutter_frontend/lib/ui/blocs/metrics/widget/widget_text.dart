import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/ui_constants.dart';

class WidgetText extends StatelessWidget {
  final MetricSummaries metrics;
  final DateTimeRange<DateTime> date;
  final MetricType type;

  const WidgetText(this.metrics, this.date, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: UIConstants.textPad,
      children: [
        Text('${metrics.count} items'),
        ...metrics.metrics.map((e) => Text('- ${e.value}')),
      ],
    );
  }
}
