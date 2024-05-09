import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

import '../../../helpers/date.dart';

class MetricDetailPage extends StatelessWidget {
  const MetricDetailPage({
    super.key,
    required this.metrics,
    required this.date,
    required this.type,
  });

  final DateTimeRange date;
  final List<Metric> metrics;
  final MetricType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${type.name}', style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0, top: 60.0),
        child: metrics.isEmpty
            ? Center(
                child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
              )
            : (type.type == MetricDataType.text
                ? ListView(
                    children: metrics
                        .map((metric) => Row(
                              children: [Text(metric.$value ?? ''), Text(MetricHelper.getMetricText(metric))],
                            ))
                        .toList(),
                  )
                : MetricGraph(metrics, date)),
      )),
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

  double _getInterval(DateTimeRange date) {
    var epoch = date.end.millisecondsSinceEpoch - date.start.millisecondsSinceEpoch;
    return epoch / (1000 * 60) * 2;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var width = _getInterval(date);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        //height: 50,
        width: width,
        child: LineChart(
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
                    interval: 1000 * 60 * 60 * 2,
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
                barWidth: 2,
                isStrokeCapRound: true,
                isCurved: true,
                curveSmoothness: 0.01,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<LineTooltipItem> _getToolTip(List<LineBarSpot> touchedSpots, BuildContext context) {
    List<LineTooltipItem> list = [];
    var theme = Theme.of(context).textTheme.labelSmall!;
    for (var touch in touchedSpots) {
      var metric = metrics[touch.spotIndex];
      var tag = '${metric.$value}:  ${MetricHelper.getMetricText(metric)}';

      list.add(LineTooltipItem(tag, theme));
    }
    return list;
  }
}
