import 'package:material_ui/material_ui.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_settings.dart';
import 'package:helse/ui/blocs/administration/metrics/metrics_type.dart';

class MetricSettings extends StatelessWidget {
  const MetricSettings({super.key});

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
          MetricSettingsView(),
          Flexible(child: MetricTypeView()),
        ],
      ),
    );
  }
}
