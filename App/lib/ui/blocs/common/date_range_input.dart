import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeInput extends StatefulWidget {
  final void Function(DateTimeRange date) _setDateCallback;
  final DateTimeRange initial;

  const DateRangeInput(void Function(DateTimeRange date) setDate, this.initial,
      {super.key})
      : _setDateCallback = setDate;

  @override
  State<DateRangeInput> createState() => _DateRangeInputState();
}

class _DateRangeInputState extends State<DateRangeInput> {
  String _text = '';

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  void _displayDate(DateTimeRange date) {
    setState(() {
      _text = "${formatter.format(date.start)} - ${formatter.format(date.end)}";
    });
  }

  Future<void> _setDate(BuildContext context, DateTimeRange initial) async {
    var date = await _pick(context, initial);
    if (date != null) {
      _displayDate(date);
      widget._setDateCallback(date);
    }
  }

  Future<DateTimeRange?> _pick(
      BuildContext context, DateTimeRange initial) async {
    var selectedDate = await showDateRangePicker(
        context: context,
        initialDateRange: initial, //get today's date
        firstDate: DateTime(1000),
        lastDate: DateTime(3000));
    if (selectedDate == null) return null;

    var start = selectedDate.start;
    var end = selectedDate.end;

    return DateTimeRange(
        start: start, end: DateTime(end.year, end.month, end.day, 23, 59, 59));
  }

  @override
  void initState() {
    super.initState();
    _displayDate(widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        _setDate(context, widget.initial);
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
          Flexible(child: Text(_text, style: theme.textTheme.bodyMedium, overflow: TextOverflow.fade,)),
        ],
      ),
    );
  }
}
