import 'dart:math';
import 'dart:developer' as logger;
import 'package:flutter/material.dart' hide Interval;
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/event_helper.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/selection_widget.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/session_chart.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/session_list.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/sessions_range.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';
import 'package:helse/ui/common/inputs/date_range_picker.dart';
import 'package:helse/ui/common/navigator_chart.dart';
import 'package:helse/ui/common/ui_constants.dart';

class GroupStats {
  final List<EventSummary> groups;
  final Map<String, int> counts;
  final int total;

  const GroupStats(this.groups, this.counts, this.total);
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
    final stats = _group(filteredEvents, subDate);
    final sessions = EventHelper.getSessions(filteredEvents);

    final radius = 40.0;
    final graphHeight = 4 * radius;
    final height = graphHeight + UIConstants.formPad * 2 + 10;
    var color = Dependencies.theme.stateColor(
      widget.type.id.toString(),
      StateType.events,
      context,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: UIConstants.formPad,
      children: [
        DateRangePicker(
          _setDate,
          subDate,
          range: widget.range,
          offset: widget.type.timeDifference,
        ),
        SizedBox(
          child: NavigatorChart(
            widget.range,
            subDate,
            _setDate,
            graph: EventsSummary(_groups, widget.range),
          ),
        ),
        Flexible(
          child: (filteredEvents.length < 200)
              ? EventsTimelineGraph(
                  filteredEvents,
                  subDate,
                  onselect: _selectionChanged,
                )
              : EventsSummary(stats.groups, subDate),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                SessionChart(
                  sessions: sessions,
                  widget: widget,
                  graphHeight: graphHeight,
                  radius: radius,
                  stats: stats,
                ),
                if (event != null)
                  SelectionWidget(
                    event: event,
                    reset: () {
                      widget.reset();
                      setState(() {
                        _event = null;
                      });
                    },
                    person: widget.person,
                    type: widget.type,
                  ),
                SessionList(height: height, color: color, sessions: sessions),
                SessionsRange(height: height, color: color, sessions: sessions),
              ],
            ),
          ),
        ),
      ],
    );
  }

  GroupStats _group(List<Event> events, DateTimeRange range) {
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
      var seconds = max(1, event.stop.difference(event.start).inSeconds);
      total = total + seconds;
      if (existing != null) {
        seconds = existing + seconds;
      }
      counts[event.description ?? ''] = seconds;
    }

    logger.log('_group() executed in ${stopwatch.elapsed}', name: "Events");
    return GroupStats(groups.toList(), counts, total);
  }
}

class MutableInterval {
  DateTime start;
  DateTime stop;
  MutableInterval({required this.start, required this.stop});
}
