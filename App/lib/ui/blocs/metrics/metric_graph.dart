import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

class MetricGraph extends StatefulWidget {
  final List<Metric> metrics;
  final DateTimeRange date;
  final GraphKind settings;
  static const int valueCount = 24;

  const MetricGraph(this.metrics, this.date, this.settings, {super.key});

  @override
  State<MetricGraph> createState() => _MetricGraphState();
}

class _MetricGraphState extends State<MetricGraph> {
  final ScrollController _scrollController = ScrollController();
  List<FlSpot> _spots = [];
  double _width = 0;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _spots = _getSpot(widget.metrics);
    _width = _getInterval(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            width: _width,
            child: _getGraph(context),
          ),
        ),
      ),
    );
  }

  Widget _getGraph(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    if (widget.settings == GraphKind.line) {
      return LineChart(
        duration: Duration.zero,
        LineChartData(
          minX: widget.date.start.millisecondsSinceEpoch.toDouble(),
          maxX: widget.date.end.millisecondsSinceEpoch.toDouble(),
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
              spots: _spots,
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
      );
    } else {
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (x, y, z, w) => _getBarToolTip(w, context),
            ),
          ),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                drawBelowEverything: true,
                sideTitles: SideTitles(
                  showTitles: false,
                )),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          barGroups: _spots
              .map((spot) => BarChartGroupData(x: spot.x.toInt(), barsSpace: 1, barRods: [
                    BarChartRodData(
                      toY: spot.y,
                      width: 20,
                    )
                  ]))
              .toList(),
        ),
      );
    }
  }

  List<LineTooltipItem> _getToolTip(List<LineBarSpot> touchedSpots, BuildContext context) {
    List<LineTooltipItem> list = [];
    var theme = Theme.of(context).textTheme.labelSmall!;
    for (var touch in touchedSpots) {
      var metric = widget.metrics[touch.spotIndex];
      var tag = '${metric.$value}:  ${MetricHelper.getMetricText(metric)}';

      list.add(LineTooltipItem(tag, theme));
    }
    return list;
  }

  BarTooltipItem _getBarToolTip(int index, BuildContext context) {
    var theme = Theme.of(context).textTheme.labelSmall!;
    var metric = widget.metrics[index];
    var tag = '${metric.$value}:  ${MetricHelper.getMetricText(metric)}';

    return BarTooltipItem(tag, theme);
  }
}
