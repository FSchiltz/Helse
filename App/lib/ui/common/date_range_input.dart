import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeInput extends StatelessWidget {
  final void Function(DateTimeRange date) _setDateCallback;
  final DateTimeRange initial;
  final DateTimeRange? range;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  DateRangeInput(void Function(DateTimeRange date) setDate, this.initial, {super.key, this.range}) : _setDateCallback = setDate;

  String _displayDate(DateTimeRange date) {
    return "${formatter.format(date.start)} - ${formatter.format(date.end)}";
  }

  Future<void> _setDate(BuildContext context, DateTimeRange initial) async {
    var date = await _pick(context, initial);
    if (date != null) {
      _setDateCallback(date);
    }
  }

  Future<DateTimeRange?> _pick(BuildContext context, DateTimeRange initial) async {
    var selectedDate = await showDateRangePicker(
        context: context,
        initialDateRange: initial, //get today's date
        firstDate: range?.start ?? DateTime(1000),
        lastDate: range?.end ?? DateTime(3000));
    if (selectedDate == null) return null;

    var start = selectedDate.start;
    var end = selectedDate.end;

    return DateTimeRange(start: start, end: DateTime(end.year, end.month, end.day, 23, 59, 59));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        _setDate(context, initial);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.edit_calendar_sharp,
              color: theme.colorScheme.primary,
            ),
          ),
          Flexible(
              child: Text(
            _displayDate(initial),
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.fade,
          )),
        ],
      ),
    );
  }
}
