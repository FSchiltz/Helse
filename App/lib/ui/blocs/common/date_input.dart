import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';

class DateInput extends StatefulWidget {
  final String label;
  final DateTime initdate;

  final void Function(DateTime time) callback;

  const DateInput(this.label, this.initdate, this.callback, {super.key});

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? date;

  @override
  void initState() {
    super.initState();
    date = widget.initdate;
  }

  Future<void> _setDate(BuildContext context) async {
    var picked = await _pick(context);
    if (picked != null) {
      widget.callback(picked);
    }

    setState(() {
      date = picked;
    });
  }

  Future<DateTime?> _pick(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: date,
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
    var theme = Theme.of(context).colorScheme;

    return TextField(
      controller: TextEditingController(text: DateHelper.format(date, context: context)),
      onTap: () {
        _setDate(context);
      },
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.edit_calendar_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
    );
  }
}
