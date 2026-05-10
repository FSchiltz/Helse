import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/date_range_picker.dart';

import 'blocs/events/events_grid.dart';
import 'blocs/metrics/metrics_grid.dart';

class PatientDashboard extends StatefulWidget {
  final int? person;
  const PatientDashboard({super.key, this.person});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {

  DateTimeRange date = DateHelper.now();

    void _setDate(DateTimeRange value) {
    setState(() {
      date = value;
    });
  }

    Future<void> _setDefaultRange() async {
    var range = await DI.settings.getDateRange();
    setState(() {
      date = DateHelper.getRange(range);
    });
  }

  @override
  void initState() {
    super.initState();
    _setDefaultRange();
  }

  @override
  Widget build(BuildContext context) {

        var isLargeScreen = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DateRangePicker(_setDate, date, isLargeScreen),
            MetricsGrid(date: date, person: widget.person),
            const SizedBox(
              height: 10,
            ),
            EventsGrid(date: date, person: widget.person),
          ],
        ),
      ),
    );
  }
}
