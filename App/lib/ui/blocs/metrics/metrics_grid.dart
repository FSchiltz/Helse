import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/settings/ordered_item.dart';

import '../../../helpers/pair.dart';
import '../../../logic/d_i.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
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
      var model = await DI.metric?.metricsType(false);
      if (model != null) {
        var settings = await SettingsLogic.getMetrics();
        // filter using the user settings

        List<Pair<MetricType, OrderedItem>> filtered = [];
        for (var item in model) {
          OrderedItem setting = settings.metrics.firstWhereOrNull((element) => element.id == item.id) ?? _getDefault(item);

          if (setting.visible) filtered.add(Pair(item, setting));
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
        : BlocListener<SettingsBloc, bool>(
            listener: (context, state) {
              _getData();
            },
            bloc: DI.settings.metrics,
            child: _getGrid(cached),
          );
  }

  OrderedItem _getDefault(MetricType item) {
    if (item.type == MetricDataType.number) {
      return OrderedItem(item.id ?? 0, item.name ?? '', GraphKind.bar, GraphKind.line);
    }

    return OrderedItem(item.id ?? 0, item.name ?? '', GraphKind.event, GraphKind.event);
  }

  StatelessWidget _getGrid(List<Pair<MetricType, OrderedItem>> cached) {
    if (cached.isEmpty) {
      return const Text("No metrics");
    } else {
      return GridView.extent(
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: const BouncingScrollPhysics(),
        maxCrossAxisExtent: 240.0,
        children:
            cached.map((type) => MetricWidget(type.a, type.b, widget.date, key: Key(type.a.id?.toString() ?? ""), person: widget.person)).toList(),
      );
    }
  }
}
