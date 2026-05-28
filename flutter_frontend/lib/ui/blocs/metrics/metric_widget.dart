import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/blocs/metrics/metric_detail_page.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'metric_add.dart';
import 'metric_condensed.dart';

class MetricWidget extends StatefulWidget {
  final MetricType type;
  final DateTimeRange date;
  final int? person;
  final OrderedItem settings;

  const MetricWidget(
    this.type,
    this.settings,
    this.date, {
    super.key,
    this.person,
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
    var id = widget.type.id;
    if (id == null) {
      return [];
    }

    var date = widget.date;

    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(
      date.end.year,
      date.end.month,
      date.end.day,
    ).add(const Duration(days: 1));

    return await DI.metric.metrics(
      id,
      start,
      end,
      person: widget.person,
      simple: true,
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
                    child: Text(
                      _getTextInfo(data, widget.type),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                Flexible(
                  child: MetricCondensed(
                    data,
                    widget.type,
                    widget.settings,
                    widget.date,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTextInfo(List<Metric> metrics, MetricType type) {
    String? value;
    switch (type.summaryType) {
      case MetricSummary.sum:
        value = metrics
            .map((metric) => double.parse(metric.value))
            .sum
            .toString();
        break;
      case MetricSummary.mean:
        value =
            (metrics.map((metric) => double.parse(metric.value)).sum /
                    metrics.length)
                .round()
                .toString();
        break;
      case MetricSummary.latest:
      default:
        value = metrics.last.value;
        break;
    }

    if (type.unit != null) {
      value += ' ${type.unit}';
    }

    return value;
  }
}
