import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/blocs/events/event_detail_page.dart';
import 'package:helse/ui/blocs/events/events_summary.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
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
  List<EventSummary>? _events;

  _EventWidgetState();

  void _resetEvents() {
    setState(() {
      _events = [];
    });
  }

  Future<List<EventSummary>?> _getData() async {
    try {
      if (widget.type.id == null) {
        _events = List<EventSummary>.empty();
        return _events;
      }

      var date = widget.date;
      var start = DateTime(date.start.year, date.start.month, date.start.day);
      var end = DateTime(date.end.year, date.end.month, date.end.day).add(const Duration(days: 1));

      _events = await DI.event?.eventsSummary(widget.type.id, start, end, person: widget.person);
      return _events;
    } catch (ex) {
      Notify.showError("$ex");
    }
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(widget.type.name ?? "", style: Theme.of(context).textTheme.titleLarge),
              ),
              IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return EventAdd(_resetEvents, widget.type, person: widget.person);
                        });
                  },
                  icon: const Icon(Icons.add_sharp))
            ],
          ),
          FutureBuilder(
              future: _getData(),
              builder: (ctx, snapshot) {
                // Checking if future is resolved
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  }

                  final events = (snapshot.hasData) ? snapshot.data as List<EventSummary> : List<EventSummary>.empty();
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (context) => EventDetailPage(
                                date: widget.date,
                                type: widget.type,
                                person: widget.person,
                              )),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EventsSummary(events, widget.date),
                    ),
                  );
                }
                return const HelseLoader();
              })
        ],
      ),
    );
  }
}
