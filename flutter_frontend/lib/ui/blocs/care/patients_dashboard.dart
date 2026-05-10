import 'package:flutter/material.dart';

import '../../../helpers/date.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/date_range_picker.dart';
import '../../patient_dashboard.dart';

class PatientsDashboard extends StatefulWidget {
  final Person person;

  const PatientsDashboard(this.person, {super.key});

  @override
  State<PatientsDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.person.name ?? "",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
      body: Row(
        children: [Expanded(child: PatientDashboard(person: widget.person.id))],
      ),
    );
  }
}
