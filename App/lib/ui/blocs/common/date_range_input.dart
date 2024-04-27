import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeInput extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final void Function(DateTimeRange date) _setDateCallback;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateTimeRange initial;

  DateRangeInput(void Function(DateTimeRange date) setDate, this.initial, {super.key}) : _setDateCallback = setDate {
    _displayDate(initial);
  }

  void _displayDate(DateTimeRange date) {
    _textController.text = "${formatter.format(date.start)} - ${formatter.format(date.end)}";
  }

  Future<void> _setDate(BuildContext context, DateTimeRange initial) async {
    var date = await _pick(context, initial);
    if (date != null) {
      _displayDate(date);
      _setDateCallback(date);
    }
  }

  Future<DateTimeRange?> _pick(BuildContext context, DateTimeRange initial) async {
    var selectedDate = await showDateRangePicker(
        context: context,
        initialDateRange: initial, //get today's date
        firstDate: DateTime(1000),
        lastDate: DateTime(3000));
    if (selectedDate == null) return null;

    var start = selectedDate.start;
    var end = selectedDate.end;

    return DateTimeRange(start: start, end: DateTime(end.year, end.month, end.day, 23, 59, 59));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      width: 220,
      height: 50,
      child: TextField(
        controller: _textController,
        onTap: () {
          _setDate(context, initial);
        },
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.colorScheme.surface,
          prefixIcon: Icon(
            Icons.edit_calendar_sharp,
            color: theme.colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
