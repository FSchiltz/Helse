
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widget.dart';

class MetricDetailPage extends StatelessWidget {
  const MetricDetailPage({
    super.key,
    required this.widget,
    required this.metrics,
  });

  final MetricWidget widget;
  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${widget.type.name}',
            style: Theme.of(context).textTheme.displaySmall),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 80),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: MetricGraph(metrics, widget.date),
        ),
      ),
    );
  }
}

class MetricGraph extends StatelessWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  static const int valueCount = 24;

  const MetricGraph(this.metrics, this.date, {super.key});

  int _hourBetween(DateTime from, DateTime to) {
    return to.difference(from).inHours;
  }

  List<FlSpot> _getSpot(List<Metric> raw) {
    List<FlSpot> spots = [];

    for (var metric in raw) {
      final value = metric.$value;
      final metricDate = metric.date;
      if (metricDate == null || value == null) continue;

      spots.add(FlSpot(metricDate.millisecondsSinceEpoch as double, double.parse(value)));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return metrics.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child:
                Text("No data", style: Theme.of(context).textTheme.labelLarge),
          )
        : LineChart(
            LineChartData(
              minX: date.start.millisecondsSinceEpoch as double,
              maxX: date.end.millisecondsSinceEpoch as double,
              minY: 0,
              lineTouchData: const LineTouchData(enabled: true),
              titlesData: const FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
              ),
              gridData: const FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpot(metrics),
                  color: Colors.greenAccent,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          );
  }
}
