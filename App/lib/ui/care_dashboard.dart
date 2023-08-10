import 'package:flutter/material.dart';

import 'blocs/care/agenda.dart';
import 'blocs/care/patients.dart';
import 'dashboard.dart';

class CareDashBoard extends StatelessWidget {
  final DateTimeRange date;
  const CareDashBoard({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.personal_injury_sharp)),
                Tab(icon: Icon(Icons.monitor_heart_sharp)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
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
                Dashboard(date: date),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
