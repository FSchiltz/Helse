import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/common/ui_constants.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvent<T> {
  final DateTime from;
  final DateTime to;
  final T value;

  CalendarEvent({required this.from, required this.to, required this.value});
}

class CalendarGroup<T> {
  final String name;
  final List<CalendarEvent<T>> events;

  CalendarGroup({required this.name, required this.events});
}

class CalendarView<T> extends StatefulWidget {
  final DateTimeRange date;
  final CalendarFormat format;
  final bool compact;
  final Widget Function(BuildContext, CalendarEvent<T>) build;

  final Future<List<CalendarGroup<T>>> Function(DateTime) loadEvents;
  final List<CalendarEvent<T>> Function(DateTime)? getEvents;

  const CalendarView(
    this.loadEvents,
    this.date, {
    super.key,
    this.getEvents,
    this.format = CalendarFormat.month,
    this.compact = false,
    required this.build,
  });

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T> extends State<CalendarView<T>> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarGroup<T>> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      var events = await widget.loadEvents(selectedDay);
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = events;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _calendarFormat = widget.format;

    if (_focusedDay.compareTo(widget.date.start) < 0) {
      _focusedDay = widget.date.start;
    }

    _onDaySelected(_focusedDay, _focusedDay);

    if (widget.date.duration.inDays <= 7) {
      _calendarFormat = CalendarFormat.twoWeeks;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var locale = Translation.of(context);

    return Column(
      spacing: UIConstants.formPad,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.date.duration.inHours > 24)
          TableCalendar<CalendarEvent<T>>(
            eventLoader: widget.getEvents,
            firstDay: widget.date.start,
            lastDay: widget.date.end,
            focusedDay: _focusedDay,
            loadEventsForDisabledDays: false,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => setState(() {
              _calendarFormat = format;
            }),
            availableGestures: AvailableGestures.all,
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,
              //selectedDecoration: BoxDecoration(color: Colors.red),
              outsideDaysVisible: false,
            ),
            rangeSelectionMode: RangeSelectionMode.enforced,
            headerStyle: HeaderStyle(
              formatButtonVisible: !widget.compact,
              titleCentered: widget.compact,
            ),
            onDaySelected: _onDaySelected,
          ),
        Container(
          margin: EdgeInsets.only(left: UIConstants.headerPad),
          child: Text(
            "Showing events of ${DateHelper.formatDate(_selectedDay, context: context)}",
            style: theme.titleLarge,
          ),
        ),
        if (_selectedEvents.isEmpty)
          Center(child: Text(locale.nodata, style: theme.titleSmall)),
        if (_selectedEvents.isNotEmpty)
          Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: _selectedEvents.length,
              shrinkWrap: true,
              itemBuilder: (x, index) {
                var item = _selectedEvents[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: UIConstants.formPad),
                  padding: EdgeInsets.only(left: UIConstants.formPad),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Dependencies.theme.stateColor(
                          item.name,
                          StateType.person,
                          context,
                        ),
                        width: 4,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.name.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: UIConstants.textPad),
                          child: Text(item.name, style: theme.headlineSmall),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: item.events.length,
                        itemBuilder: (x, index) =>
                            widget.build(x, item.events[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
