import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/helpers/pair.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/widget/metric_widget.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class MetricWidgetsGrid extends StatelessWidget {
  const MetricWidgetsGrid({
    super.key,
    required this.cached,
    required this.date,
    this.person,
    this.extend,
    required this.tile,
  });
  final DateTimeRange<DateTime> date;
  final int? person;
  final List<Pair<MetricType, OrderedItem>> cached;
  final double? extend;
  final int tile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = min(
          (constraints.maxWidth - 9 - 24) / 2,
          200,
        ).toDouble();
        return Wrap(
          runSpacing: 6,
          spacing: 6,
          children: cached
              .map(
                (type) => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: maxWidth,
                  ),
                  child: CommonCard(
                    padding: false,
                    child: MetricWidget(
                      type.a,
                      type.b,
                      date,
                      key: Key(type.a.id.toString()),
                      person: person,
                      tile: tile,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
