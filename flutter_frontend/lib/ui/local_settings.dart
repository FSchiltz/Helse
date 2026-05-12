import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/blocs/localSettings/general_settings.dart';
import 'package:helse/ui/blocs/localSettings/sync_settings.dart';

class LocalSettingsPage extends StatelessWidget {
  const LocalSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Local Settings',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GeneralSettings(),
          SyncSettings(),
          MetricSettings(),
          EventSettings(),
        ],
      ),
    );
  }
}
