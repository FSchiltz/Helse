import 'package:flutter/material.dart';

import '../services/swagger/generated_code/helseapi.swagger.dart';
import 'care_dashboard.dart';
import 'patient_dashboard.dart';

class Dashboard extends StatelessWidget {
  final DateTimeRange date;
  final List<UserType> types;
  const Dashboard({super.key, required this.date,required this.types});

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    List<IconData> icons = [];

    if (types.contains(UserType.user)) {
      icons.add(Icons.monitor_heart_sharp);
      tabs.add(PatientDashboard(date: date));
    }

    if (types.contains(UserType.caregiver)) {
      icons.add(Icons.personal_injury_sharp);
      tabs.add(CareDashBoard(date: date));
    }

    return DefaultTabController(
      length: tabs.length,
      child: (tabs.length == 1)
          ? tabs[0]
          : Column(
              children: [
                TabBar(tabs: icons.map((t) => Tab(icon: Icon(t))).toList()),
                Expanded(
                  child: TabBarView(
                    children: tabs,
                  ),
                ),
              ],
            ),
    );
  }
}
