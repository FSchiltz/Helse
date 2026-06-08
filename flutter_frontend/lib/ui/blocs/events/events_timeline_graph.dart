import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';

class EventLayout {
  final Event event;
  final double left;
  final double right;
  final double centerY;
  final Color color;

  EventLayout({
    required this.event,
    required this.left,
    required this.right,
    required this.centerY,
    required this.color,
  });
}

class SleepTransitionPainter extends CustomPainter {
  final List<EventLayout> layouts;

  SleepTransitionPainter(this.layouts);

  @override
  void paint(Canvas canvas, Size size) {
    if (layouts.length < 2) return;

    final sorted = [...layouts]
      ..sort((a, b) => a.event.start.compareTo(b.event.start));

    for (int i = 0; i < sorted.length - 1; i++) {
      final current = sorted[i];
      final next = sorted[i + 1];

      final gap = next.event.start
          .difference(current.event.stop)
          .inMinutes
          .abs();

      if (gap > 15) continue;

      final paint = Paint()
        ..color = current.color.withAlpha(150)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final connectorX = current.right;

      final path = Path()
        ..moveTo(connectorX - 1, current.centerY)
        ..lineTo(next.left + 1, next.centerY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SleepTransitionPainter oldDelegate) => true;
}

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
  final List<EventLayout> _eventLayouts = [];

  @override
  Widget build(BuildContext context) {
    return widget.events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              Translation.of(context).nodata,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : buildChart(widget.events, context);
  }

  Widget buildChart(List<Event> events, BuildContext context) {
    var viewRange = _minutesBetween(widget.date.start, widget.date.end) / 60;

    List<Widget> headerItems = [];
    List<Widget> headerDayItems = [];
    List<Widget> gridColumns = [];
    DateTime tempDate = widget.date.start;
    bool skipping = false;
    List<DateTimeRange> skipped = [];
    DateTime startSkipping = widget.date.start;

    for (int i = 0; i <= viewRange; i++) {
      var currentDate = tempDate;
      tempDate = tempDate.add(const Duration(hours: 1));

      var existing = events
          .where(
            (x) => x.start.isBefore(tempDate) && x.stop.isAfter(currentDate),
          )
          .toList();

      if (existing.isNotEmpty) {
        if (skipping || currentDate.hour < 1) {
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
      skipped.add(DateTimeRange(start: startSkipping, end: tempDate));
    }

    final chartBars = buildChartBars(events, skipped);
    final rowCount = events
        .map((e) => e.description)
        .toSet()
        .length
        .clamp(1, 9999);

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
            children: [
              Row(children: gridColumns),
              SizedBox(height: 25.0, child: Row(children: headerDayItems)),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: SizedBox(
                  height: 25.0,
                  child: Row(children: headerItems),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: SleepTransitionPainter(_eventLayouts),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: SizedBox(
                  width: max(gridColumns.length * boxWidth, 500),
                  height: rowCount * 29.0 + 40,
                  child: Stack(clipBehavior: Clip.none, children: chartBars),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDayHeader(DateTime tempDate, BuildContext context) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    alignment: Alignment.centerLeft,
    width: boxWidth,
    child: Text(
      ' ${tempDate.day.toString().padLeft(2, '0')}/${tempDate.month.toString().padLeft(2, '0')}/${tempDate.year.toString().padLeft(4, '0')}',
    ),
  );

  Widget buildHeader(DateTime utc, BuildContext context) {
    var tempDate = utc.toLocal();
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      alignment: Alignment.centerLeft,
      width: boxWidth,
      child: Tooltip(
        message: '$tempDate',
        child: Text(
          '${tempDate.hour.toString().padLeft(2, '0')}:${tempDate.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  Widget buildGrid() => Container(
    decoration: BoxDecoration(
      border: Border(
        right: BorderSide(color: Colors.white.withAlpha(75), width: 0.5),
      ),
    ),
    width: boxWidth,
    height: 200,
  );

  int _minutesBetween(DateTime from, DateTime to) =>
      to.difference(from).inMinutes;

  double _distanceToLeftBorder(
    DateTime projectStartedAt,
    List<DateTimeRange<DateTime>> skipped,
  ) {
    if (projectStartedAt.compareTo(widget.date.start) <= 0) return 0;

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

  int _distanceInMinutes(DateTime start, DateTime end) {
    if (start.compareTo(widget.date.start) < 0) start = widget.date.start;
    if (end.compareTo(widget.date.end) > 0) end = widget.date.end;
    return max(6, _minutesBetween(start, end));
  }

  List<Widget> buildChartBars(
    List<Event> events,
    List<DateTimeRange<DateTime>> skipped,
  ) {
    _eventLayouts.clear();

    final Map<String?, List<Event>> orderedData = {};

    for (final n in events) {
      orderedData.putIfAbsent(n.description, () => []).add(n);
    }

    final List<Widget> bars = [];
    int rowIndex = 0;

    for (final group in orderedData.entries) {
      final rowTop = rowIndex * 29.0;

      for (final n in group.value) {
        final start = n.start.toLocal();
        final end = n.stop.toLocal();

        final width = _distanceInMinutes(start, end);
        final color = Dependencies.theme.stateColor(
          n.description ?? '',
          context,
        );
        final left = _distanceToLeftBorder(start, skipped);

        _eventLayouts.add(
          EventLayout(
            event: n,
            left: left,
            right: left + (width * widthCoef),
            centerY: rowTop + 14.5,
            color: color,
          ),
        );

        bars.add(
          Positioned(
            left: left,
            top: rowTop,
            child: Tooltip(
              message:
                  "${n.description ?? ""}: ${n.start.toLocal()} => ${n.stop.toLocal()}",
              child: InkWell(
                onTap: () => widget.selectionChanged(n),
                child: Container(
                  width: width.toDouble() * widthCoef,
                  height: 25,
                  decoration: BoxDecoration(
                    color: color.withAlpha(150),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      n.description ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      rowIndex++;
    }

    return bars;
  }

  Widget _skipWidget(BuildContext context) => Container(
    width: skippedWidth.toDouble() * widthCoef,
    alignment: Alignment.center,
    child: const Text('<>'),
  );

  Widget _fillerWidget() => SizedBox(width: boxWidth);
}
