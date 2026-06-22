import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/groups/metrics_group.dart';
import 'package:helse/ui/blocs/administration/groups/metrics_settings.dart';

class GroupSettings extends StatelessWidget {
  const GroupSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Translation.of(context).metricSettings,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          GroupSettingsView(),

          Flexible(child: MetricGroupView()),
        ],
      ),
    );
  }
}
