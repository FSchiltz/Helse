import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';
import 'package:helse/ui/common/navigator_chart.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';
import 'package:helse/ui/common/date_range_picker.dart';

import '../../../../helpers/date.dart';

class MetricGraph extends StatefulWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final GraphKind settings;
  static const int valueCount = 24;
  final void Function() reset;
  final int? person;
  final MetricType type;

  const MetricGraph(
    this.metrics,
    this.date,
    this.settings,
    this.reset, {
    super.key,
    this.person,
    required this.type,
  });

  @override
  State<MetricGraph> createState() => _MetricGraphState();
}

class _MetricGraphState extends State<MetricGraph> {
  MetricGrouped? _metric;
  List<MetricGrouped> filteredMetrics = [];
  List<MetricGrouped> groupedMetrics = [];
  int _graphCount = 0;

  final StreamController<Map<String, Set<int>>?> _selection =
      StreamController.broadcast();

  DateTimeRange subDate = DateHelper.now();

  void _setDate(DateTimeRange value) {
    debugPrint('set date with $value');
    var filter = _filter(widget.metrics, value);
    var grouped = _group(filter, _graphCount);
    setState(() {
      subDate = value;
      filteredMetrics = grouped;
    });
  }

  @override
  void initState() {
    super.initState();
    subDate = widget.date;
    _selection.stream.listen(_onData);

    _graphCount = widget.type.valueCount ?? 1;
    var initGroup = _group(widget.metrics, _graphCount);
    filteredMetrics = initGroup;
    groupedMetrics = initGroup;
  }

  @override
  Widget build(BuildContext context) {
    final metric = _metric;
    var locale = Translation.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateRangePicker(_setDate, subDate, range: widget.date),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: NavigatorChart(
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
            ),
          ),
        ),
        Expanded(child: _grapichChart(context, _graphCount)),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Center(
                child: MetricDataTable(
                  locale: locale,
                  metrics: metric?.metrics,
                  person: widget.person,
                  type: widget.type,
                  reset: widget.reset,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectionChanged(MetricGrouped metric) {
    setState(() {
      _metric = metric;
    });
  }

  Widget _grapichChart(BuildContext context, int graphCount) {
    var color = Dependencies.theme.stateColor(
      widget.type.id.toString(),
      StateType.metric,
      context,
      true,
    );

    Dependencies.theme.save();

    List<Mark<Shape>> marks;
    if (widget.settings == GraphKind.line) {
      marks = [];

      for (var i = 0; i < graphCount; i++) {
        marks.add(
          LineMark(
            position: Varset('date') * Varset('value$i'),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: color),
          ),
        );
        marks.add(
          PointMark(
            position: Varset('date') * Varset('value$i'),
            size: SizeEncode(value: 3),
            color: ColorEncode(value: color),
            selected: {
              'touchMove': {1},
            },
            selectionStream: _selection,
          ),
        );
      }
    } else {
      marks = [
        IntervalMark(
          size: SizeEncode(value: 5),
          color: ColorEncode(value: color),
          selected: {
            'touchMove': {1},
          },
          selectionStream: _selection,
        ),
      ];
    }

    final Map<String, Variable<MetricGrouped, dynamic>> variables = {
      'date': Variable(
        accessor: (MetricGrouped datumn) => datumn.date.toLocal(),
        scale: TimeScale(
          min: subDate.start,
          max: subDate.end,
          formatter: (time) => DateHelper.format(time, context: context),
        ),
      ),
    };

    for (int i = 0; i < graphCount; i++) {
      variables['value$i'] = Variable(
        accessor: (MetricGrouped datumn) => datumn.value[i],
        scale: LinearScale(min: 0),
      );
    }

    debugPrint('created graph for $subDate and ${filteredMetrics.length}');
    return filteredMetrics.isEmpty
        ? Text('No data')
        : Chart(
            data: filteredMetrics,
            variables: variables,
            marks: marks,
            selections: {
              'hover': PointSelection(on: {GestureType.hover}, dim: Dim.x),
              'click': PointSelection(
                on: {
                  GestureType.tap,
                  GestureType.tapDown,
                  GestureType.longPressMoveUpdate,
                },
                dim: Dim.x,
              ),
            },
            crosshair: CrosshairGuide(followPointer: [false, false]),
            tooltip: TooltipGuide(
              followPointer: [true, true],
              align: Alignment.topLeft,
              offset: const Offset(0, -0),
            ),
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          );
  }

  void _onData(Map<String, Set<int>>? event) {
    var click = event?.entries.firstWhereOrNull((x) => x.key == 'click');
    if (click == null) return;

    var metric = filteredMetrics[click.value.first];
    _selectionChanged(metric);
  }

  List<MetricGrouped> _group(List<Metric> metrics, int graphCount) {
    final stopwatch = Stopwatch()..start();
    final max = 500;
    if (metrics.length <= max) {
      // no need to group
      return metrics
          .map(
            (e) => MetricGrouped(
              e.date,
              MetricHelper.getValue(e.value, widget.type.type),
              [e],
            ),
          )
          .toList();
    }

    // First create the buckets
    final bucketLength = subDate.duration.inMilliseconds / max;

    debugPrint(
      'grouping with buckets: $max and bucket lenght: $bucketLength for $subDate',
    );

    final grouped = MetricHelper.group(
      metrics,
      subDate,
      bucketLength,
      widget.type,
    );

    debugPrint(
      '_group() executed in ${stopwatch.elapsed} with ${grouped.length} bucket',
    );
    return grouped;
  }

  List<Metric> _filter(List<Metric> metrics, DateTimeRange<DateTime> value) {
    final stopwatch = Stopwatch()..start();
    debugPrint('Filter for $value');
    var metrics = widget.metrics
        .where((x) => x.date.isAfter(value.start) && x.date.isBefore(value.end))
        .toList();
    debugPrint(
      '_filter() executed in ${stopwatch.elapsed} with ${metrics.length} items',
    );
    return metrics;
  }
}
