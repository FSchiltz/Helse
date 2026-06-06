import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/detail/navigator_chart.dart';
import 'package:helse/ui/blocs/metrics/metric_group.dart';
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

  final StreamController<Map<String, Set<int>>?> _selection =
      StreamController.broadcast();

  DateTimeRange subDate = DateHelper.now();

  void _setDate(DateTimeRange value) {
    var filter = widget.metrics
        .where((x) => x.date.isAfter(value.start) && x.date.isBefore(value.end))
        .toList();
    var grouped = _group(filter);
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
    var initGroup = _group(widget.metrics);
    filteredMetrics = initGroup;
    groupedMetrics = initGroup;
  }

  @override
  Widget build(BuildContext context) {
    final metric = _metric;
    var locale = Translation.locale(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateRangePicker(_setDate, subDate, range: widget.date),
        ),
        Expanded(child: _grapichChart(context)),
        Container(
          padding: const EdgeInsets.all(24.0),          
          child: SizedBox(
            height: 70,
            child: NavigatorChart(
              groupedMetrics,
              widget.date,
              subDate,
              _setDate,
              widget.settings,
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Center(
                child: MetricDataTable(
                  locale: locale,
                  metric: metric,
                  widget: widget,
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

  Widget _grapichChart(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    List<Mark<Shape>> marks;
    if (widget.settings == GraphKind.line) {
      marks = [
        PointMark(
          position: Varset('date') * Varset('value'),
          size: SizeEncode(value: 5),
          color: ColorEncode(value: theme.secondary),
          selected: {
            'touchMove': {1},
          },
          selectionStream: _selection,
        ),
        LineMark(
          position: Varset('date') * Varset('value'),
          size: SizeEncode(value: 3),
          color: ColorEncode(value: theme.primary),
        ),
        /*
        LineMark(
          position: Varset('date') * Varset('min'),
          size: SizeEncode(value: 1),
          color: ColorEncode(value: theme.outline),
          layer: 2,
        ),
        LineMark(
          position: Varset('date') * Varset('max'),
          size: SizeEncode(value: 1),
          color: ColorEncode(value: theme.outline),
          layer: 2,
        ),*/
      ];
    } else {
      marks = [
        IntervalMark(
          size: SizeEncode(value: 5),
          color: ColorEncode(value: theme.primary),
          selected: {
            'touchMove': {1},
          },
          selectionStream: _selection,
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
        'min': Variable(
          accessor: (MetricGrouped datumn) => datumn.min,
          scale: LinearScale(),
        ),
        'max': Variable(
          accessor: (MetricGrouped datumn) => datumn.max,
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
    var click = event?.entries.firstWhereOrNull((x) => x.key == 'click');
    if (click == null) return;

    var metric = filteredMetrics[click.value.first];
    _selectionChanged(metric);
  }

  List<MetricGrouped> _group(List<Metric> filter) {
    var buckets = max(50, min(500, (subDate.duration.inHours * 4).round()));
    // First create the buckets
    var bucketLength = subDate.duration.inMilliseconds / buckets;

    List<MetricGrouped> groups = [];
    var start = subDate.start;
    var end = subDate.start.add(Duration(milliseconds: bucketLength.toInt()));

    for (int i = 0; i < buckets; i++) {
      var items = filter
          .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
          .toList();

      var values = items.map((e) => double.parse(e.value)).toList();
      if (values.isNotEmpty) {
        double min = values.min;
        double max = values.max;
        if (min > max) {
          throw StateError("issue");
        }

        double mean = values.reduce((a, b) => a + b) / values.length;
        if (mean > max) {
          throw StateError("issue");
        }
        if (mean < min) {
          throw StateError("issue");
        }

        groups.add(
          MetricGrouped(
            start.add(Duration(milliseconds: (bucketLength / 2).toInt())),
            mean,
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
