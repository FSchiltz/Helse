import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_group.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';

class NavigatorChart extends StatefulWidget {
  final List<MetricGrouped> metrics;
  final DateTimeRange date;
  final DateTimeRange subDate;
  final void Function(DateTimeRange<DateTime> value) setDate;
  final GraphKind graphKind;
  final MetricType type;
  const NavigatorChart(
    this.metrics,
    this.date,
    this.subDate,
    this.setDate,
    this.type,
    this.graphKind, {
    super.key,
  });

  @override
  State<NavigatorChart> createState() => _NavigatorChartState();
}

class _NavigatorChartState extends State<NavigatorChart> {
  double _navigatorStart = 0.0;
  double _navigatorEnd = 1.0;

  void _applyNavigatorRange() {
    var navigatorStart = _navigatorStart;
    var navigatorEnd = _navigatorEnd;
    final total = widget.date.duration.inMilliseconds;

    final start = widget.date.start.add(
      Duration(milliseconds: (total * navigatorStart).round()),
    );

    final end = widget.date.start.add(
      Duration(milliseconds: (total * navigatorEnd).round()),
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
              _navigatorStart += delta;
            });
          } else {
            setState(() {
              _navigatorEnd += delta;
            });
          }
        });
      },
      onHorizontalDragEnd: (_) {
        _applyNavigatorRange();
      },
      child: Container(
        width: 10,
        decoration: BoxDecoration(color: theme.secondary),
        child: Icon(Icons.drag_indicator, color: theme.onSecondary, size: 10),
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

    if (total <= 0) {
      return;
    }

    _navigatorStart =
        widget.subDate.start.difference(widget.date.start).inMilliseconds /
        total;

    _navigatorEnd =
        widget.subDate.end.difference(widget.date.start).inMilliseconds / total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final left = width * _navigatorStart;
        final right = width * _navigatorEnd;

        debugPrint('created navigator for ${widget.date}');
        return Column(
          children: [
            SizedBox(
              height: 60,
              child: Stack(
                children: [
                  WidgetGraph(
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
                    widget.graphKind,
                    tile: widget.metrics.length,
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
                    left: right - 10,
                    top: 0,
                    bottom: 0,
                    child: _navigatorHandle(false, width),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
