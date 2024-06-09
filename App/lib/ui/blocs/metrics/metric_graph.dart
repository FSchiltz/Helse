import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

import '../../../helpers/date.dart';

class MetricGraph extends StatefulWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final GraphKind settings;
  static const int valueCount = 24;
  final void Function(Metric metric) selectionCallback;

  const MetricGraph(this.metrics, this.date, this.settings, this.selectionCallback, {super.key});

  @override
  State<MetricGraph> createState() => _MetricGraphState();
}

class _MetricGraphState extends State<MetricGraph> {
  final StreamController<Map<String, Set<int>>?> _selection = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _selection.stream.listen(onData);
  }

  @override
  Widget build(BuildContext context) {
    return _getGraph(context);
  }

  Widget _getGraph(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    List<Mark<Shape>> marks;
    if (widget.settings == GraphKind.line) {
      marks = [
        PointMark(
          size: SizeEncode(value: 4),
          color: ColorEncode(value: theme.onSecondary),
          selected: {
            'touchMove': {1}
          },
          selectionStream: _selection,
        ),
        AreaMark(
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

    return Chart(
      data: widget.metrics,
      variables: {
        'date': Variable(
          accessor: (Metric datumn) => datumn.date!,
          scale: TimeScale(
            min: widget.date.start,
            max: widget.date.end,
            formatter: (time) => DateHelper.format(time, context: context),
          ),
        ),
        'value': Variable(
          accessor: (Metric datumn) => int.tryParse(datumn.$value ?? '0') ?? 0,
          scale: LinearScale(),
        ),
      },
      marks: marks,
      selections: {
        'hover': PointSelection(
          on: {GestureType.hover, GestureType.tapDown, GestureType.longPressMoveUpdate},
          dim: Dim.x,
        ),
        'click': PointSelection(
          on: {GestureType.tap, GestureType.tapDown, GestureType.longPressMoveUpdate},
          dim: Dim.x,
        )
      },
      crosshair: CrosshairGuide(followPointer: [false, false]),
      tooltip: TooltipGuide(
        followPointer: [false, false],
        align: Alignment.topLeft,
        offset: const Offset(-20, -20),
      ),
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
    );
  }

  void onData(Map<String, Set<int>>? event) {
    var click = event?.entries.firstWhereOrNull((x) => x.key == 'click');
    if (click == null) return;
    
    var metric = widget.metrics[click.value.first];
    widget.selectionCallback(metric);
  }
}
