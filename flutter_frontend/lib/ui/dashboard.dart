import 'package:flutter/material.dart';

import '../helpers/users.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'care_dashboard.dart';
import 'patient_dashboard.dart';

class Dashboard extends StatelessWidget {
  final DateTimeRange date;
  final UserType? type;
  const Dashboard({super.key, required this.date, this.type});

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    List<IconData> icons = [];

    if (type?.isUser() == true) {
      icons.add(Icons.monitor_heart_sharp);
      tabs.add(PatientDashboard(date: date));
    }

    if (type?.isCare() == true) {
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
