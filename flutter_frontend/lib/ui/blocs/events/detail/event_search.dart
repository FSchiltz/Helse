import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/event_data_table.dart';
import 'package:helse/ui/common/inputs/date_input.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EventSearch extends StatefulWidget {
  final EventType type;
  final int? person;
  const EventSearch(this.type, {super.key, this.person});

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  List<Event> _events = [];
  final TextEditingController _value = TextEditingController();
  bool _working = false;
  DateTime? _from;
  DateTime? _to;

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(locale.searchItem(widget.type.name))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.formPad),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: UIConstants.formPad,
                  runSpacing: UIConstants.formPad,
                  children: [
                    Expanded(
                      child: SquareTextField(
                        icon: Icons.add_sharp,
                        label: locale.value,
                        controller: _value,
                      ),
                    ),
                    DateInput(locale.start, _from, (v) => _from = v),
                    DateInput(locale.stop, _to, (v) => _to = v),
                    IconButton(
                      onPressed: (_working) ? null : _search,
                      icon: Icon(Icons.search_sharp),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.formPad),
                if (_working) HelseLoader(),
                EventDataTable(
                  events: _events,
                  person: widget.person,
                  type: widget.type,
                  reset: _search,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _search() async {
    setState(() {
      _working = true;
    });
    try {
      final text = (_value.text.isEmpty) ? null : _value.text;
      var events = await Dependencies.services.event.searchEvents(
        widget.person,
        SearchEvent(type: widget.type.id, value: text, from: _from, to: _to),
      );
      setState(() {
        _events = events ?? [];
      });
    } finally {
      setState(() {
        _working = false;
      });
    }
  }
}
