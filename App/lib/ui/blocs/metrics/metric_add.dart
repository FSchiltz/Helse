import 'package:flutter/material.dart';

import '../../../logic/d_i.dart';
import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/date_input.dart';
import '../../common/notification.dart';
import '../../common/square_dialog.dart';
import '../../common/square_text_field.dart';
import '../../common/loader.dart';

class MetricAdd extends StatefulWidget {
  final MetricType type;
  final void Function() callback;
  final int? person;
  final Metric? edit;

  const MetricAdd(this.type, this.callback, {super.key, this.person, this.edit});

  @override
  State<MetricAdd> createState() => _MetricAddState();
}

class _MetricAddState extends State<MetricAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;

  DateTime _date = DateTime.now();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _tag = TextEditingController();

  @override
  void initState() {
    super.initState();

    var edit = widget.edit;
    if (edit != null) {
      if (edit.date != null) _date = edit.date!.toLocal();
      _value.text = edit.$value ?? '';
      _tag.text = edit.tag ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return SquareDialog(
      title: Text("Add a new ${widget.type.name} value"),
      actions: [
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: _status == SubmissionStatus.inProgress
              ? const HelseLoader()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: const ContinuousRectangleBorder(),
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
                  SquareTextField(
                    theme: theme,
                    icon: Icons.add_sharp,
                    label: "Value",
                    controller: _value,
                  ),
                  const SizedBox(height: 20),
                  SquareTextField(
                    theme: theme,
                    icon: Icons.design_services_outlined,
                    label: "Tag",
                    controller: _tag,
                  ),
                  const SizedBox(height: 20),
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
      setState(() {
        _status = SubmissionStatus.inProgress;
      });

      try {
        if (widget.edit?.id != null) {
          var metric = UpdateMetric(
            id: widget.edit?.id ?? 0,
            date: _date.toUtc(),
            type: widget.type.id,
            tag: _tag.text,
            $value: _value.text,
            source: FileTypes.none,
          );
          await DI.metric.updateMetrics(metric, person: widget.person);
        } else {
          var metric = CreateMetric(
            date: _date.toUtc(),
            type: widget.type.id,
            tag: _tag.text,
            $value: _value.text,
            source: FileTypes.none,
          );
          await DI.metric.addMetrics(metric, person: widget.person);
        }

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }
        Notify.show("Metric added");

        widget.callback();
        setState(() {
          _status = SubmissionStatus.success;
        });
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }
}
