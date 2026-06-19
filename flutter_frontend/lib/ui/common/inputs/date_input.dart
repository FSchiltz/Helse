import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';

class DateInput extends StatefulWidget {
  final String label;
  final DateTime? initdate;

  final void Function(DateTime? time) callback;

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

  Future<void> _setTime(BuildContext context) async {
    var picked = await _pickTime(context);

    var existing = date ?? DateTime.now();
    var newDate = picked == null
        ? null
        : DateTime(
            existing.year,
            existing.month,
            existing.day,
            picked.hour,
            picked.minute,
          );

    if (newDate != null) {
      widget.callback(newDate);
    }

    setState(() {
      date = newDate;
    });
  }

  Future<void> _setDate(BuildContext context) async {
    var picked = await _pickDate(context);

    var existing = date ?? DateTime.now();
    var newDate = picked == null
        ? null
        : DateTime(
            picked.year,
            picked.month,
            picked.day,
            existing.hour,
            existing.minute,
          );

    if (newDate != null) {
      widget.callback(newDate);
    }

    setState(() {
      date = newDate;
    });
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1000),
      lastDate: DateTime(3000),
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    return selectedDate;
  }

  Future<TimeOfDay?> _pickTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date ?? DateTime.now()),
    );

    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 330),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SquareTextField(
              controller: TextEditingController(
                text: DateHelper.formatDate(date, context: context),
              ),
              onTap: () {
                _setDate(context);
              },
              icon: Icons.edit_calendar_sharp,
              label: widget.label,
            ),
          ),
          Flexible(
            child: SquareTextField(
              controller: TextEditingController(
                text: DateHelper.formatTime(date, context: context),
              ),
              onTap: () {
                _setTime(context);
              },
              icon: Icons.watch_later_sharp,
              label: '',
            ),
          ),
        ],
      ),
    );
  }
}
