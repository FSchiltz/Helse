import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/events/sleep_transition_painter.dart';

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

class TimelineItems {
  final List<Widget> header = [];
  final List<Widget> headerDay = [];
  final List<Widget> grid = [];
  final List<DateTimeRange> skipped = [];
  final List<Widget> bars = [];
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
    final labels = widget.events
        .map((e) => e.description ?? '')
        .toSet()
        .toList();
    final rowCount = labels.length;

    return widget.events.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              Translation.of(context).nodata,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRowLabels(labels),
              Expanded(
                child: Scrollbar(
                  interactive: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: buildChart(widget.events, rowCount, context),
                  ),
                ),
              ),
            ],
          );
  }

  TimelineItems _group(List<Event> events) {
    final stopwatch = Stopwatch()..start();
    final timeline = TimelineItems();
    DateTime tempDate = widget.date.start;
    bool skipping = false;
    DateTime startSkipping = widget.date.start;

    var viewRange = _minutesBetween(widget.date.start, widget.date.end) / 60;
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
          timeline.headerDay.add(buildDayHeader(tempDate, context));
        } else {
          timeline.headerDay.add(_fillerWidget());
        }

        timeline.header.add(buildHeader(currentDate, context));
        timeline.grid.add(buildGrid());

        if (skipping) {
          skipping = false;
          timeline.skipped.add(
            DateTimeRange(start: startSkipping, end: currentDate),
          );
        }
      } else {
        if (!skipping) {
          timeline.header.add(_skipWidget(context));
          timeline.grid.add(_skipWidget(context));
          timeline.headerDay.add(_skipWidget(context));
          skipping = true;
          startSkipping = currentDate;
        }
      }
    }

    if (skipping) {
      timeline.skipped.add(DateTimeRange(start: startSkipping, end: tempDate));
    }

    buildChartBars(events, timeline);

    debugPrint('grouped in ${stopwatch.elapsed} with $viewRange bucket');
    return timeline;
  }

  Widget buildChart(List<Event> events, int rowCount, BuildContext context) {
    final timeline = _group(events);

    return Stack(
      fit: StackFit.loose,
      children: [
        Row(children: timeline.grid),
        SizedBox(height: 25.0, child: Row(children: timeline.headerDay)),
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: SizedBox(height: 25.0, child: Row(children: timeline.header)),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: CustomPaint(painter: SleepTransitionPainter(_eventLayouts)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 52.0),
          child: SizedBox(
            width: max(timeline.grid.length * boxWidth, 500),
            height: rowCount * 29.0 + 40,
            child: Stack(clipBehavior: Clip.none, children: timeline.bars),
          ),
        ),
      ],
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
    return max(1, _minutesBetween(start, end));
  }

  Widget buildRowLabels(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: labels.map((label) {
          return SizedBox(
            height: 29.0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4),
                child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void buildChartBars(List<Event> events, TimelineItems timeline) {
    _eventLayouts.clear();

    final Map<String?, List<Event>> orderedData = {};

    for (final n in events) {
      orderedData.putIfAbsent(n.description, () => []).add(n);
    }

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
        final left = _distanceToLeftBorder(start, timeline.skipped);

        _eventLayouts.add(
          EventLayout(
            event: n,
            left: left,
            right: left + (width * widthCoef),
            centerY: rowTop + 14.5,
            color: color,
          ),
        );

        timeline.bars.add(
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
                ),
              ),
            ),
          ),
        );
      }

      rowIndex++;
    }
  }

  Widget _skipWidget(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SizedBox(
      width: skippedWidth.toDouble() * widthCoef,
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: theme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.fast_forward_sharp, size: 14, color: theme.primary),
          ),
          Expanded(child: Divider(thickness: 1, color: theme.outlineVariant)),
        ],
      ),
    );
  }

  Widget _fillerWidget() => SizedBox(width: boxWidth);
}
