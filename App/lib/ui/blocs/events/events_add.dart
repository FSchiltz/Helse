import 'package:flutter/material.dart';
import 'package:helse/ui/common/square_text_field.dart';

import '../../../logic/d_i.dart';
import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/date_input.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import '../../common/square_dialog.dart';

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
  final TextEditingController _description = TextEditingController();

  void _submit() async {
    var localContext = context;
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });

      try {
        if (widget.edit?.id != null) {
          var event = UpdateEvent(
            start: _start.toUtc(),
            stop: _stop.toUtc(),
            type: widget.type.id,
            description: _description.text,
            id: widget.edit?.id,
          );
          await DI.event.updateEvent(event, person: widget.person);
        } else {
          var event = CreateEvent(
            start: _start.toUtc(),
            stop: _stop.toUtc(),
            type: widget.type.id,
            description: _description.text,
          );
          await DI.event.addEvent(event, person: widget.person);
        }
        widget.callback.call();
        setState(() {
          _status = SubmissionStatus.success;
        });

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }

        Notify.show("Event Added");
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  void initState() {
    super.initState();

    var edit = widget.edit;
    if (edit != null) {
      if (edit.start != null) _start = edit.start ?? _start;

      if (edit.stop != null) _stop = edit.stop ?? _stop;

      _description.text = edit.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return SquareDialog(
      title: Text("Add a new ${widget.type.name ?? "Event"}"),
      actions: [
        SizedBox(
          child: _status == SubmissionStatus.inProgress
              ? const HelseLoader()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: const ContinuousRectangleBorder(),
                  ),
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
        )
      ],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SquareTextField(
                  theme: theme,
                  icon: Icons.description_sharp,
                  label: "Description",
                  controller: _description,
                ),
                const SizedBox(height: 20),
                DateInput(
                    "start",
                    _start,
                    (date) => setState(() {
                          _start = date;
                        })),
                const SizedBox(height: 20),
                DateInput(
                    "end",
                    _stop,
                    (date) => setState(() {
                          _stop = date;
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
