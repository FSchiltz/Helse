import 'package:flutter/material.dart' hide Interval;
import 'package:helse/helpers/date.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class EventInformation extends StatelessWidget {
  const EventInformation({
    super.key,
    required this.data,
  });

  final List<Interval> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container();
    }

    var duration = Duration();
    for (var interval in data) {
      var range = DateTimeRange(
        start: interval.start,
        end: interval.stop,
      ).duration;
      duration = duration + range;
    }

    var averageDuration = Duration(
      milliseconds: (duration.inMilliseconds / data.length).toInt(),
    );

    return Text(
      "Total of ${DateHelper.formatDuration(duration)} in ${data.length} sessions with an average of ${DateHelper.formatDuration(averageDuration)}",
    );
  }
}
