import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:helse/helpers/date.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/event_information.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';
import 'package:helse/ui/common/common_card.dart';
import 'package:helse/ui/common/date_range_picker.dart';
import 'package:helse/ui/common/navigator_chart.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    var event = _event;
    var id = _event?.id;
    var locale = Translation.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
              graph: EventsSummary(
                _group(widget.events, widget.range),
                widget.range,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        EventInformation(data: _getDurations(filteredEvents)),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: (filteredEvents.length < 200)
              ? EventsTimelineGraph(filteredEvents, subDate, _selectionChanged)
              : SizedBox(
                  height: 300,
                  child: EventsSummary(
                    _group(filteredEvents, subDate),
                    subDate,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommonCard(
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
                      DateHelper.format(event.stop.toLocal(), context: context),
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
                              await Dependencies.services.event.deleteEvent(id);
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
        ),
      ],
    );
  }

  List<EventSummary> _group(List<Event> events, DateTimeRange range) {
    final stopwatch = Stopwatch()..start();
    final buckets = min(events.length, 1000);

    // First create the buckets
    final bucketLength = range.duration.inMilliseconds / buckets;

    debugPrint(
      'grouping with buckets: $buckets and bucket lenght: $bucketLength for $subDate',
    );

    final groups = List<EventSummary>.generate(
      buckets,
      (_) => EventSummary(data: {}),
    );

    for (var event in events) {
      // find the bucket
      final duration = event.start.difference(range.start);
      final index = (duration.inMilliseconds / bucketLength).toInt();
      final bucketCount =
          event.stop.difference(event.start).inMilliseconds / bucketLength;

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
    }

    debugPrint('_group() executed in ${stopwatch.elapsed}');
    return groups.toList();
  }

  List<Interval> _getDurations(List<Event> events) {
    List<MutableInterval> durations = [];
    for (var e in events) {
      var duration = durations.firstWhereOrNull(
        (x) =>
            (e.stop.isAfter(x.start) || e.stop.isAtSameMomentAs(x.start)) &&
            (e.start.isBefore(x.stop) || e.start.isAtSameMomentAs(x.stop)),
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
