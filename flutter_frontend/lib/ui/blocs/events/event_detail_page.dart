import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/events/event_graph.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'events_add.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.date,
    required this.type,
    required this.person,
  });

  final DateTimeRange date;
  final EventType type;
  final int? person;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Future<List<Event>> _getData(bool refresh) async {
    var date = widget.date;
    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(
      date.end.year,
      date.end.month,
      date.end.day,
    ).add(const Duration(days: 1));

    return await Dependencies.services.event.events(
          widget.type.id,
          start,
          end,
          person: widget.person,
        ) ??
        [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.locale(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 32,
              child: IconButton(
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
            ),
          ),
        ],
        title: Text(
          locale.detailof(widget.type.name),
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: LoadingBuilder(
        _getData,
        builder: (context, data, reset) {
          return EventsGraph(
            date: widget.date,
            person: widget.person,
            type: widget.type,
            data: data,
            reset: reset,
          );
        },
      ),
    );
  }

  void _resetEvents() {
    setState(() {
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;
}
