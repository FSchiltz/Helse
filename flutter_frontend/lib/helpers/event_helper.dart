import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/detail/event_more_info.dart';
import 'package:helse/ui/blocs/events/events_add.dart';

class MutableInterval {
  DateTime start;
  DateTime stop;
  MutableInterval({required this.start, required this.stop});
}

class EventHelper {
  static List<Interval> getSessions(List<Event> events) {
    List<MutableInterval> durations = [];
    final delta = Duration(seconds: 30);
    events.sortBy((e) => e.start);
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

  static List<Widget> getButtons(
    Event m,
    EventType type,
    void Function() reset, {
    required BuildContext context,
    int? person,
  }) {
    return [
      IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return EventMoreInfo(type, reset, person: person, event: m);
            },
          );
        },
        icon: const Icon(Icons.open_in_new_sharp),
      ),
      IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return EventAdd(type, reset, person: person, edit: m);
            },
          );
        },
        icon: const Icon(Icons.edit_sharp),
      ),
      IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return DeleteEvent(() async {
                await Dependencies.services.event.deleteEvent(m.id);
                reset();
              }, person: person);
            },
          );
        },
        icon: const Icon(Icons.delete_sharp),
      ),
    ];
  }
}
