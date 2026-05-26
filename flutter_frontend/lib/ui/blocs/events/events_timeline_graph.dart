import 'dart:math';
import 'package:flutter/material.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class EventsTimelineGraph extends StatelessWidget {
  final int skippedWidth = 130;
  final List<Event> events;
  final DateTimeRange date;
  final ScrollController _scrollController = ScrollController();
  final void Function(Event event) selectionChanged;

  EventsTimelineGraph(
    this.events,
    this.date,
    this.selectionChanged, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "No data",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : buildChart(events, context));
  }

  Widget buildChart(List<Event> events, BuildContext context) {
    var viewRange = _minutesBetween(date.start, date.end) / (60);

    List<Widget> headerItems = [];
    List<Widget> headerDayItems = [];
    List<Widget> gridColumns = [];
    DateTime tempDate = date.start;
    DateTime tempDay = date.start;
    bool skipping = false;
    List<DateTimeRange> skipped = [];
    DateTime startSkipping = date.start;

    for (int i = 0; i <= viewRange; i++) {
      var currentDate = tempDate;
      tempDate = tempDate.add(const Duration(hours: 1));
      var existing = events
          .where((x) => x.start.isBefore(tempDate) && x.stop.isAfter(currentDate))
          .toList();

      if (existing.isNotEmpty) {
        if (i % 24 == 0) {
          headerDayItems.add(buildDayHeader(tempDay));
        }
        headerItems.add(buildHeader(context, currentDate));
        gridColumns.add(buildGrid());

        if (skipping) {
          skipping = false;
          skipped.add(DateTimeRange(start: startSkipping, end: currentDate));
        }
      } else {
        if (!skipping) {
          headerItems.add(_skipWidget());
          gridColumns.add(_skipWidget());
          headerDayItems.add(_skipWidget());

          skipping = true;
          startSkipping = tempDate;
        }
      }

      if (i % 24 == 0) {
        tempDay = tempDay.add(const Duration(days: 1));
      }
    }

    if (skipping) {
      skipping = false;
      skipped.add(DateTimeRange(start: startSkipping, end: tempDate));
    }

    var chartBars = buildChartBars(events, skipped);

    return Scrollbar(
      interactive: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Row(children: gridColumns),
              SizedBox(height: 25.0, child: Row(children: headerDayItems)),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: SizedBox(
                  height: 25.0,
                  child: Row(children: headerItems),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: chartBars,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDayHeader(DateTime tempDate) {
    return SizedBox(
      width: 60 * 24,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          ' ${tempDate.day.toString().padLeft(2, '0')}/${tempDate.month.toString().padLeft(2, '0')}/${tempDate.year.toString().padLeft(4, '0')}',
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, DateTime utc) {
    var tempDate = utc.toLocal();
    return Container(
      alignment: Alignment.centerLeft,
      width: 60,
      child: Tooltip(
        message: '$tempDate',
        textAlign: TextAlign.left,
        child: Text(
          '${tempDate.hour.toString().padLeft(2, '0')}:${tempDate.minute.toString().padLeft(2, '0')}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  Widget buildGrid() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white.withAlpha(75), width: 0.5),
        ),
      ),
      width: 60,
      height: 200,
    );
  }

  int _minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  final Map<String, Color> colors = {};

  Color _stateColor(String state) {
    if (colors.containsKey(state)) {
      return colors[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(
        r.nextInt(106) + 50,
        r.nextInt(106) + 50,
        r.nextInt(106) + 50,
        0.75,
      );
      colors[state] = color;
      return color;
    }
  }

  int _distanceToLeftBorder(
    DateTime projectStartedAt,
    List<DateTimeRange<DateTime>> skipped,
  ) {
    if (projectStartedAt.compareTo(date.start) <= 0) {
      return 0;
    } else {
      var skipping = skipped
          .where(
            (x) =>
                x.end.isBefore(projectStartedAt) ||
                x.end.isAtSameMomentAs(projectStartedAt),
          )
          .fold(0, (a, b) => a + b.duration.inMinutes - skippedWidth + 60);

      var fullDistance = _minutesBetween(date.start, projectStartedAt);

      return fullDistance - 1 - skipping;
    }
  }

  int _distanceInMinutes(DateTime start, DateTime end) {
    if (start.compareTo(date.start) < 0) {
      start = date.start;
    }

    if (end.compareTo(date.end) > 0) {
      end = date.end;
    }

    return max(6, _minutesBetween(start, end));
  }

  List<Widget> buildChartBars(
    List<Event> events,
    List<DateTimeRange<DateTime>> skipped,
  ) {
    Map<String?, List<Event>> orderedData = {};

    for (var n in events) {
      var list = orderedData[n.description];
      if (list == null) {
        list = [];
        list.add(n);
        orderedData[n.description] = list;
      } else {
        list.add(n);
      }
    }

    List<Widget> chartBars = [];

    for (var group in orderedData.entries) {
      List<Widget> chartGroup = [];
      for (var n in group.value) {
        // if the event has no start or end, we clamp to the filtered value
        var start = n.start.toLocal();
        var end = n.stop.toLocal();

        var width = _distanceInMinutes(start, end);
        var color = _stateColor(n.description ?? '');
        if (width > 0) {
          chartGroup.add(
            Container(
              margin: EdgeInsets.only(
                left: _distanceToLeftBorder(start, skipped).toDouble(),
                top: 2.0,
                bottom: 2.0,
              ),
              alignment: Alignment.centerLeft,
              child: Tooltip(
                message:
                    "${n.description ?? ""}: ${n.start.toLocal()} => ${n.stop.toLocal()}",
                child: InkWell(
                  onTap: () => selectionChanged(n),
                  child: Container(
                    width: width.toDouble(),
                    decoration: BoxDecoration(
                      color: color.withAlpha(100),
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
              ),
            ),
          );
        }
      }
      chartBars.add(Stack(fit: StackFit.loose, children: chartGroup));
    }

    return chartBars;
  }

  Widget _skipWidget() {
    return Container(
      width: skippedWidth.toDouble(),
      color: Colors.red,
      child: Text('K'),
    );
  }
}
