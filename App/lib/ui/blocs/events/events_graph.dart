import 'dart:math';
import 'package:flutter/material.dart';

import '../../../helpers/date.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';

class EventGraph extends StatelessWidget {
  final List<Event> events;
  final DateTimeRange date;
  final ScrollController _scrollController = ScrollController();

  EventGraph(this.events, this.date, {super.key});

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
    return Scrollbar(
      interactive: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          buildGrid(),
          buildDayHeader(),
          Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: buildHeader(context),
          ),
          Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      EventTimeline(userData, date),
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

  Widget buildHeader(BuildContext context) {
    List<Widget> headerItems = [];

    DateTime tempDate = date.start;

    var viewRange = _minutesBetween(date.start, date.end) / (60);

    for (int i = 0; i < viewRange; i++) {
      headerItems.add(SizedBox(
        width: 60,
        child: Tooltip(
          message: DateHelper.format(tempDate, context: context),
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

  int _minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }
}

class EventTimeline extends StatefulWidget {
  final List<Event> userData;
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
  List<Widget> _chartBars = [];

  Color _stateColor(String state) {
    if (colors.containsKey(state)) {
      return colors[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(r.nextInt(106) + 50, r.nextInt(106) + 50, r.nextInt(106) + 50, 0.75);
      colors[state] = color;
      return color;
    }
  }

  int _minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  int _distanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(widget.date.start) <= 0) {
      return 0;
    } else {
      return _minutesBetween(widget.date.start, projectStartedAt) - 1;
    }
  }

  int _distanceInMinutes(DateTime start, DateTime end) {
    if (start.compareTo(widget.date.start) < 0) {
      start = widget.date.start;
    }

    if (end.compareTo(widget.date.end) > 0) {
      end = widget.date.end;
    }

    return max(6, _minutesBetween(start, end));
  }

  List<Widget> buildChartBars(List<Event> data) {
    List<Widget> chartBars = [];
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
        var start = n.start?.toLocal() ?? widget.date.start;
        var end = n.stop?.toLocal() ?? widget.date.end;

        var width = _distanceInMinutes(start, end);
        var color = _stateColor(n.description ?? '');
        if (width > 0) {
          chartGroup.add(Container(
            margin: EdgeInsets.only(left: _distanceToLeftBorder(start).toDouble(), top: 2.0, bottom: 2.0),
            alignment: Alignment.centerLeft,
            child: Tooltip(
              message: "${n.description ?? ""}: ${n.start?.toLocal()} => ${n.stop?.toLocal()}",
              child: Container(
                width: width.toDouble(),
                decoration: BoxDecoration(
                  color: color.withAlpha(100),
                  // TODO make round only when inside the date range
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                height: 25.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    n.description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 10.0),
                  ),
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

  @override
  void initState() {
    super.initState();
    _chartBars = buildChartBars(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _chartBars,
    );
  }
}
