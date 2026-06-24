import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/events/event_add_button.dart';
import 'package:helse/ui/blocs/events/event_graph.dart';
import 'package:helse/ui/blocs/events/event_search_button.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../../di/dependencies.dart';
import '../../../../services/swagger/generated_code/helseapi.swagger.dart';

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
    return await Dependencies.services.event.events(
          widget.type.id,
          widget.date.start,
          widget.date.end,
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
    var locale = Translation.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          EventSearchButton(widget.type, person: widget.person),
          EventAddButton(widget.type, _resetEvents, person: widget.person),
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
            range: widget.date,
            person: widget.person,
            type: widget.type,
            events: data,
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
