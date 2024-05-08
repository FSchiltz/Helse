import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widget.dart';
import 'package:intl/intl.dart';

import '../../../helpers/date.dart';

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
      appBar: AppBar(
        title: Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0, top: 60.0),
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

      spots.add(FlSpot(metricDate.millisecondsSinceEpoch.toDouble(), double.parse(value)));
    }

    return spots;
  }

  double _getInterval(DateTimeRange date, BoxConstraints constraints) {
    var epoch = date.end.millisecondsSinceEpoch - date.start.millisecondsSinceEpoch;
    return epoch / (constraints.maxWidth / 200);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return metrics.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Center(child: Text("No data", style: Theme.of(context).textTheme.labelLarge)),
          )
        : LayoutBuilder(
            builder: (x, constraints) => LineChart(
              LineChartData(
                minX: date.start.millisecondsSinceEpoch.toDouble(),
                maxX: date.end.millisecondsSinceEpoch.toDouble(),
                minY: 0,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => _getToolTip(touchedSpots, context),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: _getInterval(date, constraints),
                        getTitlesWidget: (value, meta) {
                          var time = DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  DateHelper.formatDate(time, context: context),
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  DateHelper.formatTime(time, context: context),
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSpot(metrics),
                    color: theme.primary,
                    barWidth: 0,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
  }

  List<LineTooltipItem> _getToolTip(List<LineBarSpot> touchedSpots, BuildContext context) {
    List<LineTooltipItem> list = [];
    var theme = Theme.of(context).textTheme.labelSmall!;
    for (var touch in touchedSpots) {
      var metric = metrics[touch.spotIndex];
      var tag = metric.$value ?? '';

      if (metric.tag != null) tag += ' (${metric.tag})';
      list.add(LineTooltipItem(tag, theme));
    }
    return list;
  }
}
