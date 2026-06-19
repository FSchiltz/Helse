import 'dart:math';
import 'dart:developer' as logger;
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/event_information.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/inputs/date_range_picker.dart';
import 'package:helse/ui/common/navigator_chart.dart';
import 'package:helse/ui/common/ui_constants.dart';

class _GroupStats {
  final List<EventSummary> groups;
  final Map<String, int> counts;
  final int total;

  const _GroupStats(this.groups, this.counts, this.total);
}

class EventsGraph extends StatefulWidget {
  final DateTimeRange range;
  final EventType type;
  final int? person;
  final List<Event> events;
  final void Function() reset;

  const EventsGraph({
    super.key,
    required this.range,
    required this.type,
    required this.person,
    required this.events,
    required this.reset,
  });

  @override
  State<EventsGraph> createState() => _EventsGraphState();
}

class _EventsGraphState extends State<EventsGraph> {
  Event? _event;
  List<Event> filteredEvents = [];

  void _selectionChanged(Event event) {
    setState(() {
      _event = event;
    });
  }

  DateTimeRange subDate = DateHelper.now();
  List<EventSummary> _groups = [];

  void _setDate(DateTimeRange value) {
    var filter = widget.events
        .where(
          (x) => x.stop.isAfter(value.start) && x.start.isBefore(value.end),
        )
        .toList();

    setState(() {
      subDate = value;
      filteredEvents = filter;
    });
  }

  @override
  void initState() {
    super.initState();
    subDate = widget.range;
    filteredEvents = widget.events;
    var stats = _group(widget.events, widget.range);
    _groups = stats.groups;
  }

  @override
  Widget build(BuildContext context) {
    var event = _event;
    var id = _event?.id;
    var locale = Translation.of(context);
    final stats = _group(filteredEvents, subDate);

    final radius = 40.0;
    final sections = stats.counts.entries.map((entry) {
      return PieChartSectionData(
        color: Dependencies.theme.stateColor(
          entry.key,
          StateType.eventValue,
          context,
        ),
        value: entry.value.toDouble(),
        title: entry.key,
        radius: radius,
        showTitle: false,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateRangePicker(_setDate, subDate, range: widget.range),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: NavigatorChart(
              widget.range,
              subDate,
              _setDate,
              graph: EventsSummary(_groups, widget.range),
            ),
          ),
        ),
        SizedBox(height: UIConstants.formPad),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (filteredEvents.length < 200)
                ? EventsTimelineGraph(
                    filteredEvents,
                    subDate,
                    onselect: _selectionChanged,
                  )
                : EventsSummary(stats.groups, subDate),
          ),
        ),
        SizedBox(height: UIConstants.formPad),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                CommonCard(
                  child: Column(
                    children: [
                      EventInformation(
                        data: _getSessions(filteredEvents),
                        type: widget.type,
                      ),
                      const SizedBox(height: UIConstants.formPad),
                      Wrap(
                        runAlignment: WrapAlignment.start,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: UIConstants.formPad,
                        runSpacing: UIConstants.formPad,
                        children: [
                          SizedBox(
                            height: 4 * radius,
                            width: 4 * radius,
                            child: PieChart(
                              PieChartData(
                                sections: sections,
                                centerSpaceRadius: radius,
                                sectionsSpace: 0,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sections.map((entry) {
                              final item = entry.value;

                              final percentage = item / stats.total * 100;
                              final duration = Duration(seconds: item.toInt());
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: entry.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${entry.title} ${DateHelper.formatDuration(duration, locale)} (${percentage.toStringAsFixed(2)}%)',
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CommonCard(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Selected: '),
                      if (event != null) Text('(${event.id})'),
                      if (event != null) Text(' ${event.description} '),
                      if (event != null)
                        Text(
                          locale.range(
                            DateHelper.format(
                              event.start.toLocal(),
                              context: context,
                            ),
                            DateHelper.format(
                              event.stop.toLocal(),
                              context: context,
                            ),
                          ),
                        ),
                      if (event != null && event.tag != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(event.tag.toString()),
                        ),
                      if (event != null)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return EventAdd(
                                    widget.reset,
                                    widget.type,
                                    person: widget.person,
                                    edit: event,
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit_sharp),
                          ),
                        ),
                      if (id != null)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteEvent(() async {
                                    await Dependencies.services.event
                                        .deleteEvent(id);
                                    widget.reset();
                                    setState(() {
                                      _event = null;
                                    });
                                  }, person: widget.person);
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_sharp),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _GroupStats _group(List<Event> events, DateTimeRange range) {
    final stopwatch = Stopwatch()..start();

    // we take between 120 and 1000 buckets
    final buckets = min(max(events.length, 120), 1000);

    // First create the buckets
    final bucketLength = range.duration.inMilliseconds / buckets;

    logger.log(
      'grouping with buckets: $buckets and bucket lenght: $bucketLength for $subDate',
      name: "Events",
    );

    final groups = List<EventSummary>.generate(
      buckets,
      (_) => EventSummary(data: {}),
    );

    final Map<String, int> counts = {};
    int total = 0;
    for (var event in events) {
      // find the bucket
      // events can start and end outside of the asked range so we need to clamp them
      final start = DateHelper.max(event.start, range.start);
      final stop = DateHelper.min(event.stop, range.end);
      final duration = start.difference(range.start);
      final index = (duration.inMilliseconds / bucketLength).toInt();
      final bucketCount = stop.difference(start).inMilliseconds / bucketLength;

      for (var i = 0; i < bucketCount; i++) {
        final bucket = groups[index + i];
        // if it does not exists create it
        final dataRow = bucket.data[event.description ?? ''];
        if (dataRow == null) {
          bucket.data[event.description ?? ''] = 1;
        } else {
          bucket.data[event.description ?? ''] = (dataRow as int) + 1;
        }
      }

      // fill the label count
      final existing = counts[event.description ?? ''];
      final seconds = max(1, event.stop.difference(event.start).inSeconds);
      total = total + seconds;
      if (existing != null) {
        counts[event.description ?? ''] = seconds;
      } else {
        counts[event.description ?? ''] = seconds;
      }
    }

    logger.log('_group() executed in ${stopwatch.elapsed}', name: "Events");
    return _GroupStats(groups.toList(), counts, total);
  }

  List<Interval> _getSessions(List<Event> events) {
    List<MutableInterval> durations = [];
    final delta = Duration(seconds: 30);
    for (var e in events) {
      final expandedStart = e.start.subtract(delta);
      final expandedStop = e.stop.add(delta);
      var duration = durations.firstWhereOrNull(
        (x) =>
            (expandedStop.isAfter(x.start) ||
                expandedStop.isAtSameMomentAs(x.start)) &&
            (expandedStart.isBefore(x.stop) ||
                expandedStart.isAtSameMomentAs(x.stop)),
      );
      if (duration == null) {
        durations.add(MutableInterval(start: e.start, stop: e.stop));
      } else {
        if (e.start.isBefore(duration.start)) {
          // the event is before, we add to the start
          duration.start = e.start;
        }

        if (e.stop.isAfter(duration.stop)) {
          // the event is after
          duration.stop = e.stop;
        }
      }
    }
    return durations
        .map((e) => Interval(start: e.start, stop: e.stop))
        .toList();
  }
}

class MutableInterval {
  DateTime start;
  DateTime stop;
  MutableInterval({required this.start, required this.stop});
}
