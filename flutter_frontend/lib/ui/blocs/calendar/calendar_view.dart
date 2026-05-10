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
  final DateTimeRange date;

  final Future<List<CalendarEvent>> Function(DateTime) getEventsForDay;

  const CalendarView(this.getEventsForDay, this.date, {super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarEvent> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() async {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = await widget.getEventsForDay(selectedDay);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _focusedDay = widget.date.start;
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
