import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/groups/widget_group.dart';

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
  List<Group>? _groups;
  Map<int, List<(MetricType, OrderedItem)>>? _metrics;
  Map<int, List<(EventType, OrderedItem)>>? _events;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final locale = Translation.of(context);
    final localContext = context;
    try {
      final model = await Dependencies.services.metric.metricsGroup();
      final metrics =
          await Dependencies.services.metric.metricsType(true, null) ?? [];
      final events = await Dependencies.services.event.eventsType(true) ?? [];

      MetricSettings metricSettings;
      EventSettings eventSettings;
      MetricGroupSettings groupSettings;
      if (widget.person == null) {
        final settings = Dependencies.logics.settings.userSettings();
        metricSettings =
            settings.metricSettings ?? MetricSettings(displaySettings: []);
        eventSettings =
            settings.eventSettings ??
            EventSettings(displaySettings: [], displayValueSettings: []);
        groupSettings =
            settings.groups ?? MetricGroupSettings(displaySettings: []);
      } else {
        final settings = Dependencies.logics.patientsSettings.patientSettings(
          widget.person,
        );
        metricSettings =
            settings.metricSettings ?? MetricSettings(displaySettings: []);
        eventSettings =
            settings.eventSettings ??
            EventSettings(displaySettings: [], displayValueSettings: []);
        groupSettings =
            settings.groups ?? MetricGroupSettings(displaySettings: []);
      }

      List<Group> filtered = [];
      if (model == null) {
        filtered = [];
      } else {
        // filter the group to only show what the user wants
        for (var item in model) {
          OrderedItem? setting = groupSettings.displaySettings.firstWhereOrNull(
            (element) => element.id == item.id,
          );

          if (setting?.visible == true) filtered.add(item);
        }
      }

      final Map<int, List<(EventType, OrderedItem)>> orderedEvent = events
          .groupFoldBy((e) => e.groupId, (e, type) {
            // find the settings
            e ??= [];

            OrderedItem? setting =
                eventSettings.displaySettings.firstWhereOrNull(
                  (element) => element.id == type.id,
                ) ??
                OrderedItem(name: type.name, id: type.id);

            e.add((type, setting));
            return e;
          });

      final Map<int, List<(MetricType, OrderedItem)>> orderedMetric = metrics
          .groupFoldBy((e) => e.groupId, (e, type) {
            e ??= [];
            // find the settings
            if (type.showOnDashboard != true) {
              return e;
            }

            OrderedItem setting =
                metricSettings.displaySettings.firstWhereOrNull(
                  (element) => element.id == type.id,
                ) ??
                Dependencies.logics.settings.getDefault(type);

            e.add((type, setting));
            return e;
          });

      setState(() {
        _groups = filtered;
        _events = orderedEvent;
        _metrics = orderedMetric;
      });
    } catch (ex) {
      if (localContext.mounted) {
        Notify.showError(locale.error(ex.toString()), localContext);
      }
      log(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var cached = _groups;
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

  Widget _getGrid(List<Group> cached) {
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
                (type) => WidgetGroups(
                  date: widget.date,
                  key: Key(type.id?.toString() ?? ""),
                  person: widget.person,
                  group: type,
                  metrics: _metrics?[type.id] ?? [],
                  events: _events?[type.id] ?? [],
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
