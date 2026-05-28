import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/blocs/events/event_detail_page.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';
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

  Future<List<EventSummary>> _getData(bool refresh) async {
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
        ) ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const ContinuousRectangleBorder(),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => EventDetailPage(
                          date: widget.date,
                          type: widget.type,
                          person: widget.person,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.type.name,
                      style: Theme.of(context).textTheme.titleLarge,
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
            LoadingBuilder(
              _getData,
              builder: (ctx, data, reset) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: EventsSummary(data, widget.date),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
