import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvent {
  final DateTime from;
  final DateTime to;
  final String value;

  CalendarEvent({required this.from, required this.to, required this.value});
}

class CalendarView extends StatefulWidget {
  final List<CalendarEvent> events;
  final DateTimeRange date;

  const CalendarView(this.events, this.date, {super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarEvent> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return widget.events.where((x) {
      var from = DateTime(x.from.year, x.from.month, x.from.day);
      var to = DateTime(x.to.year, x.to.month, x.to.day);
      return from.compareTo(day) <= 0 && to.compareTo(day) >= 0;
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    var firstDay = widget.events.firstOrNull?.to;
    if (firstDay != null) {
      _onDaySelected(firstDay, firstDay);
    } else {
      _focusedDay = widget.date.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(        
      children: [
        TableCalendar<CalendarEvent>(
          firstDay: widget.date.start,
          lastDay: widget.date.end,
          focusedDay: _focusedDay,
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
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
          availableGestures: AvailableGestures.all,
          calendarStyle: const CalendarStyle(
            isTodayHighlighted: true,
            //selectedDecoration: BoxDecoration(color: Colors.red),
            outsideDaysVisible: false,
          ),
          rangeSelectionMode: RangeSelectionMode.enforced,
          onDaySelected: _onDaySelected,
        ),
        Text(
          "Showing events of ${DateHelper.formatDate(_selectedDay, context: context)}",
        ),
        Flexible(
          child: ListView.builder(
            itemCount: _selectedEvents.length,
            itemBuilder: (x, index) => Row(
              children: [
                Text(
                  "${_selectedEvents[index].value} at ${DateHelper.formatTime(_selectedEvents[index].to, context: x)}",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
