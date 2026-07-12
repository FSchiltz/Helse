import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class Range<T> {
  final List<T> value = [];
  DateTime start;
  DateTime stop;

  final int index;

  Range({required this.start, required this.stop, required this.index});
}

class GraphRange {
  final List<Range<FlSpot>> spots = [];
}

class WidgetGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange range;
  final GraphKind settings;
  final MetricType type;
  final int tile;
  final double? width;

  const WidgetGraph(
    this.metrics,
    this.range,
    this.type,
    this.settings, {
    super.key,
    required this.tile,
    this.width,
  });

  List<Range<FlSpot>> _getSpot(List<Metric> raw, MetricType type) {
    int graphCount;
    switch (type.type) {
      case MetricDataType.numberrange:
        graphCount = type.valueCount ?? 0;
      default:
        graphCount = 1;
    }

    final Duration delta = Duration(
      milliseconds: (range.duration.inMilliseconds * 0.20).toInt(),
    );

    final groups = MetricHelper.group(raw, range, tile, type);
    final spots = List<GraphRange>.generate(graphCount, (i) => GraphRange());

    for (final item in groups.values) {
      var x = item.date.millisecondsSinceEpoch.toDouble();

      for (int i = 0; i < graphCount; i++) {
        var y = item.value?[i] ?? 0;

        if (settings == GraphKind.bar) {
          // graph bar are simpler, no need to split them so we put everything in the same range
          if (spots[i].spots.isEmpty) {
            spots[i].spots.add(
              Range<FlSpot>(start: item.date, stop: item.date, index: i),
            );
          }

          spots[i].spots[0].value.add(FlSpot(x, y));
        } else {
          // for line chart we split so that missing data are not extrapolated by the graph
          var existing = spots[i].spots.firstWhereOrNull(
            (e) =>
                (e.start.isBefore(item.date) ||
                    e.start.isAtSameMomentAs(item.date)) &&
                (e.stop.isAfter(item.date) ||
                    e.stop.isAtSameMomentAs(item.date)),
          );

          var start = item.date.subtract(delta);
          var end = item.date.add(delta);

          if (existing != null) {
            // if the group touch another adds it to it and increase the range
            existing.value.add(FlSpot(x, y));
            if (existing.start.isAfter(start)) {
              existing.start = start;
            }

            if (existing.stop.isBefore(end)) {
              existing.stop = end;
            }
          } else {
            // otherwise create a new range
            final range = Range<FlSpot>(start: start, stop: end, index: i);
            range.value.add(FlSpot(x, y));
            spots[i].spots.add(range);
          }
        }
      }
    }

    return spots.expand((e) => e.spots).toList();
  }

  List<BarChartGroupData> _getBar(
    List<Metric> raw,
    Color color,
    MetricType type,
  ) {
    var spots = _getSpot(raw, type);

    // now we have the min and max Y and X value, we can build the spots
    List<BarChartGroupData> bar = [];

    for (final item in spots[0].value) {
      bar.add(
        BarChartGroupData(
          x: item.x.toInt(),
          barRods: [
            BarChartRodData(toY: item.y, color: color, width: width ?? 2),
          ],
        ),
      );
    }

    return bar;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _getGraph(context),
    );
  }

  Widget _getGraph(BuildContext context) {
    if (settings == GraphKind.bar) {
      var color = Dependencies.theme.stateColor(
        MetricHelper.getStateKey(type, 0),
        StateType.metric,
        context,
      );
      return BarChart(
        BarChartData(
          barTouchData: BarTouchData(enabled: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: _getBar(metrics, color, type),
        ),
      );
    } else {
      final spots = _getSpot(metrics, type).map((metric) {
        var color = Dependencies.theme.stateColor(
          MetricHelper.getStateKey(type, metric.index),
          StateType.metric,
          context,
        );
        return LineChartBarData(
          barWidth: width ?? 3,
          color: color,
          spots: metric.value,
          isCurved: true,
          curveSmoothness: 0.02,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  color: color,
                  strokeColor: color,
                  radius: barData.spots.length > 1 ? 0 : 1,
                  strokeWidth: 0,
                ),
          ),
        );
      });

      return LineChart(
        LineChartData(
          minX: range.start.millisecondsSinceEpoch.toDouble(),
          maxX: range.end.millisecondsSinceEpoch.toDouble(),
          lineTouchData: const LineTouchData(enabled: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          lineBarsData: spots.toList(),
        ),
      );
    }
  }
}
