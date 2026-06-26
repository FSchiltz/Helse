import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/ui_constants.dart';

class SessionsRange extends StatelessWidget {
  final Color color;
  final double height;
  final List<Interval> sessions;
  const SessionsRange({
    super.key,
    required this.color,
    required this.height,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(child: _getRangeGraph(sessions, height));
  }

  List<BarChartGroupData>? _map(
    List<Interval> sessions,
    double width,
    Color color,
  ) {
    final List<BarChartGroupData> bars = [];
    for (int i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      final start = Duration(
        hours: session.start.hour,
        minutes: session.start.minute,
      );
      final stop = Duration(
        hours: session.stop.hour,
        minutes: session.stop.minute,
      );
      bars.add(
        BarChartGroupData(
          x: i,
          barsSpace: width + 2,
          barRods: [
            BarChartRodData(
              fromY: start.inMinutes.toDouble(),
              toY: stop.inMinutes.toDouble(),
              width: width,
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
          ],
        ),
      );
    }
    return bars;
  }

  Widget _getRangeGraph(List<Interval> sessions, double height) {
    if (sessions.isEmpty) {
      return Text("No data");
    }
    final minDate = sessions
        .map((e) => e.start)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = min(4, constraints.maxWidth / sessions.length);

        return SizedBox(
          height: height,
          width: (itemWidth + 2) * sessions.length,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipPadding: const EdgeInsets.all(UIConstants.formPad),
                  getTooltipItem:
                      (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        final event = sessions[groupIndex];

                        final duration = event.stop.difference(event.start);
                        return BarTooltipItem(
                          'Start: ${DateHelper.formatTime(event.start, context: context)}\n'
                          'End: ${DateHelper.formatTime(event.stop, context: context)}\n'
                          '${DateHelper.formatDuration(duration, Translation.of(context))}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                ),
              ),

              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              minY: 0,
              maxY: 24 * 60,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 80,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime(
                        0,
                      ).add(Duration(minutes: value.toInt()));

                      return Text(
                        DateHelper.formatTime(date, context: context),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (value, meta) {
                      final date = minDate.add(
                        Duration(minutes: value.toInt()),
                      );

                      return Text(
                        '${date.day}/${date.month}',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
              ),
              barGroups: _map(sessions, itemWidth, color),
            ),
          ),
        );
      },
    );
  }
}
