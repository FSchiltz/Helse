import 'package:flutter/material.dart';
import 'package:helse/ui/admin_dashboard.dart';

import '../services/swagger/generated_code/helseapi.swagger.dart';
import 'care_dashboard.dart';
import 'patient_dashboard.dart';

class Dashboard extends StatelessWidget {
  final List<UserType> types;
  const Dashboard({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    List<IconData> icons = [];

    // TODO add a patient dashboard if the user is one.
    if (types.contains(UserType.user)) {
      icons.add(Icons.monitor_heart_sharp);
      tabs.add(PatientDashboard());
    }

    if (types.contains(UserType.caregiver)) {
      icons.add(Icons.personal_injury_sharp);
      tabs.add(CareDashBoard());
    }

    if (types.contains(UserType.admin)) {
      icons.add(Icons.admin_panel_settings_sharp);
      tabs.add(AdminDashBoard());
    }

    return DefaultTabController(
      length: tabs.length,
      child: (tabs.length == 1)
          ? tabs[0]
          : Column(
              children: [
                TabBar(tabs: icons.map((t) => Tab(icon: Icon(t))).toList()),
                Expanded(child: TabBarView(children: tabs)),
              ],
            ),
    );
  }
}
