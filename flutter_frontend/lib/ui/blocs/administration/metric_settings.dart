import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_group.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_settings.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_type.dart';

class MetricSettings extends StatelessWidget {
  const MetricSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MetricSettingsView(),
            TabBar(
              tabs: [
                Tab(icon: Icon(Icons.post_add_sharp), text: 'Metrics'),
                Tab(icon: Icon(Icons.group_add_sharp), text: 'Metric Groups'),
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
