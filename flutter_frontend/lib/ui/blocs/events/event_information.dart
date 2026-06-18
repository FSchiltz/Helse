import 'package:flutter/material.dart' hide Interval;
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class EventInformation extends StatelessWidget {
  const EventInformation({super.key, required this.data, required this.type});

  final List<Interval> data;
  final EventType type;

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

    var locale = Translation.of(context);
    var theme = Theme.of(context).textTheme;
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.events,
      context,
    );
    return Wrap(
      runSpacing: 1,
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_up_sharp, color: color),
            SizedBox(width: 4),
            Text(
              DateHelper.formatDuration(duration, locale),
              style: theme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.update, color: color),
            SizedBox(width: 4),
            Text(
              DateHelper.formatDuration(averageDuration, locale),
              style: theme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
