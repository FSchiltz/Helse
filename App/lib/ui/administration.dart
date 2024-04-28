import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_type.dart';
import 'package:helse/ui/blocs/administration/settings/oauth.dart';

import 'blocs/administration/metrics/metrics_settings.dart';
import 'blocs/administration/settings/proxy.dart';
import 'blocs/administration/users/users.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AdministrationPage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Administrations', style: Theme.of(context).textTheme.displaySmall),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings_sharp)),
              Tab(icon: Icon(Icons.person_search_sharp)),
              Tab(icon: Icon(Icons.post_add_sharp)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("General Settings", style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 20),
                  const ProxyView(),
                  const SizedBox(height: 20),
                  // const OauthView(),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Users Settings", style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 20),
                  const UsersView(),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Metric Settings", style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 20),
                  const MetricSettingsView(),
                  const SizedBox(height: 20),
                  const MetricTypeView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
