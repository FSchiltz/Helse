import 'package:collection/collection.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

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
}
