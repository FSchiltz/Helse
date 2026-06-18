import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/blocs/events/event_detail_page.dart';
import 'package:helse/ui/blocs/events/event_information.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';
import 'package:helse/ui/common/layout/common_card.dart';
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
    return await Dependencies.services.event.eventsSummary(
      widget.type.id,
      widget.date.start,
      widget.date.end,
      person: widget.person,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (ctx, data, reset) {
        final summaries = data?.summaries ?? [];
        final hasFullData = data != null && data.events.isNotEmpty;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 6),
                Text(
                  widget.type.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: EventInformation(
                      data: data?.durations ?? [],
                      type: widget.type,
                    ),
                  ),
                ),
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
                  child: (hasFullData)
                      ? EventsTimelineGraph(
                          data.events,
                          widget.date,
                          widthCoef: 0.8,
                        )
                      : EventsSummary(summaries, widget.date),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
