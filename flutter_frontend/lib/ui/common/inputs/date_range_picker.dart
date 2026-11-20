import 'package:material_ui/material_ui.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:helse/ui/common/inputs/date_range_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

class DateRangePicker extends StatelessWidget {
  final void Function(DateTimeRange value) setDate;
  final DateTimeRange selected;
  final DateTimeRange? range;
  final DateTimeRange? initial;
  final String? offset;

  const DateRangePicker(
    this.setDate,
    this.selected, {
    this.range,
    this.initial,
    super.key,
    this.offset,
  });

  @override
  Widget build(BuildContext context) {
    List<MenuItemButton> presets = DatePreset.values
        .where(
          (e) =>
              e.index > 0 &&
              _isInRange(
                e,
                range ??
                    DateTimeRange(start: DateTime(1000), end: DateTime(3000)),
              ),
        )
        .map(
          (v) => MenuItemButton(
            onPressed: () => _setPreset(v),
            child: Text(Translation.get(v, context)),
          ),
        )
        .toList();
    var preset = initial;
    if (preset != null) {
      presets.add(
        MenuItemButton(
          onPressed: () => setDate(preset),
          child: Text(Translation.of(context).initialrange),
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
          selected,
          isLargeScreen,
          showIcon: false,
          range:
              range ??
              DateTimeRange(start: DateTime(1000), end: DateTime(3000)),
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
    var start = selected.start.add(duration);
    var end = selected.end.add(duration);
    _callBack(DateTimeRange(start: start, end: end));
  }

  void _previousPeriod() {
    var duration = _getDurationToMove();
    var start = selected.start.subtract(duration);
    var end = selected.end.subtract(duration);
    _callBack(DateTimeRange(start: start, end: end));
  }

  Duration _getDurationToMove() {
    return selected.end.difference(selected.start);
  }

  void _callBack(DateTimeRange date) {
    setDate(date);
  }

  void _setPreset(DatePreset? value) {
    if (value == null) return;

    setDate(DateHelper.getRange(value, offset));

    Dependencies.logics.settings.setDateRange(value, toServer: false);
  }

  bool _previousIsBefore() {
    var start = range?.start;
    if (start == null) {
      return false;
    }

    var duration = Duration(seconds: _getDurationToMove().inSeconds * -1);
    var end = selected.end.add(duration);
    return start == end || end.isBefore(start);
  }

  bool _nextIsAfter() {
    var end = range?.end;
    if (end == null) {
      return false;
    }

    var duration = _getDurationToMove();
    var start = selected.start.add(duration);
    return start == end || start.isAfter(end);
  }

  bool _isInRange(DatePreset value, DateTimeRange<DateTime> range) {
    var other = DateHelper.getRange(value, offset);
    return !other.start.isBefore(range.start) && !other.end.isAfter(range.end);
  }
}
