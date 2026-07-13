import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_text.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';

class MetricCondensed extends StatelessWidget {
  final MetricSummaries metrics;
  final MetricType type;
  final DateTimeRange date;
  final OrderedItem settings;
  final int tile;

  const MetricCondensed(
    this.metrics,
    this.type,
    this.settings,
    this.date, {
    super.key,
    required this.tile,
  });

  @override
  Widget build(BuildContext context) {
    return metrics.metrics.isEmpty
        ? Center(
            child: Text(
              Translation.of(context).nodata,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : (type.type == MetricDataType.text || settings.graph == GraphKind.text
              ? Center(child: WidgetText(metrics, date, type))
              : Padding(
                  padding: const EdgeInsets.all(UIConstants.textPad),
                  child: WidgetGraph(
                    metrics.metrics,
                    date,
                    type,
                    settings.graph ?? GraphKind.text,
                    tile: tile,
                    width: 2,
                  ),
                ));
  }
}
