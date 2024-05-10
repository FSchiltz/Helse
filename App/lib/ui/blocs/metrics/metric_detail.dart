import 'package:flutter/material.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_condensed.dart';
import 'package:helse/ui/blocs/metrics/metric_graph.dart';

import '../../../logic/settings/ordered_item.dart';
import '../common/date_range_input.dart';

class MetricDetailPage extends StatefulWidget {
  const MetricDetailPage({
    super.key,
    required this.metrics,
    required this.date,
    required this.type,
    required this.settings,
  });

  final DateTimeRange date;
  final List<Metric> metrics;
  final MetricType type;
  final GraphKind settings;

  @override
  State<MetricDetailPage> createState() => _MetricDetailPageState();
}

class _MetricDetailPageState extends State<MetricDetailPage> {
  DateTimeRange? _date;
  List<Metric> _metrics = [];

  @override
  void initState() {
    super.initState();
    var date = DateTimeRange(start: widget.date.start, end: widget.date.start.add(const Duration(days: 1)));
    _date = date;
    _metrics = _filter(widget.metrics, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0, top: 60.0),
        child: widget.metrics.isEmpty
            ? Center(
                child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
              )
            : (widget.type.type == MetricDataType.text
                ? ListView.builder(
                    itemCount: widget.metrics.length,
                    itemBuilder: (x, y) => Row(children: [Text(widget.metrics[y].$value ?? ''), Text(MetricHelper.getMetricText(widget.metrics[y]))]),
                  )
                : Column(
                    children: [
                      SizedBox(height: 120, child: WidgetGraph(widget.metrics, widget.date, GraphKind.line, widget.type.summaryType ?? MetricSummary.latest)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: DateRangeInput(
                              _setDate,
                              _date ?? widget.date,
                              range: widget.date,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: MetricGraph(_metrics, _date!, widget.settings)),
                    ],
                  )),
      )),
    );
  }

  void _setDate(DateTimeRange date) {
    var metrics = _filter(widget.metrics, date);
    setState(() {
      _date = date;
      _metrics = metrics;
    });
  }

  List<Metric> _filter(List<Metric> metrics, DateTimeRange date) {
    return metrics.where((metric) => (metric.date!.compareTo(date.start) >= 0 && metric.date!.compareTo(date.end) <= 0)).toList();
  }
}
