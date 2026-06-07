import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
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
    DatePreset range;

    if (widget.person == null) {
      range = await Dependencies.logics.settings.getDateRange();
    } else {
      range = await Dependencies.logics.patientsSettings.getPatientsDateRange(widget.person);
    }

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateRangePicker(_setDate, date),
            ),
            MetricsGrid(date: date, person: widget.person),
            const SizedBox(height: 24),
            EventsGrid(date: date, person: widget.person),
          ],
        ),
      ),
    );
  }
}
