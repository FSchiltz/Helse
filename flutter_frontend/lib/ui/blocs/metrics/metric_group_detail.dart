import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widgets_grid.dart';

class MetricGroupDetail extends StatelessWidget {
  final DateTimeRange<DateTime> date;
  final int? person;
  final Group group;
  final List<(MetricType, OrderedItem)> types;

  const MetricGroupDetail(
    this.date,
    this.person,
    this.group, {
    super.key,
    required this.types,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          group.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MetricWidgetsGrid(
              types: types.where((e) => e.$2.visible == true).toList(),
              person: person,
              date: date,
              extend: constraints.maxWidth,
              fullWidth: true,
              tile: 200,
            ),
          ),
        ),
      ),
    );
  }
}
