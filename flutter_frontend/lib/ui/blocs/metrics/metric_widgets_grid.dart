import 'package:flutter/material.dart';
import 'package:helse/helpers/pair.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/widget/metric_widget.dart';
import 'package:helse/ui/common/common_card.dart';

class MetricWidgetsGrid extends StatelessWidget {
  const MetricWidgetsGrid({
    super.key,
    required this.cached,
    required this.date,
    this.person,
    this.extend,
  });
  final DateTimeRange<DateTime> date;
  final int? person;
  final List<Pair<MetricType, OrderedItem>> cached;
  final double? extend;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: cached
          .map(
            (type) => ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
              child: CommonCard(
                padding: false,
                child: MetricWidget(
                  type.a,
                  type.b,
                  date,
                  key: Key(type.a.id.toString()),
                  person: person,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
