import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class EventsSummary extends StatelessWidget {
  final List<EventSummary> events;
  final DateTimeRange date;

  const EventsSummary(this.events, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return (events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              Translation.of(context).nodata,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : EventTimeline(events, date));
  }
}

class EventTimeline extends StatelessWidget {
  final List<EventSummary> userData;
  final DateTimeRange date;

  const EventTimeline(this.userData, this.date, {super.key});

  List<Widget> buildChartBars(
    List<EventSummary> data,
    ColorScheme colorScheme, {
    required double width,
  }) {
    List<Widget> chartBars = [];

    int tick = 0;

    int max = userData.map((x) => x.data.values.map((y) => y as int).sum).max;
    var coeff = min(150 / max, 60.0);

    for (var d in data) {
      chartBars.add(
        Padding(
          padding: EdgeInsets.all(4.0 * width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _map(
              d.data,
              tick,
              colorScheme.primary,
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
    var maxWidth = (userData.length) * 28.0;

    return LayoutBuilder(
      builder: (b, constraints) {
        var widthCoeff = min(1.0, constraints.maxWidth / maxWidth);
        return SizedBox(
          height: 160,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: buildChartBars(
              userData,
              Theme.of(context).colorScheme,
              width: widthCoeff,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _map(
    Map<String, dynamic> p,
    int tick,
    Color empty, {
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
                color: Dependencies.theme.stateColor(entry.key),
              ),
              width: 20 * widthCoeff,
              height: coeff * count,
            ),
          ),
        );
      }
    }

    if (widgets.isEmpty) {
      widgets.add(
        SizedBox(
          width: 20 * widthCoeff,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: empty,
                borderRadius: BorderRadius.circular(12),
              ),
              width: 4,
              height: 4,
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
