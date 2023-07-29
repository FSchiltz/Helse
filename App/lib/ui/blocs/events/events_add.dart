import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/event.dart';
import '../../../logic/events/events_bloc.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/text_input.dart';

class EventAdd extends StatelessWidget {
  final void Function() callback;
  final List<EventType> types;

  const EventAdd(this.callback, this.types, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("New Event"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) {
            return EventBloc();
          },
          child: BlocListener<EventBloc, EventState>(
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
                    Text("mannually add a new event", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    _TypeInput(types),
                    const SizedBox(height: 10),
                    _DescriptionInput(),
                    const SizedBox(height: 10),
                    _DateInput(EventBloc.dateStartEvent, "start"),
                    const SizedBox(height: 10),
                    _DateInput(EventBloc.dateEndEvent, "end"),
                    const SizedBox(height: 10),
                    _SubmitButton(callback),
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

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) => previous.description != current.description,
      builder: (context, state) {
        return TextInput(Icons.description_sharp, "Description", onChanged: (value) => context.read<EventBloc>().add(TextChangedEvent(value, EventBloc.descriptionEvent)));
      },
    );
  }
}

class _TypeInput extends StatelessWidget {
  final List<EventType> types;
  const _TypeInput(this.types);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (previous, current) => previous.type != current.type,
      builder: (context, state) {
        return DropdownButtonFormField(
          onChanged: (value) => context.read<EventBloc>().add(IntChangedEvent(value ?? 0, EventBloc.typeEvent)),
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
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  final String event;
  final String label;

  final TextEditingController _textController = TextEditingController();

  _DateInput(this.event, this.label);

  Future<void> _setDate(EventBloc read, BuildContext context) async {
    var date = await _pick(context);
    if (date != null) {
      String formattedDate = date.toString();
      read.add(DateChangedEvent(date, event));
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

  bool _checkChange(EventState previous, EventState current) {
    switch (event) {
      case EventBloc.dateStartEvent:
        return previous.start != current.start;

      case EventBloc.dateEndEvent:
        return previous.stop != current.stop;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: _checkChange,
      builder: (context, state) {
        return TextField(
          controller: _textController,
          onTap: () {
            _setDate(context.read<EventBloc>(), context);
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
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final void Function() callback;

  const _SubmitButton(this.callback);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
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
                onPressed: state.isValid
                    ? () {
                        context.read<EventBloc>().add(SubmittedEvent("", callback: () => Navigator.of(context).pop()));
                      }
                    : null,
                child: const Text('Submit'),
              );
      },
    );
  }
}
