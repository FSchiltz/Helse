import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/ui/common/date_range_input.dart';

enum DatePreset {
  today,
  week,
  month,
  trimestre,
  halfYear,
  year,
  yearToDate,
}

class DateRangePicker extends StatelessWidget {
  final void Function(DateTimeRange value) setDate;
  final DateTimeRange initial;

  DateRangePicker(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MenuAnchor(
            menuChildren: [
              MenuItemButton(onPressed: () => _setPreset(DatePreset.today), child: Text("Today")),
            ],
            builder: (context, controller, child) => InkWell(
              child: const Icon(Icons.calendar_month_sharp),
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            ),
          ),
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

  void _setPreset(DatePreset? value) {
    if (value == null) return;

    switch (value) {
      case DatePreset.today:
        setDate(DateHelper.now());
        break;
      default:
        break;
    }
  }
}
