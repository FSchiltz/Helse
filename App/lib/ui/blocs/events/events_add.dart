import 'package:flutter/material.dart';

import '../../../logic/event.dart';
import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/text_input.dart';

class EventAdd extends StatefulWidget {
  final void Function() callback;
  final List<EventType> types;

  const EventAdd(this.callback, this.types, {super.key});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;
  DateTime? _start;
  DateTime? _stop;
  String? _description;
  int? _type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
      title: const Text("New Event"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text("mannually add a new event", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                _TypeInput(
                    widget.types,
                    (type) => setState(() {
                          _type = type;
                        })),
                const SizedBox(height: 10),
                TextInput(Icons.description_sharp, "Description",
                    onChanged: (value) => setState(() {
                          _description = value;
                        })),
                const SizedBox(height: 10),
                _DateInput(
                    "start",
                    _start,
                    (date) => setState(() {
                          _start = date;
                        })),
                const SizedBox(height: 10),
                _DateInput(
                    "end",
                    _stop,
                    (date) => setState(() {
                          _stop = date;
                        })),
                const SizedBox(height: 10),
                _status == SubmissionStatus.inProgress
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          if (AppState.metricsLogic != null) {
                            setState(() {
                              _status = SubmissionStatus.inProgress;
                            });
                            try {
                              var metric = CreateEvent(start: _start, stop: _stop, type: _type, description: _description);
                              await AppState.eventLogic?.addEvent(metric);

                              widget.callback.call();
                              setState(() {
                                _status = SubmissionStatus.success;
                              });

                              Navigator.of(context).pop();
                            } catch (_) {
                              setState(() {
                                _status = SubmissionStatus.failure;
                              });
                            }
                          }
                        },
                        child: const Text('Submit'),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeInput extends StatelessWidget {
  final List<EventType> types;
  final void Function(int?) callback;

  const _TypeInput(this.types, this.callback);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      onChanged: callback,
      items: types.map((type) => DropdownMenuItem(value: type.id, child: Text(type.name ?? ""))).toList(),
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.list_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _DateInput extends StatelessWidget {
  final String label;
  final DateTime? date;

  final TextEditingController _textController = TextEditingController();

  final void Function(DateTime? time) callback;

  _DateInput(this.label, this.date, this.callback) {
    _textController.text = date?.toString() ?? label;
  }

  Future<void> _setDate(BuildContext context) async {
    var date = await _pick(context);
    if (date != null) {
      String formattedDate = date.toString();

      callback(date);
      _textController.text = formattedDate;
    }
  }

  Future<DateTime?> _pick(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime(1000),
        lastDate: DateTime(3000));

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onTap: () {
        _setDate(context);
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.edit_calendar_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
