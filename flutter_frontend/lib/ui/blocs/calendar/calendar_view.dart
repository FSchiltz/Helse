import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
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

  final Future<List<CalendarGroup>> Function(DateTime) loadEvents;
  final List<CalendarEvent> Function(DateTime)? getEvents;

  const CalendarView(this.loadEvents, this.date, {super.key, this.getEvents});

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
            onDaySelected: _onDaySelected,
          ),
        SizedBox(height: UIConstants.formPad),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Showing events of ${DateHelper.formatDate(_selectedDay, context: context)}",
            style: theme.headlineSmall,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: _selectedEvents.length,
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
        ),
      ],
    );
  }
}
