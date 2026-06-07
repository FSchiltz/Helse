import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/metrics/metrics_group.dart';

import '../../../di/dependencies.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class MetricsGrid extends StatefulWidget {
  final int? person;
  const MetricsGrid({super.key, required this.date, this.person});

  final DateTimeRange date;

  @override
  State<MetricsGrid> createState() => _MetricsGridState();
}

class _MetricsGridState extends State<MetricsGrid> {
  List<MetricGroup>? groups;

  List<MetricType>? typesCache;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      var metrictypes = await Dependencies.services.metric.metricsType(
        false,
        null,
      );

      List<MetricGroup> filtered = [];

      List<MetricGroup>? model = await Dependencies.services.metric
          .metricsGroup();

      if (model == null) {
        filtered = [];
      } else {
        List<OrderedItem> settings;
        if (widget.person == null) {
          if (metrictypes != null) {
            await Dependencies.logics.settings.updateMetrics(metrictypes);
            setState(() {
              typesCache = metrictypes;
            });
          }

          await Dependencies.logics.settings.updateMetricGroups(model);
          settings = await Dependencies.logics.settings.getMetricGroups();
          // filter using the user settings
        } else {
          if (metrictypes != null) {
            await Dependencies.logics.patientsSettings.updateMetrics(
              metrictypes,
            );
            setState(() {
              typesCache = metrictypes;
            });
          }

          await Dependencies.logics.patientsSettings.updateMetricGroups(model);
          settings = await Dependencies.logics.patientsSettings.getMetricGroups(
            widget.person,
          );
          // filter using the user settings
        }

        for (var item in model) {
          OrderedItem? setting = settings.firstWhereOrNull(
            (element) => element.id == item.id,
          );

          if (setting?.visible == true) filtered.add(item);
        }
      }

      setState(() {
        groups = filtered;
      });
    } catch (ex) {
      Notify.showError("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var cached = groups;
    return cached == null
        ? const HelseLoader()
        : BlocListener<SettingsBloc<bool>, bool>(
            listener: (context, state) {
              _getData();
            },
            bloc: Dependencies.logics.settings.metrics,
            child: _getGrid(cached, typesCache),
          );
  }

  Widget _getGrid(List<MetricGroup> cached, [List<MetricType>? typesCache]) {
    if (cached.isEmpty) {
      return Text(Translation.of(context).nodata);
    } else {
      return Align(
        alignment: AlignmentGeometry.topLeft,
        child: Wrap(
          spacing: 24,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: cached
              .map(
                (type) => MetricsGroup(
                  date: widget.date,
                  key: Key(type.id?.toString() ?? ""),
                  person: widget.person,
                  group: type,
                  typesCache: typesCache
                      ?.where((e) => e.groupId == type.id)
                      .toList(),
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
