import 'package:flutter/material.dart';

import '../../../logic/d_i.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../theme/loader.dart';
import '../../theme/notification.dart';
import 'metric_widget.dart';

class MetricsGrid extends StatefulWidget {
  final int? person;
  const MetricsGrid({
    super.key,
    required this.date,
    this.person,
  });

  final DateTimeRange date;

  @override
  State<MetricsGrid> createState() => _MetricsGridState();
}

class _MetricsGridState extends State<MetricsGrid> {
  List<MetricType>? types;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      var model = await DI.metric?.metricsType();
      if (model != null) {
        var settings = await SettingsLogic.getMetrics();
        // filter using the user settings
        var filtered = model.where((x) => settings.metrics.any((element) => element.id == x.id && element.visible)).toList();

        setState(() {
          types = filtered;
        });
        SettingsLogic.updateMetrics(model);
      }
    } catch (ex) {
      Notify.show("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return types == null
        ? const HelseLoader()
        : GridView.extent(
            shrinkWrap: true,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            physics: const BouncingScrollPhysics(),
            maxCrossAxisExtent: 240.0,
            children:
                types?.map((type) => MetricWidget(type, widget.date, key: Key(type.id?.toString() ?? ""), person: widget.person)).toList() ?? [],
          );
  }
}
