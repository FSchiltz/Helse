import 'package:flutter/material.dart';

import '../../../helpers/date.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/date_range_input.dart';
import '../../common/date_range_picker.dart';
import '../../patient_dashboard.dart';

class PatientsDashboard extends StatefulWidget {
  final Person person;

  const PatientsDashboard(this.person, {super.key});

  @override
  State<PatientsDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientsDashboard> {
  DateTimeRange date = DateHelper.now();

  void _setDate(DateTimeRange value) {
    setState(() {
      date = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.person.name ?? "", style: Theme.of(context).textTheme.displayMedium),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: DateRangePicker(_setDate, date, isLargeScreen),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: PatientDashboard(
              date: date,
              person: widget.person.id,
            ),
          ),
        ],
      ),
    );
  }
}
