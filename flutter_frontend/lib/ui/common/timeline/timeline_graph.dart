import 'dart:developer' as logger;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/timeline/event_layout.dart';
import 'package:helse/ui/common/timeline/event_transition_painter.dart';
import 'package:helse/ui/common/timeline/timeline_items.dart';
import 'package:helse/ui/common/timeline/timeline_node.dart';

class TimelineGraph<T> extends StatefulWidget {
  final List<TimelineNode<T>> events;
  final DateTimeRange date;
  final void Function(T event)? onselect;
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
  final List<EventLayout<T>> _eventLayouts = [];
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
                child: buildRowLabels(labels, widget.rowHeight),
              ),
              Expanded(
                child: Scrollbar(
                  interactive: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: buildChart(
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
        widget.date.end.difference(widget.date.start).inMinutes / 60;
    for (int i = 0; i < viewRange; i++) {
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

    buildChartBars(events, timeline, rowHeight);
    logger.log('grouped in ${stopwatch.elapsed} with $viewRange bucket');
    return timeline;
  }

  Widget buildChart(
    List<TimelineNode<T>> events,
    int rowCount,
    double rowHeight,
    BuildContext context,
  ) {
    final timeline = _group(events, rowHeight);

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
              child: CustomPaint(
                painter: EventTransitionPainter(_eventLayouts),
              ),
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
  );

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
    if (start.isBefore(widget.date.start.toLocal())) {
      start = widget.date.start.toLocal();
    }
    if (end.isAfter(widget.date.end.toLocal())) {
      end = widget.date.end.toLocal();
    }
    return max(1, end.difference(start).inMinutes);
  }

  Widget buildRowLabels(List<String> labels, double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: labels.map((label) {
        return SizedBox(
          height: height,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4),
              child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
          ),
        );
      }).toList(),
    );
  }

  void buildChartBars(
    List<TimelineNode<T>> events,
    TimelineItems timeline,
    double rowHeight,
  ) {
    _eventLayouts.clear();

    final Map<String, List<TimelineNode<T>>> orderedData = {};

    for (final n in events) {
      orderedData.putIfAbsent(n.label, () => []).add(n);
    }

    int rowIndex = 0;

    for (final group in orderedData.entries) {
      final rowTop = rowIndex * rowHeight;
      final color = widget.getColor.call(group.key);

      for (final n in group.value) {
        final start = n.start.toLocal();
        final end = n.stop.toLocal();

        final width = _distanceInMinutes(start, end);
        final left = _distanceToLeftBorder(start, timeline.skipped);

        _eventLayouts.add(
          EventLayout(
            event: n,
            left: left,
            right: left + (width * widget.widthCoef),
            centerY: rowTop + (rowHeight / 2),
            color: color,
          ),
        );

        final callback = widget.onselect;
        timeline.bars.add(
          Positioned(
            left: left,
            top: rowTop,
            child: Tooltip(
              message:
                  "${n.label}: ${n.start.toLocal()} => ${n.stop.toLocal()}",
              child: callback != null
                  ? InkWell(
                      onTap: () => callback(n.item),
                      child: Container(
                        width: width.toDouble() * widget.widthCoef,
                        height: rowHeight - 8,
                        decoration: BoxDecoration(
                          color: color.withAlpha(150),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    )
                  : Container(
                      width: width.toDouble() * widget.widthCoef,
                      height: rowHeight - 8,
                      decoration: BoxDecoration(
                        color: color.withAlpha(150),
                        borderRadius: BorderRadius.circular(3),
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
      width: skippedWidth.toDouble() * widget.widthCoef,
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: theme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.fast_forward_sharp,
              size: 14,
              color: theme.primary,
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: theme.outlineVariant)),
        ],
      ),
    );
  }

  Widget _fillerWidget() => SizedBox(width: boxWidth);
}
