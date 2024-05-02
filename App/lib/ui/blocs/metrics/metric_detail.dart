import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widget.dart';
import 'package:helse/ui/blocs/app_bar/custom_app_bar.dart';

import '../common/date_range_input.dart';

class MetricDetailPage extends StatelessWidget {
  const MetricDetailPage({
    super.key,
    required this.widget,
    required this.metrics,
    required this.date,
  });

  final DateTimeRange date;
  final MetricWidget widget;
  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Detail of ${widget.type.name}',
            style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 8.0, top: 60.0),
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

  List<FlSpot> _getSpot(List<Metric> raw) {
    List<FlSpot> spots = [];

    for (var metric in raw) {
      final value = metric.$value;
      final metricDate = metric.date;
      if (metricDate == null || value == null) continue;

      spots.add(FlSpot(
          metricDate.millisecondsSinceEpoch as double, double.parse(value)));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return metrics.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child:
                Center(child: Text("No data", style: Theme.of(context).textTheme.labelLarge)),
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
