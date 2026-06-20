import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/ui_constants.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvent {
  final DateTime from;
  final DateTime to;
  final String value;

  CalendarEvent({required this.from, required this.to, required this.value});
}

class CalendarGroup {
  final String name;
  final List<CalendarEvent> events;

  CalendarGroup({required this.name, required this.events});
}

class CalendarView extends StatefulWidget {
  final DateTimeRange date;
  final CalendarFormat format;
  final bool compact;

  final Future<List<CalendarGroup>> Function(DateTime) loadEvents;
  final List<CalendarEvent> Function(DateTime)? getEvents;

  const CalendarView(
    this.loadEvents,
    this.date, {
    super.key,
    this.getEvents,
    this.format = CalendarFormat.month,
    this.compact = false,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarGroup> _selectedEvents = [];
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.date.duration.inHours > 24)
          TableCalendar<CalendarEvent>(
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
        SizedBox(height: UIConstants.formPad),
        Center(
          child: Text(
            "Showing events of ${DateHelper.formatDate(_selectedDay, context: context)}",
            style: theme.titleMedium,
          ),
        ),
        if (_selectedEvents.isEmpty)
          Center(child: Text(locale.nodata, style: theme.titleSmall)),
        if (_selectedEvents.isNotEmpty)
          Flexible(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              shrinkWrap: true,
              itemBuilder: (x, index) {
                var item = _selectedEvents[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: theme.headlineSmall),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: item.events.length,
                      itemBuilder: (x, index) => Row(
                        children: [
                          Text(
                            "${item.events[index].value} at ${DateHelper.formatTime(item.events[index].to, context: x)}",
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
