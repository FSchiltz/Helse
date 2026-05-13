import 'package:flutter/material.dart';
import 'package:helse/helpers/pair.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widget.dart';

class MetricWidgetsGrid extends StatelessWidget {
  const MetricWidgetsGrid({
    super.key,
    required this.cached,
    required this.date,
    this.person,
  });
  final DateTimeRange<DateTime> date;
  final int? person;
  final List<Pair<MetricType, OrderedItem>> cached;

  @override
  Widget build(BuildContext context) {
    if (cached.isEmpty) {
      return const Text("No metrics");
    } else {
      return GridView.extent(
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: const BouncingScrollPhysics(),
        maxCrossAxisExtent: 200.0,
        children: cached
            .map(
              (type) => MetricWidget(
                type.a,
                type.b,
                date,
                key: Key(type.a.id?.toString() ?? ""),
                person: person,
              ),
            )
            .toList(),
      );
    }
  }
}
