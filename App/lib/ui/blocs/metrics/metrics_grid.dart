import 'package:flutter/material.dart';
import 'package:helse/logic/settings/ordered_item.dart';

import '../../../helpers/pair.dart';
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
  List<Pair<MetricType, OrderedItem>>? types;
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

        List<Pair<MetricType, OrderedItem>> filtered = [];
        for (var item in model) {
          OrderedItem setting = settings.metrics.isEmpty
              ? OrderedItem(item.id ?? 0, item.name ?? '', GraphKind.bar, GraphKind.line)
              : settings.metrics.firstWhere((element) => element.id == item.id && element.visible);

          filtered.add(Pair(item, setting));
        }

        setState(() {
          types = filtered;
        });
        SettingsLogic.updateMetrics(model);
      }
    } catch (ex) {
      Notify.showError("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var cached = types;
    return cached == null
        ? const HelseLoader()
        : GridView.extent(
            shrinkWrap: true,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            physics: const BouncingScrollPhysics(),
            maxCrossAxisExtent: 240.0,
            children: cached
                .map((type) => MetricWidget(type.a, type.b, widget.date, key: Key(type.a.id?.toString() ?? ""), person: widget.person))
                .toList(),
          );
  }
}
