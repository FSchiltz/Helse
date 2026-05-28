import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class EventsTimelineGraph extends StatefulWidget {
  final List<Event> events;
  final DateTimeRange date;
  final void Function(Event event) selectionChanged;

  const EventsTimelineGraph(
    this.events,
    this.date,
    this.selectionChanged, {
    super.key,
  });

  @override
  State<EventsTimelineGraph> createState() => _EventsTimelineGraphState();
}

class _EventsTimelineGraphState extends State<EventsTimelineGraph> {
  static const int skippedWidth = 32;
  static const int widthCoef = 2;
  final double boxWidth = 60.0 * widthCoef;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return (widget.events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "No data",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : buildChart(widget.events, context));
  }

  Widget buildChart(List<Event> events, BuildContext context) {
    var viewRange = _minutesBetween(widget.date.start, widget.date.end) / (60);

    List<Widget> headerItems = [];
    List<Widget> headerDayItems = [];
    List<Widget> gridColumns = [];
    DateTime tempDate = widget.date.start;
    bool skipping = false;
    List<DateTimeRange> skipped = [];
    DateTime startSkipping = widget.date.start;

    for (int i = 0; i <= viewRange; i++) {
      // for each hour, build the timeline
      var currentDate = tempDate;
      tempDate = tempDate.add(const Duration(hours: 1));
      var existing = events
          .where(
            (x) => x.start.isBefore(tempDate) && x.stop.isAfter(currentDate),
          )
          .toList();

      if (existing.isNotEmpty) {
        // There is an event during that hour

        if (skipping || currentDate.hour < 1) {
          // first hour after a skip or a new day
          headerDayItems.add(buildDayHeader(tempDate, context));
        } else {
          headerDayItems.add(_fillerWidget());
        }
        headerItems.add(buildHeader(currentDate, context));
        gridColumns.add(buildGrid());

        if (skipping) {
          skipping = false;
          skipped.add(DateTimeRange(start: startSkipping, end: currentDate));
        }
      } else {
        if (!skipping) {
          headerItems.add(_skipWidget(context));
          gridColumns.add(_skipWidget(context));
          headerDayItems.add(_skipWidget(context));

          skipping = true;
          startSkipping = currentDate;
        }
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

  Widget buildDayHeader(DateTime tempDate, BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.centerLeft,
      width: boxWidth,
      child: Text(
        ' ${tempDate.day.toString().padLeft(2, '0')}/${tempDate.month.toString().padLeft(2, '0')}/${tempDate.year.toString().padLeft(4, '0')}',
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget buildHeader(DateTime utc, BuildContext context) {
    var tempDate = utc.toLocal();
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      alignment: Alignment.centerLeft,
      width: boxWidth,
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
      width: boxWidth,
      height: 200,
    );
  }

  int _minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  double _distanceToLeftBorder(
    DateTime projectStartedAt,
    List<DateTimeRange<DateTime>> skipped,
  ) {
    if (projectStartedAt.compareTo(widget.date.start) <= 0) {
      return 0;
    } else {
      var skipping = skipped
          .where(
            (x) =>
                x.end.isBefore(projectStartedAt) ||
                x.end.isAtSameMomentAs(projectStartedAt),
          )
          .toList();

      var widthToSkip =
          skipping.map((a) => a.duration.inMinutes).sum -
          (skipping.length * skippedWidth);

      var fullDistance = _minutesBetween(widget.date.start, projectStartedAt);

      return (fullDistance - widthToSkip).toDouble() * widthCoef;
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
        var color = Dependencies.theme.stateColor(n.description ?? '');
        var left = _distanceToLeftBorder(start, skipped);
        if (width > 0) {
          chartGroup.add(
            Container(
              margin: EdgeInsets.only(left: left, top: 2.0, bottom: 2.0),
              alignment: Alignment.centerLeft,
              child: Tooltip(
                message:
                    "${n.description ?? ""}: ${n.start.toLocal()} => ${n.stop.toLocal()} ( ${left * widthCoef} - ${width * widthCoef} ))",
                child: InkWell(
                  onTap: () => widget.selectionChanged(n),
                  child: Container(
                    width: width.toDouble() * widthCoef,
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

  Widget _skipWidget(BuildContext context) {
    return Container(
      width: skippedWidth.toDouble() * widthCoef,
      alignment: Alignment.center,
      child: Text('<>'),
    );
  }

  Widget _fillerWidget() => Container(
    color: Colors.red,
    child: SizedBox(width: boxWidth.toDouble()),
  );
}
