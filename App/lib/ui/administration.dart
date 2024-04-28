import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_settings.dart';

import 'blocs/administration/settings/settings.dart';
import 'blocs/administration/users/users.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AdministrationPage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administrations'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings_sharp)),
              Tab(icon: Icon(Icons.person_search_sharp)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Column(
              children: [
                SettingsView(),
                MetricSettingsView(),
              ],
            ),
            UsersView(),
          ],
        ),
      ),
    );
  }
}
