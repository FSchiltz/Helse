import 'package:flutter/material.dart';

import 'blocs/care/agenda.dart';
import 'blocs/care/patients.dart';

class CareDashBoard extends StatelessWidget {
  final DateTimeRange date;
  const CareDashBoard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Patients(),
            Agenda(date: date),
          ],
        ),
      ),
    );
  }
}
