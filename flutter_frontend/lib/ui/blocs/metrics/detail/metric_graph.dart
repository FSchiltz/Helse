import 'dart:async';
import 'dart:math';
import 'dart:developer' as logger;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_statistics_card.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';
import 'package:helse/ui/common/navigator_chart.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';
import 'package:helse/ui/common/inputs/date_range_picker.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../helpers/date_helper.dart';

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
  RangeList filteredMetrics = RangeList.empty();
  RangeList groupedMetrics = RangeList.empty();

  final StreamController<Map<String, Set<int>>?> _selection =
      StreamController.broadcast();

  DateTimeRange subDate = DateHelper.now();

  void _setDate(DateTimeRange value) {
    logger.log('set date with $value', name: "Metrics");
    var filter = _filter(widget.metrics, value);
    var grouped = MetricHelper.group(filter, value, 500, widget.type);
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

    var initGroup = MetricHelper.group(
      widget.metrics,
      subDate,
      500,
      widget.type,
    );
    filteredMetrics = initGroup;
    groupedMetrics = initGroup;

    if (initGroup.values.length == 1) {
      _metric = initGroup.values.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final metric = _metric;
    return Column(
      spacing: UIConstants.formPad,
      children: [
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
          ),
        ),
        Expanded(
          child: _grapichChart(context, max(widget.type.valueCount ?? 1, 1)),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                ...filteredMetrics.stats.map(
                  (e) => MetricStatisticsCard(stats: e, type: widget.type),
                ),
                MetricDataTable(
                  person: widget.person,
                  type: widget.type,
                  reset: widget.reset,
                  count: metric?.metrics.length ?? 0,
                  callback: (page, count) async {
                    return metric?.metrics
                            .skip(page * count)
                            .take(count)
                            .toList() ??
                        [];
                  },
                ),
              ],
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
    List<Mark<Shape>> marks;
    marks = [];

    for (var i = 0; i < graphCount; i++) {
      var color = Dependencies.theme.stateColor(
        MetricHelper.getStateKey(widget.type, i),
        StateType.metric,
        context,
      );
      if (widget.settings == GraphKind.line) {
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
      } else {
        marks = [
          IntervalMark(
            position: Varset('date') * Varset('value$i'),
            size: SizeEncode(value: 5),
            color: ColorEncode(value: color),
            selected: {
              'touchMove': {1},
            },
            selectionStream: _selection,
          ),
        ];
      }
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
      final index = i;
      variables['value$i'] = Variable(
        accessor: (MetricGrouped datumn) {
          return datumn.value[index];
        },
        scale: LinearScale(min: 0, max: filteredMetrics.maxY),
      );
    }

    logger.log(
      'created graph for $subDate and ${filteredMetrics.values.length}',
      name: "Metrics",
    );
    return filteredMetrics.values.isEmpty
        ? Text('No data')
        : Chart(
            data: filteredMetrics.values,
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

    var metric = filteredMetrics.values[click.value.first];
    _selectionChanged(metric);
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
}
