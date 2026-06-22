import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/widget/metric_widget.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class MetricWidgetsGrid extends StatelessWidget {
  const MetricWidgetsGrid({
    super.key,
    required this.types,
    required this.date,
    this.person,
    this.extend,
    required this.tile,
    this.fullWidth = false,
  });

  final bool fullWidth;
  final DateTimeRange<DateTime> date;
  final int? person;
  final List<(MetricType, OrderedItem)> types;
  final double? extend;
  final int tile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = min(
          (constraints.maxWidth - 9 - 24) / 2,
          200,
        ).toDouble();
        final maxWidth = fullWidth ? (constraints.maxWidth) : maxHeight;
        return Wrap(
          runSpacing: 6,
          spacing: 6,
          children: types
              .map(
                (type) => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                  ),
                  child: CommonCard(
                    padding: false,
                    child: MetricWidget(
                      type.$1,
                      type.$2,
                      DateHelper.offset(date, type.$1.timeDifference),
                      key: Key(type.$1.id.toString()),
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
