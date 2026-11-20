import 'dart:math';
import 'dart:developer' as logger;
import 'package:material_ui/material_ui.dart' hide Interval;
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/event_helper.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/selection_widget.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/session_chart.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/session_list.dart';
import 'package:helse/ui/blocs/events/detail/stats_widgets/sessions_range.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';
import 'package:helse/ui/common/inputs/date_range_picker.dart';
import 'package:helse/ui/common/loading_builder.dart';
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

  const EventsGraph({
    super.key,
    required this.range,
    required this.type,
    required this.person,
  });

  @override
  State<EventsGraph> createState() => _EventsGraphState();
}

class _EventsGraphState extends State<EventsGraph> {
  final _selection = SelectionController<Event>();
  List<Event> _filteredEvents = [];
  late DateTimeRange _selectedDate;
  late DateTimeRange _subDate;
  late Color _color;
  late GroupStats _stats;
  List<Interval> _sessions = [];
  List<Event> _events = [];
  bool _withStats = true;

  void _setDate(DateTimeRange value) {
    setState(() {
      _selectedDate = value;
      _subDate = value;
    });
  }

  void _setSubDate(DateTimeRange value) {
    var filter = _events
        .where(
          (x) => x.stop.isAfter(value.start) && x.start.isBefore(value.end),
        )
        .toList();

    final stats = _group(filter, value);
    final sessions = EventHelper.getSessions(filter);

    setState(() {
      _subDate = value;
      _filteredEvents = filter;
      _stats = stats;
      _sessions = sessions;
    });
  }

  Future<List<Event>> _getData(bool refresh) async {
    var events =
        await Dependencies.services.event.events(
          widget.type.id,
          _selectedDate.start,
          _selectedDate.end,
          person: widget.person,
        ) ??
        [];

    if (events.length <= 10) {
      _selection.selected.clear();
      _selection.selected.addAll(events);
      _withStats = false;
      _sessions = [];
      _stats = GroupStats([], {}, 0);
    } else {
      _withStats = true;
      _stats = _group(events, _selectedDate);
      _sessions = EventHelper.getSessions(events);
    }

    _filteredEvents = events;
    _events = events;

    return events;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.range;
    _subDate = widget.range;

    _color = Dependencies.theme.stateColor(
      widget.type.id.toString(),
      StateType.events,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        final radius = 40.0;
        final graphHeight = 4 * radius;
        final height = graphHeight + UIConstants.formPad * 2 + 10;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: UIConstants.formPad,
          children: [
            DateRangePicker(
              _setDate,
              _selectedDate,
              offset: widget.type.timeDifference,
              initial: widget.range,
            ),
            SizedBox(
              child: NavigatorChart(
                _selectedDate,
                _subDate,
                _setSubDate,
                graph: EventsSummary(_stats.groups, _selectedDate),
              ),
            ),
            if (_withStats)
              Flexible(
                child: (_filteredEvents.length < 200)
                    ? EventsTimelineGraph(
                        _filteredEvents,
                        _subDate,
                        onselect: _selection.select,
                      )
                    : EventsSummary(_stats.groups, _subDate),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    if (_selection.selected.isNotEmpty)
                      SelectionWidget(
                        selection: _selection,
                        reset: () {
                          reset();
                          _selection.clear();
                        },
                        person: widget.person,
                        type: widget.type,
                      ),
                    if (_withStats)
                      SessionChart(
                        sessions: _sessions,
                        type: widget.type,
                        graphHeight: graphHeight,
                        radius: radius,
                        stats: _stats,
                      ),
                    if (_withStats)
                      SessionList(
                        height: height,
                        color: _color,
                        sessions: _sessions,
                        type: widget.type,
                      ),
                    if (_withStats)
                      SessionsRange(
                        height: height,
                        color: _color,
                        sessions: _sessions,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  GroupStats _group(List<Event> events, DateTimeRange range) {
    final stopwatch = Stopwatch()..start();

    // we take between 120 and 1000 buckets
    final buckets = min(max(events.length, 120), 1000);

    // First create the buckets
    final bucketLength = range.duration.inMilliseconds / buckets;

    logger.log(
      'grouping with buckets: $buckets and bucket lenght: $bucketLength for $_selectedDate',
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
