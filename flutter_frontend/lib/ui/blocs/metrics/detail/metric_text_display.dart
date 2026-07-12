import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_details.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_timeline_graph.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_information.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_text_histogram.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/ui_constants.dart';

class MetricTextDisplay extends MetricDetails {
  const MetricTextDisplay(
    List<Metric> metrics,
    DateTimeRange date,
    void Function() reset, {
    super.key,
    super.person,
    required super.type,
  }) : super(metrics, date, GraphKind.text, reset);

  @override
  State<MetricTextDisplay> createState() => _MetricTextDisplayState();
}

class _MetricTextDisplayState extends MetricDetailsState<MetricTextDisplay> {
  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    final metric = selected;

    return Column(
      spacing: UIConstants.formPad,
      children: [
        ...buildHeader(),
        SizedBox(
          height: 120,
          child: MetricTimelineGraph(
            widget.metrics,
            widget.date,
            widget.type,
            onselect: (metrics) => setState(() {
              selected = MetricGrouped(DateTime.now(), metrics);
            }),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: UIConstants.formPad,
              children: [
                CommonCard(
                  child: Column(
                    spacing: UIConstants.headerPad,
                    children: [
                      MetricInformation([
                        KeyValue(
                          locale.total,
                          value: widget.metrics.length.toString(),
                          icon: Icons.numbers_sharp,
                        ),
                      ], type: widget.type),
                      MetricTextHistogram(
                        MetricHelper.groupText(widget.metrics),
                        widget.type,
                        onselect: (values) => setState(() {
                          selected = MetricGrouped(DateTime.now(), values);
                        }),
                      ),
                    ],
                  ),
                ),
                CommonCard(
                  child: (metric == null || metric.metrics.isNotEmpty)
                      ? SizedBox.shrink()
                      : MetricDataTable(
                          count: metric.metrics.length,
                          type: widget.type,
                          reset: widget.reset,
                          callback: (page, count) async {
                            return metric.metrics
                                .skip(page * count)
                                .take(count)
                                .toList();
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
