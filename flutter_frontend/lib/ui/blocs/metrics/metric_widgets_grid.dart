import 'package:flutter/material.dart';
import 'package:helse/helpers/pair.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widget.dart';

class MetricWidgetsGrid extends StatelessWidget {
  const MetricWidgetsGrid({
    super.key,
    required this.cached,
    required this.date,
    this.person,
    this.extend,
    this.button,
  });
  final DateTimeRange<DateTime> date;
  final int? person;
  final List<Pair<MetricType, OrderedItem>> cached;
  final double? extend;
  final Widget? button;

  List<Widget> _buildGrid() {
    List<Widget> items = cached
        .map(
          (type) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            elevation: 2,
            child: MetricWidget(
              type.a,
              type.b,
              date,
              key: Key(type.a.id?.toString() ?? ""),
              person: person,
            ),
          ),
        )
        .toList();

    if (button != null) {
      items.add(
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          elevation: 0,
          child: Padding(padding: const EdgeInsets.all(32.0), child: button),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (cached.isEmpty) {
      return Text(Translation.locale(context).nodata);
    } else {
      return GridView.extent(
        maxCrossAxisExtent: extend ?? 200,
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: const BouncingScrollPhysics(),
        children: _buildGrid(),
      );
    }
  }
}
