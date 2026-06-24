import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/event_search.dart';

class EventSearchButton extends StatelessWidget {
  final EventType type;
  final int? person;
  const EventSearchButton(this.type, {super.key, this.person});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 32,
        child: IconButton(
          onPressed: () => _open(context),
          icon: const Icon(Icons.search_sharp),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EventSearch(type, person: person),
      ),
    );
  }
}
