import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/event_data_table.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.searchItem(widget.type.name)),
      content: SizedBox(
        height: 500,
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SquareTextField(
                    icon: Icons.add_sharp,
                    label: locale.value,
                    controller: _value,
                  ),
                ),
                IconButton(
                  onPressed: (_working) ? null : _search,
                  icon: Icon(Icons.search_sharp),
                ),
              ],
            ),
            SizedBox(height: UIConstants.formPad),
            if (_working) HelseLoader(),
            Expanded(
              child: SingleChildScrollView(
                child: EventDataTable(
                  events: _events,
                  person: widget.person,
                  type: widget.type,
                  reset: _search,
                ),
              ),
            ),
          ],
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
        SearchEvent(type: widget.type.id, value: text),
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
