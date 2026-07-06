import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/inputs/enabled_input.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/date_input.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EventsEdit extends StatefulWidget {
  final EventType type;
  final void Function() callback;
  final int? person;
  final List<Event> edit;
  const EventsEdit(
    this.type,
    this.callback, {
    super.key,
    this.person,
    required this.edit,
  });

  @override
  State<EventsEdit> createState() => _EventsEditState();
}

class _EventsEditState extends PopupSubmitState<EventsEdit> {
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  bool _updateDescription = false;
  bool _updateTag = false;
  bool _updateStart = false;
  bool _updateStop = false;

  Future<void> _submit() async {
    final patch = PatchEvent(
      type: widget.type.id,
      start: _start,
      updateStart: _updateStart,
      stop: _stop,
      updateStop: _updateStop,
      description: _description.text,
      updateDescription: _updateDescription,
      tag: _tag.text,
      updateTag: _updateTag,
      source: ImportTypes.none,
      ids: widget.edit.map((e) => e.id).toList(),
    );

    await Dependencies.services.event.updateEvents(
      patch,
      person: widget.person,
    );
    widget.callback.call();
  }

  @override
  void dispose() {
    _description.dispose();
    _tag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      icon: const Icon(Icons.edit_note),
      title: Text(
        locale.bulkEvent(widget.edit.length),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [submitButton(locale.submit, _submit)],
      content: SingleChildScrollView(
        child: Column(
          spacing: UIConstants.formPad,
          children: [
            EnabledInput(
              label: locale.description,
              enabled: _updateDescription,
              onChanged: (v) => setState(() => _updateDescription = v),
              child: SquareTextField(
                icon: Icons.description_sharp,
                label: locale.description,
                controller: _description,
              ),
            ),

            EnabledInput(
              label: locale.tag,
              enabled: _updateTag,
              onChanged: (v) => setState(() => _updateTag = v),
              child: SquareTextField(
                icon: Icons.tag_sharp,
                label: locale.tag,
                controller: _tag,
              ),
            ),
            EnabledInput(
              label: locale.start,
              enabled: _updateStart,
              onChanged: (v) => setState(() => _updateStart = v),
              child: DateInput(
                locale.start,
                _start,
                (date) => setState(() {
                  _start = date ?? DateTime.now();
                  _stop = _stop.isBefore(_start) ? _start : _stop;
                }),
              ),
            ),
            EnabledInput(
              label: locale.stop,
              enabled: _updateStop,
              onChanged: (v) => setState(() {
                _updateStop = v;
              }),
              child: DateInput(
                locale.end,
                _stop,
                (date) => setState(() {
                  _stop = date ?? DateTime.now();
                  _start = _start.isAfter(_stop) ? _stop : _start;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
