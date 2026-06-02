import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/delete_event.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';
import 'package:helse/ui/common/date_range_picker.dart';

class EventsGraph extends StatefulWidget {
  final DateTimeRange date;
  final EventType type;
  final int? person;
  final List<Event> data;
  final void Function() reset;

  const EventsGraph({
    super.key,
    required this.date,
    required this.type,
    required this.person,
    required this.data,
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
    var filter = widget.data
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
    subDate = widget.date;
    filteredEvents = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    var event = _event;
    var id = _event?.id;
    var locale = Translation.locale(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateRangePicker(_setDate, subDate, range: widget.date),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: EventsTimelineGraph(
            filteredEvents,
            subDate,
            _selectionChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            shadowColor: Theme.of(context).colorScheme.shadow,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Selected${event != null ? ' (${event.id})' : ''}:',
                    ),
                  ),
                  if (event != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(event.description.toString()),
                    ),
                  if (event != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        locale.range(
                          DateHelper.format(
                            event.start.toLocal(),
                            context: context,
                          ),
                          DateHelper.format(
                            event.stop.toLocal(),
                            context: context,
                          ),
                        ),
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
                                await Dependencies.services.event.deleteEvent(
                                  id,
                                );
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
        ),
      ],
    );
  }
}
