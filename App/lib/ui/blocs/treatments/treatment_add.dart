import 'package:flutter/material.dart';
import 'package:helse/ui/theme/square_dialog.dart';

import '../../../logic/event.dart';
import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/date_input.dart';
import '../common/text_input.dart';
import '../../theme/loader.dart';
import '../../theme/notification.dart';

class TreatmentAdd extends StatefulWidget {
  final int? person;

  const TreatmentAdd({super.key, this.person});

  @override
  State<TreatmentAdd> createState() => _TreatementState();
}

class _TreatementState extends State<TreatmentAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  String? _description;
  int? _type;
  List<EventType>? _types;

  Future<List<EventType>?> _getTypes() async {
    if (_types != null) return _types;

    var model = await DI.treatement?.treatmentTypes();
    _types = model;

    return _types;
  }

  void _submit() async {
    var localContext = context;

    if (DI.treatement != null) {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });
      try {
        var event = CreateEvent(
            start: _start, stop: _stop, type: _type, description: _description);
        var treatment =
            CreateTreatment(events: [event], personId: widget.person);
        await DI.treatement?.addTreatment(treatment);

        setState(() {
          _status = SubmissionStatus.success;
        });

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }
        Notify.show("Treatment added");
      } catch (ex) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
        Notify.showError("Error: $ex");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SquareDialog(
      title: const Text("New Event"),
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
                Text("Manually add a new event",
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: _getTypes(),
                    builder: (ctx, snapshot) {
                      // Checking if future is resolved
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          var types = snapshot.data as List<EventType>;
                          return _TypeInput(
                              types,
                              (type) => setState(() {
                                    _type = type;
                                  }));
                        }
                      }
                      return const HelseLoader();
                    }),
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

class _TypeInput extends StatelessWidget {
  final List<EventType> types;
  final void Function(int?) callback;

  const _TypeInput(this.types, this.callback);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return DropdownButtonFormField(
      onChanged: callback,
      items: types
          .map((type) =>
              DropdownMenuItem(value: type.id, child: Text(type.name ?? "")))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.list_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border:
            OutlineInputBorder(borderSide: BorderSide(color: theme.primary)),
      ),
    );
  }
}
