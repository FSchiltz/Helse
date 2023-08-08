import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import 'metric_widget.dart';

class MetricsGrid extends StatelessWidget {
  final int? person;
  const MetricsGrid({
    super.key,
    required this.types,
    required this.date,
    this.person,
  });

  final List<MetricType> types;
  final DateTimeRange date;

  @override
  Widget build(BuildContext context) {
    return types.isEmpty
        ? const CircularProgressIndicator()
        : GridView.extent(
            shrinkWrap: true,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            maxCrossAxisExtent: 180.0,
            children: types.map((type) => MetricWidget(type, date, key: Key(type.id?.toString() ?? ""), person: person)).toList(),
          );
  }
}
