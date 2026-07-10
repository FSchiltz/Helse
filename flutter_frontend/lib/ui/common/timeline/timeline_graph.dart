import 'dart:developer' as logger;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/timeline/event_layout.dart';
import 'package:helse/ui/common/timeline/event_transition_painter.dart';
import 'package:helse/ui/common/timeline/time_line_labels.dart';
import 'package:helse/ui/common/timeline/timeline_day_header.dart';
import 'package:helse/ui/common/timeline/timeline_filler.dart';
import 'package:helse/ui/common/timeline/timeline_grid.dart';
import 'package:helse/ui/common/timeline/timeline_header.dart';
import 'package:helse/ui/common/timeline/timeline_items.dart';
import 'package:helse/ui/common/timeline/timeline_node.dart';
import 'package:helse/ui/common/timeline/timeline_skip.dart';

class TimelineGraph<T> extends StatefulWidget {
  final List<TimelineNode<T>> events;
  final DateTimeRange date;
  final void Function(List<T> event)? onselect;
  final Color Function(String label) getColor;
  final bool link;
  final double widthCoef;

  final double rowHeight;

  const TimelineGraph(
    this.events,
    this.date, {
    super.key,
    this.onselect,
    this.widthCoef = 2,
    required this.getColor,
    this.link = true,
    this.rowHeight = 18,
  });

  @override
  State<TimelineGraph<T>> createState() => _EventsTimelineGraphState();
}

class _EventsTimelineGraphState<T> extends State<TimelineGraph<T>> {
  static const int skippedWidth = 32;
  double boxWidth = 0;
  final double headerHeight = 50;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    boxWidth = 60.0 * widget.widthCoef;
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.events.map((e) => e.label).toSet().toList();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: headerHeight),
                child: TimelineLabels(labels: labels, height: widget.rowHeight),
              ),
              Expanded(
                child: Scrollbar(
                  interactive: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: _buildChart(
                      widget.events,
                      rowCount,
                      widget.rowHeight,
                      context,
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  TimelineItems _group(List<TimelineNode<T>> events, double rowHeight) {
    final stopwatch = Stopwatch()..start();
    final timeline = TimelineItems();
    DateTime tempDate = widget.date.start;
    bool skipping = false;
    DateTime startSkipping = widget.date.start;

    final viewRange =
        (widget.date.end.difference(widget.date.start).inMinutes / 60).toInt();

    for (int i = 0; i < viewRange; i++) {
      var currentDate = tempDate;
      tempDate = tempDate.add(const Duration(hours: 1));

      var existing = events.any(
        (x) => x.start.isBefore(tempDate) && x.stop.isAfter(currentDate),
      );

      if (existing) {
        if (skipping || currentDate.hour < 1) {
          timeline.headerDay.add(TimelineDayHeader(boxWidth, tempDate));
        } else {
          timeline.headerDay.add(TimelineFiller(boxWidth));
        }

        timeline.header.add(
          TimelineHeader(boxWidth: boxWidth, utc: currentDate),
        );
        timeline.grid.add(TimelineGrid(boxWidth: boxWidth));

        if (skipping) {
          skipping = false;
          timeline.skipped.add(
            DateTimeRange(start: startSkipping, end: currentDate),
          );
        }
      } else {
        if (!skipping) {
          timeline.header.add(TimelineSkip(skippedWidth, widget.widthCoef));
          timeline.grid.add(TimelineSkip(skippedWidth, widget.widthCoef));
          timeline.headerDay.add(TimelineSkip(skippedWidth, widget.widthCoef));
          skipping = true;
          startSkipping = currentDate;
        }
      }
    }

    if (skipping) {
      timeline.skipped.add(DateTimeRange(start: startSkipping, end: tempDate));
    }

    logger.log('grouped in ${stopwatch.elapsed} with $viewRange bucket');
    return timeline;
  }

  Widget _buildChart(
    List<TimelineNode<T>> events,
    int rowCount,
    double rowHeight,
    BuildContext context,
  ) {
    final timeline = _group(events, rowHeight);
    final layouts = _buildChartBars(events, timeline, rowHeight);

    return Stack(
      fit: StackFit.loose,
      children: [
        Row(children: timeline.grid),
        SizedBox(
          height: headerHeight / 2,
          child: Row(children: timeline.headerDay),
        ),
        Container(
          margin: EdgeInsets.only(top: headerHeight / 2),
          child: SizedBox(
            height: headerHeight / 2,
            child: Row(children: timeline.header),
          ),
        ),
        if (widget.link)
          Positioned(
            top: headerHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: CustomPaint(painter: EventTransitionPainter(layouts)),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 52.0),
          child: SizedBox(
            width: max(timeline.grid.length * boxWidth, 500),
            height: rowCount * rowHeight + headerHeight,
            child: Stack(clipBehavior: Clip.none, children: timeline.bars),
          ),
        ),
      ],
    );
  }

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

    final widthToSkip =
        skipping.map((a) => a.duration.inMinutes).sum -
        (skipping.length * skippedWidth);

    final fullDistance = projectStartedAt
        .difference(widget.date.start)
        .inMinutes;

    return (fullDistance - widthToSkip).toDouble() * widget.widthCoef;
  }

  int _distanceInMinutes(DateTime start, DateTime end) {
    if (start.isBefore(widget.date.start)) {
      start = widget.date.start;
    }
    if (end.isAfter(widget.date.end)) {
      end = widget.date.end;
    }
    return max(1, end.difference(start).inMinutes);
  }

  List<EventLayout<T>> _buildChartBars(
    List<TimelineNode<T>> events,
    TimelineItems timeline,
    double rowHeight,
  ) {
    List<EventLayout<T>> layouts = [];

    final Map<String, List<TimelineNode<T>>> orderedData = {};

    for (final n in events) {
      orderedData.putIfAbsent(n.label, () => []).add(n);
    }

    int rowIndex = 0;

    for (final group in orderedData.entries) {
      final rowTop = rowIndex * rowHeight;
      final color = widget.getColor.call(group.key);

      for (final item in group.value) {
        final start = item.start;
        final end = item.stop;

        final width = _distanceInMinutes(start, end);
        final left = _distanceToLeftBorder(start, timeline.skipped);

        layouts.add(
          EventLayout(
            event: item,
            left: left,
            right: left + (width * widget.widthCoef),
            centerY: rowTop + (rowHeight / 2),
            color: color,
          ),
        );

        final callback = widget.onselect;
        final bar = Container(
          width: width.toDouble() * widget.widthCoef,
          height: rowHeight - 8,
          decoration: BoxDecoration(
            color: color.withAlpha(150),
            borderRadius: BorderRadius.circular(3),
          ),
        );
        timeline.bars.add(
          Positioned(
            left: left,
            top: rowTop,
            child: Tooltip(
              message:
                  "${item.label}: ${item.start.toLocal()} => ${item.stop.toLocal()}",
              child: callback != null
                  ? InkWell(onTap: () => callback([item.item]), child: bar)
                  : bar,
            ),
          ),
        );
      }

      rowIndex++;
    }

    return layouts;
  }
}
