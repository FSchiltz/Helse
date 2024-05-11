import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/settings/settings_logic.dart';

import '../logic/d_i.dart';
import 'blocs/events/events_grid.dart';
import 'blocs/metrics/metrics_grid.dart';

class Dashboard extends StatelessWidget {
  final DateTimeRange date;
  final int? person;
  const Dashboard({super.key, required this.date, this.person});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MetricsGrid(date: date, person: person),
            const SizedBox(
              height: 10,
            ),
            EventsGrid(date: date, person: person),
          ],
        ),
      ),
    );
  }
}
