import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_details.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_selected.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_timeline_graph.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_information.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_text_histogram.dart';
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

    return Column(
      spacing: UIConstants.formPad,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...buildHeader(),
        SizedBox(
          height: 120,
          child: MetricTimelineGraph(
            filteredMetrics.values,
            widget.date,
            widget.type,
            selection: selection,
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: UIConstants.formPad,
              alignment: WrapAlignment.start,
              children: [
                CommonCard(
                  child: Column(
                    spacing: UIConstants.headerPad,
                    children: [
                      MetricInformation([
                        KeyValue(
                          locale.total,
                          value: filteredMetrics.values.length.toString(),
                          icon: Icons.numbers_sharp,
                        ),
                      ], type: widget.type),
                      MetricTextHistogram(
                        MetricHelper.groupText(filteredMetrics.values),
                        widget.type,
                        onselect: selection.select,
                      ),
                    ],
                  ),
                ),
                MetricSelected(
                  selection: selection,
                  type: widget.type,
                  reset: widget.reset,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
