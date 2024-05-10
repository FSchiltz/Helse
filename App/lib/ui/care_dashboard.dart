import 'package:flutter/material.dart';

import 'blocs/care/agenda.dart';
import 'blocs/care/patients.dart';
import 'dashboard.dart';

class CareDashBoard extends StatelessWidget {
  final DateTimeRange date;
  const CareDashBoard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monitor_heart_sharp)),
              Tab(icon: Icon(Icons.personal_injury_sharp)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Dashboard(date: date),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Patients(),
                        Agenda(date: date),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
