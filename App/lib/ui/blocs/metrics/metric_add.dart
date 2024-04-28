import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/notification.dart';

import '../../../logic/event.dart';
import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/date_input.dart';
import '../common/text_input.dart';
import '../loader.dart';

class MetricAdd extends StatefulWidget {
  final List<MetricType> types;
  final void Function() callback;
  final int? person;

  const MetricAdd(this.types, this.callback, {super.key, this.person});

  @override
  State<MetricAdd> createState() => _MetricAddState();
}

class _MetricAddState extends State<MetricAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;

  DateTime _date = DateTime.now();
  String? _value;
  String? _tag;
  int? _type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
      title: const Text("Add"),
      actions: [
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: _status == SubmissionStatus.inProgress
              ? const HelseLoader()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
        ),
      ],
      content: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Manually add a new metric", style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  _TypeInput(
                      widget.types,
                      (value) => setState(() {
                            _type = value;
                          })),
                  const SizedBox(height: 10),
                  TextInput(Icons.add, "Value",
                      onChanged: (value) => setState(
                            () {
                              _value = value;
                            },
                          )),
                  const SizedBox(height: 10),
                  TextInput(Icons.design_services_outlined, "Tag",
                      onChanged: (value) => setState(() {
                            _tag = value;
                          })),
                  const SizedBox(height: 10),
                  DateInput(
                      "Date",
                      _date,
                      (value) => setState(() {
                            _date = value;
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    var localContext = context;
    try {
      if (AppState.metricsLogic != null) {
        setState(() {
          _status = SubmissionStatus.inProgress;
        });

        try {
          var metric = CreateMetric(date: _date, type: _type, tag: _tag, value: _value);
          await AppState.metricsLogic?.addMetric(metric, person: widget.person);

          if (localContext.mounted) {
            SuccessSnackBar.show("Metric added", localContext);
            Navigator.of(localContext).pop();
          }

          widget.callback();
          setState(() {
            _status = SubmissionStatus.success;
          });
        } catch (_) {
          setState(() {
            _status = SubmissionStatus.failure;
          });
        }
      }
    } catch (ex) {
      if (localContext.mounted) {
        ErrorSnackBar.show("Error: $ex", localContext);
      }
    }
  }
}

class _TypeInput extends StatelessWidget {
  final List<MetricType> types;
  final void Function(int?) callback;

  const _TypeInput(this.types, this.callback);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return DropdownButtonFormField(
      onChanged: callback,
      items: types.map((type) => DropdownMenuItem(value: type.id, child: Text(type.name ?? ""))).toList(),
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.list),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
    );
  }
}
