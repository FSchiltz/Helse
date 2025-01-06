import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/settings/settings_logic.dart';
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
  final bool large;

  const DateRangePicker(
    this.setDate,
    this.initial,
    this.large, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: IconButton(onPressed: _previousPeriod, icon: const Icon(Icons.skip_previous_sharp)),
        ),
        MenuAnchor(
          menuChildren: DatePreset.values.map((v) => MenuItemButton(onPressed: () => _setPreset(v), child: Text(Translation.get(v)))).toList(),
          builder: (context, controller, child) => IconButton(
            iconSize: large ? 24 : 22,
            icon: const Icon(Icons.calendar_month_sharp),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
          ),
        ),
        DateRangeInput(_callBack, initial, large, showIcon: false),
        SizedBox(
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

    setDate(DateHelper.getRange(value));

    if (value == DatePreset.today || value == DatePreset.week || value == DatePreset.month) {
      SettingsLogic.setDateRange(value);
    }
  }
}
