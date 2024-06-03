import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';

class EventsSummary extends StatelessWidget {
  final List<EventSummary> events;
  final DateTimeRange date;
  final ScrollController _scrollController = ScrollController();

  EventsSummary(this.events, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return (events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
          )
        : buildChart(events, context));
  }

  Widget buildChart(List<EventSummary> userData, BuildContext context) {
    return Scrollbar(
      interactive: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  EventTimeline(userData, date),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class EventTimeline extends StatefulWidget {
  final List<EventSummary> userData;
  final DateTimeRange date;

  const EventTimeline(
    this.userData,
    this.date, {
    super.key,
  });

  @override
  State<EventTimeline> createState() => _EventTimelineState();
}

class _EventTimelineState extends State<EventTimeline> {
  final Map<String, Color> colors = {};

  Color _stateColor(String state) {
    if (colors.containsKey(state)) {
      return colors[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(r.nextInt(55) + 100, r.nextInt(105) + 150, r.nextInt(105) + 100, 1);
      colors[state] = color;
      return color;
    }
  }

  List<Widget> buildChartBars(List<EventSummary> data, ColorScheme colorScheme) {
    List<Widget> chartBars = [];

    int tick = 0;
    for (var d in data) {
      var p = d.data;
      if (p != null) {
        chartBars.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: map(p, tick, colorScheme.primary),
            ),
          ),
        ));
      }

      tick++;
    }

    return chartBars;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: buildChartBars(widget.userData, Theme.of(context).colorScheme),
    );
  }

  List<Widget> map(Map<String, dynamic> p, int tick, Color empty) {
    List<Widget> widgets = [];

    for (var entry in p.entries) {
      var count = entry.value as int?;
      if (count != null && count > 0) {
        widgets.add(Tooltip(
          message: entry.key,
          child: Container(
            decoration: BoxDecoration(
              color: _stateColor(entry.key),
            ),
            width: 20,
            height: 30 * count as double,
          ),
        ));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(Container(
        color: empty,
        width: 28,
        height: 1,
      ));
    }

    return widgets;
  }
}
