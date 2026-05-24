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
  Metric? _metric;
  final StreamController<Map<String, Set<int>>?> _selection =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _selection.stream.listen(onData);
  }

  @override
  Widget build(BuildContext context) {
    return _getGraph(context);
  }

  void _selectionChanged(Metric metric) {
    setState(() {
      _metric = metric;
    });
  }

  Widget _getGraph(BuildContext context) {
    var id = _metric?.id;
    final metric = _metric;

    var theme = Theme.of(context).colorScheme;

    List<Mark<Shape>> marks;
    if (widget.settings == GraphKind.line) {
      marks = [
        PointMark(
          size: SizeEncode(value: 6),
          color: ColorEncode(value: theme.primary),
          selected: {
            'touchMove': {1},
          },
          selectionStream: _selection,
        ),
        LineMark(
          size: SizeEncode(value: 1),
          color: ColorEncode(value: theme.secondary),
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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: _getWidth(widget.date),
              child: _flChart(context, marks),
            ),
          ),
        ),
        Flexible(
          child: Card(
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
                      'Selected${metric != null ? ' (${metric.id})' : ''} :',
                    ),
                  ),
                  if (metric != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${metric.value}${widget.type.unit} on ${DateHelper.format(metric.date?.toLocal(), context: context)}',
                      ),
                    ),
                  if (metric != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(metric.tag.toString()),
                    ),
                  if (metric != null && metric.source != FileTypes.none)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('by ${metric.source}'),
                    ),
                  if (metric != null)
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
                                edit: metric,
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
          ),
        ),
      ],
    );
  }

  Widget _flChart(BuildContext context, List<Mark<Shape>> marks) {
    return LineChart(
      LineChartData(
        
        lineBarsData: [
          LineChartBarData(
            barWidth: 2,
            preventCurveOverShooting: true,
            spots: widget.metrics
                .map(
                  (e) => FlSpot(
                    e.date?.millisecondsSinceEpoch.toDouble() ?? 0,
                    double.parse(e.value),
                  ),
                )
                .toList(),
            isCurved: true,
            curveSmoothness: 0.002,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _grapichChart(BuildContext context, List<Mark<Shape>> marks) {
    return Chart(
      data: widget.metrics,
      variables: {
        'date': Variable(
          accessor: (Metric datumn) => datumn.date!.toLocal(),
          scale: TimeScale(
            min: widget.date.start,
            max: widget.date.end,

            formatter: (time) => DateHelper.format(time, context: context),
          ),
        ),
        'value': Variable(
          accessor: (Metric datumn) => int.tryParse(datumn.value) ?? 0,
          scale: LinearScale(),
        ),
      },
      marks: marks,
      selections: {
        'hover': PointSelection(
          on: {
            GestureType.hover,
            GestureType.tapDown,
            GestureType.longPressMoveUpdate,
          },
          dim: Dim.x,
        ),
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
        followPointer: [false, false],
        align: Alignment.topLeft,
        offset: const Offset(-20, -20),
      ),
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    );
  }

  void onData(Map<String, Set<int>>? event) {
    var click = event?.entries.firstWhereOrNull((x) => x.key == 'click');
    if (click == null) return;

    var metric = widget.metrics[click.value.first];
    _selectionChanged(metric);
  }

  double _getWidth(DateTimeRange<DateTime> date) {
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

    double width = ticks * 50;
    if (width > 3000) {
      return 3000;
    }

    return width;
  }
}
