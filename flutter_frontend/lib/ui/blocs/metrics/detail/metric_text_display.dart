import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_timeline_graph.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_information.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_text_histogram.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/ui_constants.dart';

class MetricTextDisplay extends StatefulWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final MetricType type;
  final int? person;
  final void Function() reset;

  const MetricTextDisplay(
    this.metrics,
    this.date,
    this.type, {
    super.key,
    this.person,
    required this.reset,
  });

  @override
  State<MetricTextDisplay> createState() => _MetricTextDisplayState();
}

class _MetricTextDisplayState extends State<MetricTextDisplay> {
  List<Metric> selected = [];
  int key = 0;

  @override
  void initState() {
    if (widget.metrics.length == 1) {
      selected = widget.metrics;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return Wrap(
      spacing: UIConstants.formPad,
      children: [
        SizedBox(height: UIConstants.headerPad),
        SizedBox(
          height: 120,
          child: MetricTimelineGraph(
            widget.metrics,
            widget.date,
            widget.type,
            onselect: (metric) => setState(() {
              selected = metric;
              key++;
            }),
          ),
        ),
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
              ),
            ],
          ),
        ),
        CommonCard(
          child: (selected.isEmpty)
              ? SizedBox.shrink()
              : MetricDataTable(
                  count: selected.length,
                  type: widget.type,
                  reset: widget.reset,
                  state: key,
                  callback: (page, count) async {
                    return selected.skip(page * count).take(count).toList();
                  },
                ),
        ),
      ],
    );
  }
}
