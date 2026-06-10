import 'package:flutter/material.dart' hide Interval;
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/ui/blocs/events/event_detail_page.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
import 'package:helse/ui/common/common_card.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'events_add.dart';

class EventWidget extends StatefulWidget {
  final EventType type;
  final DateTimeRange date;
  final int? person;

  const EventWidget(this.type, this.date, {super.key, this.person});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  _EventWidgetState();

  void _resetEvents() {
    setState(() {
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  @override
  void initState() {
    super.initState();
  }

  Future<EventStats?> _getData(bool refresh) async {
    var date = widget.date;
    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(
      date.end.year,
      date.end.month,
      date.end.day,
    ).add(const Duration(days: 1));

    return await Dependencies.services.event.eventsSummary(
      widget.type.id,
      start,
      end,
      person: widget.person,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (ctx, data, reset) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 6),
                Text(
                  widget.type.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(width: 12),
                _getSummary(data?.durations ?? []),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return EventAdd(
                          _resetEvents,
                          widget.type,
                          person: widget.person,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add_sharp),
                ),
              ],
            ),
            CommonCard(
              padding: false,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => EventDetailPage(
                      date: widget.date,
                      type: widget.type,
                      person: widget.person,
                    ),
                  ),
                ),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(12.0),
                  child: EventsSummary(data?.summaries ?? [], widget.date),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getSummary(List<Interval> data) {
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
