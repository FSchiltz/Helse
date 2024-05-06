import 'package:flutter/material.dart';

import 'dashboard.dart';

class AdminDashBoard extends StatelessWidget {
  final DateTimeRange date;
  const AdminDashBoard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings)),
              Tab(icon: Icon(Icons.monitor_heart_sharp)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Dashboard(date: date),
                const SingleChildScrollView(
                  child: Center(child: Text("Stats")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
