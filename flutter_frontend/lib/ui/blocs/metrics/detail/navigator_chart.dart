import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:helse/ui/blocs/metrics/metric_group.dart';

class NavigatorChart extends StatefulWidget {
  final List<MetricGrouped> metrics;
  final DateTimeRange date;
  final void Function(DateTimeRange<DateTime> value) setDate;
  const NavigatorChart(this.metrics, this.date, this.setDate, {super.key});

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
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.drag_indicator, color: Colors.white, size: 14),
      ),
    );
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
            Chart(
              data: widget.metrics,
              variables: {
                'date': Variable(accessor: (MetricGrouped d) => d.date),
                'value': Variable(accessor: (MetricGrouped d) => d.value),
              },
              marks: [
                AreaMark(
                  position: Varset('date') * Varset('value'),
                  shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
                  color: ColorEncode(value: theme.primary.withOpacity(.15)),
                ),
                LineMark(
                  position: Varset('date') * Varset('value'),
                  size: SizeEncode(value: 2),
                  color: ColorEncode(value: theme.primary),
                ),
              ],
              axes: [],
            ),

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
                    color: theme.primary.withOpacity(.12),
                    border: Border.all(color: theme.primary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            Positioned(
              left: left - 10,
              top: 0,
              bottom: 0,
              child: _navigatorHandle(true, width),
            ),

            Positioned(
              left: right - 10,
              top: 0,
              bottom: 0,
              child: _navigatorHandle(false, width),
            ),
          ],
        );
      },
    );
  }
}
