import 'dart:math';
import 'package:flutter/material.dart';

import '../../../helpers/date.dart';
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
        : buildChart(events, context));
  }

  Widget buildChart(List<Event> userData, BuildContext context) {
    var chartBars = buildChartBars(userData);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: chartBars.length * 29.0 + 25.0 + 4.0,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          buildGrid(),
          buildDayHeader(),
          Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: buildHeader(),
          ),
          Container(
              margin: const EdgeInsets.only(top: 50.0),
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
      ),
    );
  }

  Widget buildDayHeader() {
    List<Widget> headerItems = [];

    DateTime tempDate = date.start;

    var viewRange = _minutesBetween(date.start, date.end) / (60 * 24);

    for (int i = 0; i < viewRange; i++) {
      headerItems.add(SizedBox(
        width: 60 * 24,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            ' ${tempDate.day.toString().padLeft(2, '0')}/${tempDate.month.toString().padLeft(2, '0')}/${tempDate.year.toString().padLeft(4, '0')}',
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ));
      tempDate = tempDate.add(const Duration(days: 1));
    }

    return SizedBox(
      height: 25.0,
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget buildHeader() {
    List<Widget> headerItems = [];

    DateTime tempDate = date.start;

    var viewRange = _minutesBetween(date.start, date.end) / (60);

    for (int i = 0; i < viewRange; i++) {
      headerItems.add(SizedBox(
        width: 60,
        child: Tooltip(
          message: DateHelper.format(tempDate),
          child: Text(
            '${tempDate.hour.toString().padLeft(2, '0')}:${tempDate.second.toString().padLeft(2, '0')}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
      ));
      tempDate = tempDate.add(const Duration(hours: 1));
    }

    return SizedBox(
      height: 25.0,
      child: Row(
        children: headerItems,
      ),
    );
  }

  List<Widget> buildChartBars(List<Event> data) {
    List<Widget> chartBars = [];
    Map<String, Color> colors = {};
    Map<String?, List<Event>> orderedData = {};

    for (var n in data) {
      var list = orderedData[n.description];
      if (list == null) {
        list = [];
        list.add(n);
        orderedData[n.description] = list;
      } else {
        list.add(n);
      }
    }

    for (var group in orderedData.entries) {
      List<Widget> chartGroup = [];
      for (var n in group.value) {
        // if the event has no start or end, we clamp to the filtered value
        var start = n.start ?? date.start;
        var end = n.stop ?? date.end;

        var remainingWidth = _distanceInMinutes(start, end);
        var color = _stateColor(colors, n.description);
        if (remainingWidth > 0) {
          chartGroup.add(Container(
            decoration: BoxDecoration(color: color.withAlpha(100)),
            height: 25.0,
            width: remainingWidth.toDouble(),
            margin: EdgeInsets.only(left: _distanceToLeftBorder(start).toDouble(), top: 2.0, bottom: 2.0),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Tooltip(
                message: n.description ?? "",
                child: Text(
                  n.description ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          ));
        }
      }
      chartBars.add(Stack(
        fit: StackFit.loose,
        children: chartGroup,
      ));
    }

    return chartBars;
  }

  Widget buildGrid() {
    List<Widget> gridColumns = [];

    var viewRange = _minutesBetween(date.start, date.end) / (60);

    for (int i = 0; i <= viewRange; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withAlpha(75), width: 0.5))),
        width: 60,
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

  int _minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  int _distanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(date.start) <= 0) {
      return 0;
    } else {
      return _minutesBetween(date.start, projectStartedAt) - 1;
    }
  }

  int _distanceInMinutes(DateTime start, DateTime end) {
    var seconds = _minutesBetween(start, end);
    var viewRange = _minutesBetween(date.start, date.end);

    if (start.compareTo(date.start) >= 0 && start.compareTo(date.end) <= 0) {
      // The date is between the bond
      if (seconds <= viewRange) {
        return seconds;
      } else {
        return viewRange - _minutesBetween(date.start, start);
      }
    } else if (start.isBefore(date.start) && end.isBefore(date.start)) {
      return 0;
    } else if (start.isBefore(date.start) && end.isBefore(date.end)) {
      return seconds - _minutesBetween(start, date.start);
    } else if (start.isBefore(date.start) && end.isAfter(date.end)) {
      return viewRange;
    }
    return 0;
  }
}
