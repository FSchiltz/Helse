import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/metrics/metric_bloc.dart';
import 'package:helse/logic/metrics/metrics_logic.dart';
import 'package:helse/services/swagger_generated_code/swagger.swagger.dart';

import '../text_input.dart';

class MetricAdd extends StatelessWidget {
  final List<MetricType> types;
  const MetricAdd(this.types, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Add"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) {
            return MetricBloc(types: types);
          },
          child: BlocListener<MetricBloc, MetricState>(
            listener: (context, state) {
              if (state.status == SubmissionStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Authentication Failure')),
                  );
              }
            },
            child: Form(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text("Add manual metric", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    _TypeInput(types),
                    const SizedBox(height: 10),
                    _ValueInput(),
                    const SizedBox(height: 10),
                    _TagInput(),
                    const SizedBox(height: 10),
                    _DateInput(),
                    const SizedBox(height: 10),
                    _SubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ValueInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricBloc, MetricState>(
      buildWhen: (previous, current) => previous.value != current.value,
      builder: (context, state) {
        return TextInput((value) => context.read<MetricBloc>().add(TextChangedEvent(value, MetricBloc.valueEvent)), Icons.add, "Value");
      },
    );
  }
}

class _TagInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricBloc, MetricState>(
      buildWhen: (previous, current) => previous.tag != current.tag,
      builder: (context, state) {
        return TextInput((value) => context.read<MetricBloc>().add(TextChangedEvent(value, MetricBloc.tagEvent)), Icons.design_services_outlined, "Tag");
      },
    );
  }
}

class _TypeInput extends StatelessWidget {
  final List<MetricType> types;
  const _TypeInput(this.types);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricBloc, MetricState>(
      buildWhen: (previous, current) => previous.type != current.type,
      builder: (context, state) {
        return DropdownButtonFormField(
          onChanged: (value) => context.read<MetricBloc>().add(IntChangedEvent(value ?? 0, MetricBloc.typeEvent)),
          items: types.map((type) => DropdownMenuItem(value: type.id, child: Text(type.name ?? ""))).toList(),
          decoration: InputDecoration(
            labelText: 'Type',
            prefixIcon: const Icon(Icons.list),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  Future<void> _setDate(MetricBloc read, BuildContext context) async {
    var date = await _pick(context);
    if (date != null) {
      String formattedDate = date.toString();
      read.add(DateChangedEvent(date, MetricBloc.dateEvent));
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
    return BlocBuilder<MetricBloc, MetricState>(
      buildWhen: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return TextField(
          controller: _textController,
          onTap: () {
            _setDate(context.read<MetricBloc>(), context);
          },
          decoration: InputDecoration(
            labelText: 'date',
            prefixIcon: const Icon(Icons.edit_calendar_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricBloc, MetricState>(
      builder: (context, state) {
        return state.status == SubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.isValid
                    ? () {
                        context.read<MetricBloc>().add(SubmittedEvent("", callback: () => Navigator.of(context).pop()));
                      }
                    : null,
                child: const Text('Submit'),
              );
      },
    );
  }
}
