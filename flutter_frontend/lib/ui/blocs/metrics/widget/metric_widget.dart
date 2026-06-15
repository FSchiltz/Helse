import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_detail_page.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../metric_add.dart';
import 'metric_condensed.dart';

class MetricWidget extends StatefulWidget {
  final MetricType type;
  final DateTimeRange date;
  final int? person;
  final OrderedItem settings;
  final int tile;

  const MetricWidget(
    this.type,
    this.settings,
    this.date, {
    super.key,
    this.person,
    required this.tile,
  });

  @override
  State<MetricWidget> createState() => _MetricWidgetState();
}

class _MetricWidgetState extends State<MetricWidget> {
  _MetricWidgetState();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Metric>> _getData(bool refresh) async {
    return await Dependencies.services.metric.metrics(
      widget.type.id,
      widget.date.start,
      widget.date.end,
      person: widget.person,
      tile: widget.tile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (ctx, data, reset) {
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => MetricDetailPage(
                date: widget.date,
                type: widget.type,
                person: widget.person,
                summary: data,
                settings: widget.settings.detailGraph ?? GraphKind.text,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 1, right: 1),
            child: Column(
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.type.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return MetricAdd(
                                    widget.type,
                                    reset,
                                    person: widget.person,
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add_sharp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (data.isNotEmpty)
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.topCenter,
                      child: _getTextInfo(data, widget.type, context),
                    ),
                  ),

                Flexible(
                  child: MetricCondensed(
                    data,
                    widget.type,
                    widget.settings,
                    widget.date,
                    tile: widget.tile,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getTextInfo(
    List<Metric> metrics,
    MetricType type,
    BuildContext context,
  ) {
    String value = '';
    Icon? icon;
    var color = Dependencies.theme.stateColor(
      "${type.id}",
      StateType.metric,
      context,
      true,
    );

    switch (type.summaryType) {
      case MetricSummary.sum:
        icon = Icon(Icons.trending_up_sharp, color: color);
        value =
            '${metrics.map((metric) => double.parse(metric.value)).sum.round()}';
        break;
      case MetricSummary.mean:
        icon = Icon(Icons.update, color: color);
        value =
            '${(metrics.map((metric) => double.parse(metric.value)).sum / metrics.length).round()}';
        break;
      case MetricSummary.latest:
        break;
      default:
        value = metrics.last.value;
    }

    if (type.unit.code.isNotEmpty) {
      value += ' ${type.unit.code}';
    }

    var text = Text(
      value,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.start,
    );

    if (icon == null) {
      return text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, SizedBox(width: 4), text],
    );
  }
}
