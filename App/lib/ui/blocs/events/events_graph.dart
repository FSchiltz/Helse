import 'dart:math';

import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';

class EventGraph extends StatelessWidget {
  final List<Event> events;
  final DateTimeRange date;

  const EventGraph(this.events, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return (events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
          )
        : LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => buildChart(events, constraints.maxWidth)));
  }

  Widget buildChart(List<Event> userData, double chartViewWidth) {
    var chartBars = buildChartBars(userData, chartViewWidth);
    return SizedBox(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: chartBars,
                        ),
                      ],
                    ),
                  ],
                )),
          ]),
        ],
      ),
    );
  }

  List<Widget> buildChartBars(List<Event> data, double chartViewWidth) {
    List<Widget> chartBars = [];
    Map<String, Color> colors = {};

    var viewRange = _secondsBetween(date.start, date.end);
    var chartFactor = chartViewWidth / viewRange;

    for (var n in data) {
      // if the event has no start or end, we clamp to the filtered value
      var start = n.start ?? date.start;
      var end = n.stop ?? date.end;

      var remainingWidth = _distanceInSeconds(start, end);
      var color = _stateColor(colors, n.description);
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(color: color.withAlpha(100), borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartFactor,
          margin: EdgeInsets.only(left: _distanceToLeftBorder(start) * chartFactor, top: 2.0, bottom: 2.0),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              n.description ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
        ));
      }
    }

    return chartBars;
  }

  Widget buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = [];

    var viewRange = _secondsBetween(date.start, date.end) / (60 * 60);

    for (int i = 0; i <= viewRange; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withAlpha(75), width: 0.5))),
        width: chartViewWidth / viewRange,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  Color _stateColor(Map<String, Color> colors, String? state) {
    if (state == null) return Colors.white;

    if (colors.containsKey(state)) {
      return colors[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 0.75);
      colors[state] = color;
      return color;
    }
  }

  int _secondsBetween(DateTime from, DateTime to) {
    return to.difference(from).inSeconds;
  }

  int _distanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(date.start) <= 0) {
      return 0;
    } else {
      return _secondsBetween(date.start, projectStartedAt) - 1;
    }
  }

  int _distanceInSeconds(DateTime start, DateTime end) {
    var seconds = _secondsBetween(start, end);
    var viewRange = _secondsBetween(date.start, date.end);

    if (start.compareTo(date.start) >= 0 && start.compareTo(date.end) <= 0) {
      // The date is between the bond
      if (seconds <= viewRange) {
        return seconds;
      } else {
        return viewRange - _secondsBetween(date.start, start);
      }
    } else if (start.isBefore(date.start) && end.isBefore(date.start)) {
      return 0;
    } else if (start.isBefore(date.start) && end.isBefore(date.end)) {
      return seconds - _secondsBetween(start, date.start);
    } else if (start.isBefore(date.start) && end.isAfter(date.end)) {
      return viewRange;
    }
    return 0;
  }
}
