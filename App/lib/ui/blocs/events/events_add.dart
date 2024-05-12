import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_dialog.dart';

import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/date_input.dart';
import '../../common/text_input.dart';
import '../../common/loader.dart';

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
      var event = DI.event;
      if (event != null) {
        setState(() {
          _status = SubmissionStatus.inProgress;
        });

        try {
          var metric = CreateEvent(
              start: _start.toUtc(),
              stop: _stop.toUtc(),
              type: widget.type.id,
              description: _description);
          await event.addEvents(metric, person: widget.person);

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
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                TextInput(Icons.description_sharp, "Description",
                    onChanged: (value) => setState(() {
                          _description = value;
                        })),
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
