import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../di/dependencies.dart';
import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/inputs/date_input.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import '../../common/layout/square_dialog.dart';

class EventAdd extends StatefulWidget {
  final void Function() callback;
  final EventType type;
  final int? person;
  final Event? edit;

  const EventAdd(this.callback, this.type, {super.key, this.person, this.edit});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  DateTime? _notification;
  final TextEditingController _description = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  bool _notify = false;

  void _submit() async {
    final locale = Translation.of(context);
    var localContext = context;
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });

      try {
        if (widget.edit != null) {
          var event = UpdateEvent(
            start: _start.toUtc(),
            stop: _stop.toUtc(),
            type: widget.type.id,
            description: _description.text,
            id: widget.edit?.id,
            notificationTime: _notify ? _notification?.toUtc() : null,
            source: widget.edit?.source,
            sourceId: widget.edit?.sourceId,
            tag: _tag.text,
          );
          await Dependencies.services.event.updateEvent(
            event,
            person: widget.person,
          );
        } else {
          var event = CreateEvent(
            start: _start.toUtc(),
            stop: _stop.toUtc(),
            type: widget.type.id,
            description: _description.text,
            notificationTime: _notify ? _notification?.toUtc() : null,
            source: FileTypes.none,
            sourceId: '',
            tag: _tag.text,
          );
          await Dependencies.services.event.addEvent(
            event,
            person: widget.person,
          );
        }
        widget.callback.call();
        setState(() {
          _status = SubmissionStatus.success;
        });

        if (localContext.mounted) {
          Notify.show(locale.added, localContext);
          Navigator.of(localContext).pop();
        }
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      if (localContext.mounted) {
        Notify.showError(locale.error(ex.toString()), localContext);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    var edit = widget.edit;
    if (edit != null) {
      _start = edit.start;
      _stop = edit.stop;
      _description.text = edit.description ?? '';
      _tag.text = edit.tag ?? '';
      _notify = edit.notificationTime != null;
      _notification = edit.notificationTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
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
              SquareTextField(
                icon: Icons.description_sharp,
                label: locale.description,
                controller: _description,
              ),
              const SizedBox(height: UIConstants.formPad),
              SquareTextField(
                icon: Icons.tag_sharp,
                label: locale.tag,
                controller: _tag,
              ),
              const SizedBox(height: UIConstants.formPad),
              DateInput(
                locale.start,
                _start,
                (date) => setState(() {
                  _start = date ?? DateTime.now();
                  _stop = _stop.isBefore(_start) ? _start : _stop;
                }),
              ),
              const SizedBox(height: UIConstants.formPad),
              DateInput(
                locale.end,
                _stop,
                (date) => setState(() {
                  _stop = date ?? DateTime.now();
                  _start = _start.isAfter(_stop) ? _stop : _start;
                }),
              ),
              const SizedBox(height: UIConstants.formPad),
              HelseSwitch(
                "Notify: ",
                _notify,
                (value) => setState(() {
                  _notify = value;
                }),
              ),

              if (_notify) const SizedBox(height: UIConstants.formPad),
              if (_notify)
                DateInput(
                  locale.notificationTime,
                  _notification,
                  (date) => setState(() {
                    _notification = date;
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
