import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';

class DateInput extends StatelessWidget {
  final String label;
  final DateTime? date;

  final TextEditingController _textController = TextEditingController();

  final void Function(DateTime? time) callback;

  DateInput(this.label, this.date, this.callback, {super.key}) {
    _textController.text = date == null ? label : DateHelper.format(date);
  }

  Future<void> _setDate(BuildContext context) async {
    var date = await _pick(context);
    if (date != null) {
      callback(date);
      var text = DateHelper.format(date);
      _textController.text = text;
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
    var theme = Theme.of(context).colorScheme;

    return TextField(
      controller: _textController,
      onTap: () {
        _setDate(context);
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.edit_calendar_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
    );
  }
}
