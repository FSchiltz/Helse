import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_group.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_settings.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_type.dart';

class MetricSettings extends StatelessWidget {
  const MetricSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Translation.of(context).metricSettings,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            MetricSettingsView(),
            TabBar(
              tabs: [
                Tab(icon: Icon(Icons.post_add_sharp), text: locale.metrics),
                Tab(
                  icon: Icon(Icons.group_add_sharp),
                  text: locale.metricgroups,
                ),
              ],
            ),
            Flexible(
              child: TabBarView(
                children: [MetricTypeView(), MetricGroupView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
