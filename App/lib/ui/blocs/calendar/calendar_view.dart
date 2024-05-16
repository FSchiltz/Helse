import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final List<Metric> metrics;
  final DateTimeRange date;

  const CalendarView(
    this.metrics,
    this.date, {
    super.key,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Metric> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Metric> _getEventsForDay(DateTime day) {
    return widget.metrics.where((x) => x.date != null && x.date!.day == day.day && x.date!.month == day.month && x.date!.year == day.year).toList();
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
    _focusedDay = widget.date.start;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TableCalendar<Metric>(
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
        ),
        Text("Showing events of ${DateHelper.formatDate(_selectedDay, context: context)}"),
        Flexible(
          child: ListView.builder(
            itemCount: _selectedEvents.length,
            itemBuilder: (x, index) => Row(
              children: [
                Text("${_selectedEvents[index].$value} at ${DateHelper.formatTime(_selectedEvents[index].date, context: x)}"),
              ],
            ),
          ),
        )
      ],
    );
  }
}
