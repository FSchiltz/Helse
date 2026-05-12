import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/settings/ordered_item.dart';

import '../../../helpers/pair.dart';
import '../../../logic/d_i.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import 'metric_widget.dart';

class MetricsGroup extends StatefulWidget {
  final int? person;
  final int group;
  const MetricsGroup({
    super.key,
    required this.date,
    required this.group,
    this.person,
  });

  final DateTimeRange date;

  @override
  State<MetricsGroup> createState() => _MetricsGroupState();
}

class _MetricsGroupState extends State<MetricsGroup> {
  List<Pair<MetricType, OrderedItem>>? types;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      var model = await DI.metric.metricsType(false, widget.group);
      if (model != null) {
        var settings = await SettingsLogic.getMetrics();
        // filter using the user settings

        List<Pair<MetricType, OrderedItem>> filtered = [];
        for (var item in model) {
          OrderedItem setting =
              settings.metrics.firstWhereOrNull(
                (element) => element.id == item.id,
              ) ??
              _getDefault(item);

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
      return OrderedItem(
        item.id ?? 0,
        item.name,
        GraphKind.bar,
        GraphKind.line,
      );
    }

    return OrderedItem(
      item.id ?? 0,
      item.name,
      GraphKind.event,
      GraphKind.event,
    );
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
        maxCrossAxisExtent: 200.0,
        children: cached
            .map(
              (type) => MetricWidget(
                type.a,
                type.b,
                widget.date,
                key: Key(type.a.id?.toString() ?? ""),
                person: widget.person,
              ),
            )
            .toList(),
      );
    }
  }
}
