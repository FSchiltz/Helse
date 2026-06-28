import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/event_graph.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/ui_constants.dart';

class SessionChart extends StatelessWidget {
  const SessionChart({
    super.key,
    required this.sessions,
    required this.graphHeight,
    required this.radius,
    required this.stats,
    required this.type,
  });

  final EventType type;
  final List<Interval> sessions;
  final double graphHeight;
  final double radius;
  final GroupStats stats;

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    final sections = _getCharts(context);

    return CommonCard(
      child: Column(
        children: [
          const SizedBox(height: UIConstants.formPad),
          Wrap(
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: UIConstants.formPad,
            runSpacing: UIConstants.formPad,
            children: [
              SizedBox(
                height: graphHeight,
                width: graphHeight,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: radius,
                    sectionsSpace: 0,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sections.map((entry) {
                  final item = entry.value;

                  final percentage = item / stats.total * 100;
                  final duration = Duration(seconds: item.toInt());
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 12, color: entry.color),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.title} ${DateHelper.formatDuration(duration, locale)} (${percentage.toStringAsFixed(2)}%)',
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getCharts(BuildContext context) {
    List<PieChartSectionData> charts = [];
    double otherValue = 0;

    for (final entry in stats.counts.entries) {
      final percentage = entry.value / stats.total * 100;
      if (percentage < 5) {
        otherValue = otherValue + entry.value;
      } else {
        charts.add(
          PieChartSectionData(
            color: Dependencies.theme.stateColor(
              entry.key,
              StateType.eventValue,
              context,
            ),
            value: entry.value.toDouble(),
            title: entry.key,
            radius: radius,
            showTitle: false,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      }
    }

    if (otherValue > 0) {
      charts.add(
        PieChartSectionData(
          color: Dependencies.theme.stateColor(
            "other",
            StateType.eventValue,
            context,
          ),
          value: otherValue.toDouble(),
          title: "other",
          radius: radius,
          showTitle: false,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }

    return charts;
  }
}
