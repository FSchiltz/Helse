import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_settings.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_type.dart';

class MetricSettings extends StatelessWidget {
  const MetricSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Metric Settings",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          const MetricSettingsView(),
          const SizedBox(height: 20),
          const MetricTypeView(),
        ],
      ),
    );
  }
}
