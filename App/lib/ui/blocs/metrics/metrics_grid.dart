
import 'package:flutter/material.dart';

import '../../../services/swagger_generated_code/swagger.swagger.dart';
import 'metric_widget.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({
    super.key,
    required this.types,
    required this.date,
  });

  final List<MetricType> types;
  final DateTimeRange date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: types.isEmpty
          ? const CircularProgressIndicator()
          : GridView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                var type = types[index];
                return MetricWidget(type, date, key: Key(type.id?.toString() ?? ""));
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width ~/ 200).toInt(),
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5,
              ),
            ),
    );
  }
}
