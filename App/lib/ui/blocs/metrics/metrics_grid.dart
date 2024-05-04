import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../loader.dart';
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
        ? const HelseLoader()
        : GridView.extent(
            shrinkWrap: true,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            physics: const BouncingScrollPhysics(),
            maxCrossAxisExtent: 280.0,
            children: types.map((type) => MetricWidget(type, date, key: Key(type.id?.toString() ?? ""), person: person)).toList(),
          );
  }
}
