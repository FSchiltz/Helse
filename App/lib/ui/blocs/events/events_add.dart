import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/notification.dart';

import '../../../logic/event.dart';
import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/date_input.dart';
import '../common/text_input.dart';
import '../loader.dart';

class EventAdd extends StatefulWidget {
  final void Function() callback;
  final EventType type;
  final int? person;

  const EventAdd(this.callback, this.type, {super.key, this.person});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  String? _description;

  void _submit() async {
    var localContext = context;
    try {
    if (AppState.metricsLogic != null) {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });
      try {
        var metric = CreateEvent(start: _start, stop: _stop, type: widget.type.id, description: _description);
        await AppState.eventLogic?.addEvent(metric, person: widget.person);

        widget.callback.call();
        setState(() {
          _status = SubmissionStatus.success;
        });

        if (localContext.mounted) {
          SuccessSnackBar.show("Event Added", localContext);
          Navigator.of(localContext).pop();
        }
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    }} catch (ex) {
      if (localContext.mounted) {
        ErrorSnackBar.show("Error: $ex", localContext);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
      title: const Text("New Event"),
      actions: [
        SizedBox(
          child: _status == SubmissionStatus.inProgress
              ? const HelseLoader()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                Text("Manually add ${widget.type.name}", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                TextInput(Icons.description_sharp, "Description",
                    onChanged: (value) => setState(() {
                          _description = value;
                        })),
                const SizedBox(height: 10),
                DateInput(
                    "start",
                    _start,
                    (date) => setState(() {
                          _start = date;
                        })),
                const SizedBox(height: 10),
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
