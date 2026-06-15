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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      final model = await Dependencies.services.metric.metricsGroup();

      List<MetricGroup> filtered = [];
      if (model == null) {
        filtered = [];
      } else {
        MetricGroupSettings settings;
        if (widget.person == null) {
          settings =
              (Dependencies.logics.settings.getMetrics()).groups ??
              MetricGroupSettings(displaySettings: []);
          // filter using the user settings
        } else {
          settings =
              (Dependencies.logics.patientsSettings.getMetrics(
                widget.person,
              )).groups ??
              MetricGroupSettings(displaySettings: []);
          // filter using the user settings
        }

        for (var item in model) {
          OrderedItem? setting = settings.displaySettings.firstWhereOrNull(
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
            child: _getGrid(cached),
          );
  }

  Widget _getGrid(List<MetricGroup> cached) {
    if (cached.isEmpty) {
      return Text(Translation.of(context).nodata);
    } else {
      return Align(
        alignment: AlignmentGeometry.topLeft,
        child: Wrap(
          spacing: 24,
          runSpacing: 16,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: cached
              .map(
                (type) => MetricsGroup(
                  date: widget.date,
                  key: Key(type.id?.toString() ?? ""),
                  person: widget.person,
                  group: type,
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
