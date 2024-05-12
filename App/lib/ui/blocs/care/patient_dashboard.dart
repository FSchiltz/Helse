import 'package:flutter/material.dart';

import '../../../helpers/date.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../dashboard.dart';
import '../../common/date_range_input.dart';

class PatientDashboard extends StatefulWidget {
  final Person person;

  const PatientDashboard(this.person, {super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.person.name ?? "", style: Theme.of(context).textTheme.displayMedium),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: DateRangeInput(_setDate, date),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Dashboard(
              date: date,
              person: widget.person.id,
            ),
          ),
        ],
      ),
    );
  }
}
