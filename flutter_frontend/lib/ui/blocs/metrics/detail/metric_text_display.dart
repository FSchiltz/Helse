import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_timeline_graph.dart';
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
  Metric? selected;

  @override
  void initState() {
    if (widget.metrics.length == 1) {
      selected = widget.metrics[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final extended = !UIHelpers.isMobile(context);
    final s = selected;
    return Column(
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
            }),
          ),
        ),
        if (s != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: UIConstants.textPad,
            children: [
              Text('${s.value} ${widget.type.unit.code}'),
              Text(DateHelper.format(s.date.toLocal(), context: context)),
              if (extended) Text(s.tag.toString()),
              if (extended && s.source != ImportTypes.none)
                Text(s.source?.name ?? ''),

              ...MetricHelper.getButtons(
                s,
                widget.type,
                widget.reset,
                context: context,
                person: widget.person,
              ),
            ],
          ),
      ],
    );
  }
}
