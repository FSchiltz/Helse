import 'package:flutter/material.dart';
import 'package:helse/ui/common/date_range_input.dart';

class DateRangePicker extends StatelessWidget {
  final void Function(DateTimeRange value) setDate;
  final DateTimeRange initial;

  const DateRangePicker(
    this.setDate,
    this.initial, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: IconButton(onPressed: _previousPeriod, icon: const Icon(Icons.skip_previous_sharp)),
        ),
        Flexible(child: DateRangeInput(_callBack, initial)),
        SizedBox(
          width: 50,
          child: IconButton(onPressed: _nextPeriod, icon: const Icon(Icons.skip_next_sharp)),
        ),
      ],
    );
  }

  void _nextPeriod() {
    var duration = _getDurationToMove();
    var start = initial.start.add(duration);
    var end = initial.end.add(duration);
    _callBack(DateTimeRange(start: start, end: end));
  }

  void _previousPeriod() {
    var duration = Duration(seconds: _getDurationToMove().inSeconds * -1);
    var start = initial.start.add(duration);
    var end = initial.end.add(duration);
    _callBack(DateTimeRange(start: start, end: end));
  }

  Duration _getDurationToMove() {
    return initial.end.difference(initial.start);
  }

  void _callBack(DateTimeRange date) {
    setDate(date);
  }
}
