import 'dart:developer' as logger;

import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';
import 'package:helse/ui/common/inputs/date_range_picker.dart';
import 'package:helse/ui/common/navigator_chart.dart';

abstract class MetricDetails extends StatefulWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final void Function() reset;
  final int? person;
  final MetricType type;
  final GraphKind settings;

  const MetricDetails(
    this.metrics,
    this.date,
    this.settings,
    this.reset, {
    super.key,
    this.person,
    required this.type,
  });
}

abstract class MetricDetailsState<T extends MetricDetails> extends State<T> {
  RangeList filteredMetrics = RangeList.empty();
  DateTimeRange subDate = DateHelper.now();
  final SelectionController<Metric> selection = SelectionController();
  late double maxY;

  @override
  void initState() {
    super.initState();
    subDate = widget.date;

    var initGroup = MetricHelper.group(
      widget.metrics,
      subDate,
      500,
      widget.type,
    );
    maxY = initGroup.maxY;
    filteredMetrics = initGroup;

    if (initGroup.values.length == 1) {
      selection.select(initGroup.values.first.metrics);
    }
  }

  List<Metric> _filter(List<Metric> metrics, DateTimeRange<DateTime> value) {
    final stopwatch = Stopwatch()..start();
    logger.log('Filter for $value');
    var metrics = widget.metrics
        .where((x) => x.date.isAfter(value.start) && x.date.isBefore(value.end))
        .toList();
    logger.log(
      '_filter() executed in ${stopwatch.elapsed} with ${metrics.length} items',
      name: "Metrics",
    );
    return metrics;
  }

  void _setDate(DateTimeRange value) {
    logger.log('set date with $value', name: "Metrics");
    var filter = _filter(widget.metrics, value);
    var grouped = MetricHelper.group(filter, value, 500, widget.type);
    setState(() {
      subDate = value;
      filteredMetrics = grouped;
    });
  }

  List<Widget> buildHeader() {
    return [
      DateRangePicker(
        _setDate,
        subDate,
        range: widget.date,
        offset: widget.type.timeDifference,
      ),
      NavigatorChart(
        widget.date,
        subDate,
        _setDate,
        graph: WidgetGraph(
          widget.metrics
              .map(
                (e) => Metric(
                  id: 0,
                  date: e.date,
                  value: e.value.toString(),
                  type: 0,
                  sourceId: '',
                  person: 0,
                ),
              )
              .toList(),
          widget.date,
          widget.type,
          widget.settings,
          tile: widget.metrics.length,
          width: 1,
          maxY: maxY,
        ),
      ),
    ];
  }
}
