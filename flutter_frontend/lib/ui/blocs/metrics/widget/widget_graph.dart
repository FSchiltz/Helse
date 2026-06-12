import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';

class Range<T> {
  final List<T> value = [];
  DateTime start;
  DateTime stop;

  Range({required this.start, required this.stop});
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

  List<Range<FlSpot>> _getSpot(List<Metric> raw) {
    final bucketLength = range.duration.inMilliseconds / tile;

    final Duration delta = Duration(
      milliseconds: (bucketLength * (tile * 0.05)).toInt(),
    );

    final groups = List<MetricGrouped>.generate(tile, (index) {
      final start = range.start.add(
        Duration(milliseconds: (index * bucketLength).toInt()),
      );
      var date = start.add(Duration(milliseconds: (bucketLength / 2).toInt()));
      return MetricGrouped(date, 0, []);
    });

    for (var metric in raw) {
      final value = double.parse(metric.value);
      // find the bucket
      final duration = metric.date.difference(range.start);
      final index = (duration.inMilliseconds / bucketLength).toInt();
      final bucket = groups[index];
      // if it does not exists create it
      bucket.value = (bucket.value + value) / 2;
    }

    List<Range<FlSpot>> spots = [];
    for (final item in groups) {
      var y = item.value;
      var x = item.date.millisecondsSinceEpoch.toDouble();

      if (settings == GraphKind.bar) {
        // graph bar are simpler, no need to split them so we put everything in the same range
        if (spots.isEmpty) {
          spots.add(Range<FlSpot>(start: item.date, stop: item.date));
        }

        spots[0].value.add(FlSpot(x, y));
      } else {
        if (y == 0) {
          // don't show 0 values in the graph
          continue;
        }

        // for line chart we split so that missing data are not extrapolated by the graph
        var existing = spots.firstWhereOrNull(
          (e) =>
              (e.start.isBefore(item.date) ||
                  e.start.isAtSameMomentAs(item.date)) &&
              (e.stop.isAfter(item.date) || e.stop.isAtSameMomentAs(item.date)),
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
          final range = Range<FlSpot>(start: start, stop: end);
          range.value.add(FlSpot(x, y));
          spots.add(range);
        }
      }
    }

    return spots;
  }

  List<BarChartGroupData> _getBar(List<Metric> raw, Color color) {
    var spots = _getSpot(raw);

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
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metrics,
      context,
    );
    if (settings == GraphKind.bar) {
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
          barGroups: _getBar(metrics, color),
        ),
      );
    } else {
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
          lineBarsData: _getSpot(metrics)
              .map(
                (m) => LineChartBarData(
                  barWidth: width ?? 3,
                  color: color,
                  spots: m.value,
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
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
