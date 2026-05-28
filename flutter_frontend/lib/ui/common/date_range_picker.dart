import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/date_range_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

class DateRangePicker extends StatelessWidget {
  final void Function(DateTimeRange value) setDate;
  final DateTimeRange initial;
  final DateTimeRange? range;

  const DateRangePicker(this.setDate, this.initial, {this.range, super.key});

  @override
  Widget build(BuildContext context) {
    List<MenuItemButton> presets = DatePreset.values
        .map(
          (v) => MenuItemButton(
            onPressed: () => _setPreset(v),
            child: Text(Translation.get(v)),
          ),
        )
        .toList();
    var preset = range;
    if (preset != null) {
      presets.add(
        MenuItemButton(
          onPressed: () => setDate(preset),
          child: Text('Initial range'),
        ),
      );
    }
    var isLargeScreen =
        MediaQuery.of(context).size.width > UIConstants.displaySmall;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: IconButton(
            onPressed: (_previousIsBefore()) ? null : _previousPeriod,
            icon: const Icon(Icons.skip_previous_sharp),
          ),
        ),
        MenuAnchor(
          menuChildren: presets,
          builder: (context, controller, child) => IconButton(
            iconSize: isLargeScreen ? 24 : 22,
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
        DateRangeInput(
          _callBack,
          initial,
          isLargeScreen,
          showIcon: false,
          range: range,
        ),
        SizedBox(
          child: IconButton(
            onPressed: (_nextIsAfter()) ? null : _nextPeriod,
            icon: const Icon(Icons.skip_next_sharp),
          ),
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

    if (value == DatePreset.today ||
        value == DatePreset.week ||
        value == DatePreset.month) {
      DI.settings.setDateRange(value);
    }
  }

  bool _previousIsBefore() {
    var start = range?.start;
    if (start == null) {
      return false;
    }

    var duration = Duration(seconds: _getDurationToMove().inSeconds * -1);
    var end = initial.end.add(duration);
    return start == end || end.isBefore(start);
  }

  bool _nextIsAfter() {
    var end = range?.end;
    if (end == null) {
      return false;
    }

    var duration = _getDurationToMove();
    var start = initial.start.add(duration);
    return start == end || start.isAfter(end);
  }
}
