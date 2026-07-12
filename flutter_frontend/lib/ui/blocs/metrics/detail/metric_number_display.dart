import 'dart:async';
import 'dart:math';
import 'dart:developer' as logger;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_details.dart';
import 'package:helse/ui/blocs/metrics/detail/stats_widgets/metric_statistics_card.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../helpers/date_helper.dart';

class MetricNumberDisplay extends MetricDetails {
  static const int valueCount = 24;

  const MetricNumberDisplay(
    super.metrics,
    super.date,
    super.settings,
    super.reset, {
    super.key,
    super.person,
    required super.type,
  });

  @override
  State<MetricNumberDisplay> createState() => _MetricGraphState();
}

class _MetricGraphState extends MetricDetailsState<MetricNumberDisplay> {
  final StreamController<Map<String, Set<int>>?> _selection =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _selection.stream.listen(_onData);
  }

  @override
  Widget build(BuildContext context) {
    final metric = selected;
    return Column(
      spacing: UIConstants.formPad,
      children: [
        ...buildHeader(),
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
          return datumn.value?[index] ?? 0;
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
    selectionChanged(metric);
  }
}
