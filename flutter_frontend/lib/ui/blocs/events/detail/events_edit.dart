import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/inputs/date_input.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
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

class _EventsEditState extends State<EventsEdit> {
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  bool _updateDescription = false;
  bool _updateTag = false;
  bool _updateStart = false;
  bool _updateStop = false;

  SubmissionStatus _status = SubmissionStatus.initial;

  Future<void> _submit() async {
    if (_status == SubmissionStatus.inProgress) {
      return;
    }
    final locale = Translation.of(context);
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });

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
        source: FileTypes.none,
        ids: widget.edit.map((e) => e.id).toList(),
      );

      await Dependencies.services.event.updateEvents(
        patch,
        person: widget.person,
      );
      widget.callback.call();

      if (!mounted) {
        return;
      }

      setState(() {
        _status = SubmissionStatus.success;
      });

      Notify.show(locale.added, context);
      Navigator.of(context).pop();
    } catch (ex) {
      setState(() {
        _status = SubmissionStatus.failure;
      });
      if (mounted) {
        Notify.showError(locale.error(ex.toString()), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.addItem(widget.type.name)),
      actions: [
        _status == SubmissionStatus.inProgress
            ? const HelseLoader()
            : SquareButton(locale.submit, _submit),
      ],
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('${widget.edit.length} events'),
              const SizedBox(height: UIConstants.formPad),

              HelseSwitch(
                locale.description,
                _updateDescription,
                (v) => setState(() {
                  _updateDescription = v;
                }),
              ),
              if (_updateDescription)
                SquareTextField(
                  icon: Icons.description_sharp,
                  label: locale.description,
                  controller: _description,
                ),

              const SizedBox(height: UIConstants.formPad),
              HelseSwitch(
                locale.tag,
                _updateTag,
                (v) => setState(() {
                  _updateTag = v;
                }),
              ),
              if (_updateTag)
                SquareTextField(
                  icon: Icons.tag_sharp,
                  label: locale.tag,
                  controller: _tag,
                ),
              const SizedBox(height: UIConstants.formPad),
              HelseSwitch(
                locale.start,
                _updateStart,
                (v) => setState(() {
                  _updateStart = v;
                }),
              ),
              if (_updateStart)
                DateInput(
                  locale.start,
                  _start,
                  (date) => setState(() {
                    _start = date ?? DateTime.now();
                    _stop = _stop.isBefore(_start) ? _start : _stop;
                  }),
                ),
              const SizedBox(height: UIConstants.formPad),
              HelseSwitch(
                locale.stop,
                _updateStop,
                (v) => setState(() {
                  _updateStop = v;
                }),
              ),
              if (_updateStop)
                DateInput(
                  locale.end,
                  _stop,
                  (date) => setState(() {
                    _stop = date ?? DateTime.now();
                    _start = _start.isAfter(_stop) ? _stop : _start;
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
