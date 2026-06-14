import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/theme_helper.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class EventsSummary extends StatelessWidget {
  final List<EventSummary> events;
  final DateTimeRange date;

  const EventsSummary(this.events, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return (events.isEmpty
        ? Text(
            Translation.of(context).nodata,
            style: Theme.of(context).textTheme.labelLarge,
          )
        : EventTimeline(events, date));
  }
}

class EventTimeline extends StatelessWidget {
  final List<EventSummary> userData;
  final DateTimeRange date;

  const EventTimeline(this.userData, this.date, {super.key});

  List<Widget> _buildChartBars(
    List<EventSummary> events,
    BuildContext context, {
    required double width,
    required double height,
  }) {
    var theme = Theme.of(context).colorScheme;
    List<Widget> chartBars = [];

    int tick = 0;
    int max = userData.map((x) => x.data.values.map((y) => y as int).sum).max;
    var coeff =
        (height / max) *
        0.95; // remove 5% of the height to fix some overflow on the graph

    for (var d in events) {
      chartBars.add(
        Padding(
          padding: EdgeInsets.all(1.0 * width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _map(
              d.data,
              tick,
              theme.primary,
              context,
              coeff: coeff,
              widthCoeff: width,
            ),
          ),
        ),
      );

      tick++;
    }

    return chartBars;
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = (userData.length) * 14.0;

    return LayoutBuilder(
      builder: (b, constraints) {
        var widthCoeff = constraints.maxWidth / maxWidth;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _buildChartBars(
            userData,
            context,
            width: widthCoeff,
            height: constraints.maxHeight,
          ),
        );
      },
    );
  }

  List<Widget> _map(
    Map<String, dynamic> p,
    int tick,
    Color empty,
    BuildContext context, {
    required double coeff,
    required double widthCoeff,
  }) {
    List<Widget> widgets = [];

    for (var entry in p.entries) {
      var count = entry.value as int?;
      if (count != null && count > 0) {
        widgets.add(
          Tooltip(
            message: entry.key,
            child: Container(
              decoration: BoxDecoration(
                color: Dependencies.theme.stateColor(
                  entry.key,
                  StateType.eventValue,
                  context,
                ),
              ),
              width: 12 * widthCoeff,
              height: (coeff * count).ceilToDouble(),
            ),
          ),
        );
      }
    }

    if (widgets.isEmpty) {
      widgets.add(SizedBox(width: 12 * widthCoeff));
    }

    return widgets;
  }
}
