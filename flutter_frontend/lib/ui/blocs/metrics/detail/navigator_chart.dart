import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_group.dart';

class NavigatorChart extends StatefulWidget {
  final List<MetricGrouped> metrics;
  final DateTimeRange date;
  final DateTimeRange subDate;
  final void Function(DateTimeRange<DateTime> value) setDate;
  final GraphKind graphKind;
  const NavigatorChart(
    this.metrics,
    this.date,
    this.subDate,
    this.setDate,
    this.graphKind, {
    super.key,
  });

  @override
  State<NavigatorChart> createState() => _NavigatorChartState();
}

class _NavigatorChartState extends State<NavigatorChart> {
  double _navigatorStart = 0.0;
  double _navigatorEnd = 1.0;
  Timer? _navigatorDebounce;

  void _scheduleNavigatorUpdate() {
    _navigatorDebounce?.cancel();

    _navigatorDebounce = Timer(
      const Duration(milliseconds: 150),
      _applyNavigatorRange,
    );
  }

  void _applyNavigatorRange() {
    _navigatorDebounce?.cancel();
    final total = widget.date.duration.inMilliseconds;

    final start = widget.date.start.add(
      Duration(milliseconds: (total * _navigatorStart).round()),
    );

    final end = widget.date.start.add(
      Duration(milliseconds: (total * _navigatorEnd).round()),
    );

    widget.setDate(DateTimeRange(start: start, end: end));
  }

  Widget _navigatorHandle(bool isLeft, double width) {
    var theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / width;

        setState(() {
          if (isLeft) {
            setState(() {
              _navigatorStart = (_navigatorStart + delta).clamp(
                0.0,
                _navigatorEnd - 0.05,
              );
            });
          } else {
            setState(() {
              _navigatorEnd = (_navigatorEnd + delta).clamp(
                _navigatorStart + 0.05,
                1.0,
              );
            });
          }
        });

        _scheduleNavigatorUpdate();
      },
      onHorizontalDragEnd: (_) {
        _applyNavigatorRange();
      },
      child: Container(
        width: 20,
        decoration: BoxDecoration(
          color: theme.secondary,
        ),
        child: Icon(Icons.drag_indicator, color: theme.onSecondary, size: 14),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _syncNavigator();
  }

  @override
  void didUpdateWidget(covariant NavigatorChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.subDate != widget.subDate || oldWidget.date != widget.date) {
      _syncNavigator();
    }
  }

  void _syncNavigator() {
    final total = widget.date.duration.inMilliseconds;

    if (total <= 0) return;

    _navigatorStart =
        widget.subDate.start.difference(widget.date.start).inMilliseconds /
        total;

    _navigatorEnd =
        widget.subDate.end.difference(widget.date.start).inMilliseconds / total;
  }

  @override
  void dispose() {
    _navigatorDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final left = width * _navigatorStart;
        final right = width * _navigatorEnd;

        return Stack(
          children: [
            SizedBox.expand(child: _navigatorGraph(theme)),
            Positioned(
              left: left,
              width: right - left,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final delta = details.delta.dx / width;

                  final range = _navigatorEnd - _navigatorStart;

                  setState(() {
                    _navigatorStart = (_navigatorStart + delta).clamp(
                      0.0,
                      1.0 - range,
                    );

                    _navigatorEnd = _navigatorStart + range;
                  });

                  _scheduleNavigatorUpdate();
                },

                onHorizontalDragEnd: (_) {
                  _applyNavigatorRange();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryContainer.withAlpha(150),
                    border: Border.all(color: theme.secondary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            Positioned(
              left: left,
              top: 0,
              bottom: 0,
              child: _navigatorHandle(true, width),
            ),

            Positioned(
              left: right - 20,
              top: 0,
              bottom: 0,
              child: _navigatorHandle(false, width),
            ),
          ],
        );
      },
    );
  }

  Widget _navigatorGraph(ColorScheme theme) {
    return LineChart(
      LineChartData(
        minX: widget.date.start.millisecondsSinceEpoch.toDouble(),
        maxX: widget.date.end.millisecondsSinceEpoch.toDouble(),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
          bottomTitles: AxisTitles(),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var metric in widget.metrics)
                FlSpot(
                  metric.date.millisecondsSinceEpoch.toDouble(),
                  metric.value,
                ),
            ],
            isCurved: true,
            curveSmoothness: 0.01,
            barWidth: 1,
            color: theme.primary,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
