import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/delete_metric.dart';
import 'package:helse/ui/blocs/metrics/metric_add.dart';
import 'package:helse/ui/blocs/metrics/metric_group.dart';
import 'package:helse/ui/common/date_range_picker.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../helpers/date.dart';

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

  final StreamController<Map<String, Set<int>>?> _selection =
      StreamController.broadcast();

  DateTimeRange subDate = DateHelper.now();

  void _setDate(DateTimeRange value) {
    var filter = widget.metrics
        .where((x) => x.date.isAfter(value.start) && x.date.isBefore(value.end))
        .toList();

    setState(() {
      subDate = value;
      filteredMetrics = _group(filter);
    });
  }

  @override
  void initState() {
    super.initState();
    subDate = widget.date;
    _selection.stream.listen(_onData);
    filteredMetrics = _group(widget.metrics);
  }

  @override
  Widget build(BuildContext context) {
    return _getGraph(context);
  }

  void _selectionChanged(MetricGrouped metric) {
    setState(() {
      _metric = metric;
    });
  }

  Widget _getGraph(BuildContext context) {
    final metric = _metric;

    var isLargeScreen =
        MediaQuery.of(context).size.width > UIConstants.displaySmall;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateRangePicker(
            _setDate,
            subDate,
            isLargeScreen,
            range: widget.date,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: _getWidth(widget.date, context),
              child: _grapichChart(context),
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: metric?.metrics.length,
            itemBuilder: (context, index) {
              var current = metric?.metrics[index];
              var id = current?.id;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                shadowColor: Theme.of(context).colorScheme.shadow,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Selected${current != null ? ' (${current.id})' : ''} :',
                        ),
                      ),
                      if (current != null)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${current.value}${widget.type.unit} on ${DateHelper.format(current.date.toLocal(), context: context)}',
                          ),
                        ),
                      if (current != null)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(current.tag.toString()),
                        ),
                      if (current != null && current.source != FileTypes.none)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('by ${current.source}'),
                        ),
                      if (current != null)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return MetricAdd(
                                    widget.type,
                                    widget.reset,
                                    person: widget.person,
                                    edit: current,
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit_sharp),
                          ),
                        ),
                      if (id != null)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteMetric(() async {
                                    await DI.metric.deleteMetrics(id);
                                    widget.reset();
                                    setState(() {
                                      _metric = null;
                                    });
                                  }, person: widget.person);
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_sharp),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _flChart(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchCallback: (event, response) {
            var lines = response?.lineBarSpots;
            if (lines != null && lines.isNotEmpty) {
              // handle tap here
              var spots = lines[0];
              _selectionChanged(filteredMetrics[spots.spotIndex]);
            }
          },
        ),
        lineBarsData: [
          LineChartBarData(
            barWidth: 2,
            preventCurveOverShooting: true,
            spots: filteredMetrics
                .map(
                  (e) =>
                      FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.value),
                )
                .toList(),
            isCurved: true,
            curveSmoothness: 0.002,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _grapichChart(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    List<Mark<Shape>> marks;
    if (widget.settings == GraphKind.line) {
      marks = [
        PointMark(
          size: SizeEncode(value: 3),
          color: ColorEncode(value: theme.secondary),
          selected: {
            'touchMove': {1},
          },
          selectionStream: _selection,
        ),
        LineMark(
          size: SizeEncode(value: 2),
          color: ColorEncode(value: theme.primary),
        ),
      ];
    } else {
      marks = [
        IntervalMark(
          size: SizeEncode(value: 5),
          color: ColorEncode(value: theme.primary),
        ),
      ];
    }

    return Chart(
      data: filteredMetrics,
      variables: {
        'date': Variable(
          accessor: (MetricGrouped datumn) => datumn.date.toLocal(),
          scale: TimeScale(
            min: subDate.start,
            max: subDate.end,
            formatter: (time) => DateHelper.format(time, context: context),
          ),
        ),
        'value': Variable(
          accessor: (MetricGrouped datumn) => datumn.value,
          scale: LinearScale(),
        ),
      },
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
    var click = event?.entries.firstWhereOrNull(
      (x) => x.key == 'click' || x.key == 'hover',
    );
    if (click == null) return;

    var metric = filteredMetrics[click.value.first];
    _selectionChanged(metric);
  }

  double _getWidth(DateTimeRange<DateTime> date, BuildContext context) {
    int ticks;

    if (date.duration.inDays >= 1) {
      ticks = date.duration.inDays;
    }

    if (date.duration.inHours > 1) {
      ticks = date.duration.inHours;
    }

    if (date.duration.inSeconds > 10) {
      ticks = date.duration.inSeconds;
    }

    ticks = date.duration.inMilliseconds;

    double screen = max(3000, MediaQuery.sizeOf(context).width);
    double width = ticks * 50;
    if (width > screen) {
      return screen;
    }

    return width;
  }

  List<MetricGrouped> _group(List<Metric> filter) {
    // First create the buckets
    var bucketLength = subDate.duration.inMilliseconds / 500;

    List<MetricGrouped> groups = [];
    var start = subDate.start;
    var end = subDate.start.add(Duration(milliseconds: bucketLength.toInt()));

    for (int i = 0; i < 500; i++) {
      var items = filter
          .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
          .toList();

      var values = items.map((e) => double.parse(e.value)).toList();
      if (values.isNotEmpty) {
        double min = values.min;
        double max = values.max;
        double f = values.reduce((a, b) => a + b) / values.length;

        groups.add(
          MetricGrouped(
            start.add(Duration(milliseconds: (bucketLength / 2).toInt())),
            f,
            items,
            min: min,
            max: max,
          ),
        );
      }

      start = end;
      end = end.add(Duration(milliseconds: bucketLength.toInt()));
    }

    return groups;
  }
}
