import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TableRow;
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/localSettings/ordered_edit_item.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/inputs/statefull_check.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/table.dart';
import 'package:helse/ui/common/ui_constants.dart';

class _SettingsData {
  final List<OrderedEditItem> metrics;
  final List<OrderedEditItem> events;
  final List<OrderedEditItem> groups;
  final Map<int?, List<OrderedEditItem>> groupedMetrics;
  final Map<int?, List<OrderedEditItem>> groupedEvents;

  _SettingsData(
    this.groups,
    this.metrics,
    this.events, {
    required this.groupedMetrics,
    required this.groupedEvents,
  });
}

class MetricsSettings extends StatefulWidget {
  final bool isPatient;
  final int? patient;
  const MetricsSettings({super.key, this.isPatient = false, this.patient});

  @override
  State<MetricsSettings> createState() => _MetricsSettingsState();
}

class _MetricsSettingsState extends State<MetricsSettings> {
  Future<_SettingsData> _getData(bool refresh) async {
    MetricSettings metrics;
    MetricGroupSettings groups;
    EventSettings events;

    if (widget.isPatient) {
      var settings = Dependencies.logics.patientsSettings.patientSettings(
        widget.patient,
      );
      metrics = settings.metricSettings ?? MetricSettings(displaySettings: []);
      groups = settings.groups ?? MetricGroupSettings(displaySettings: []);
      events =
          settings.eventSettings ??
          EventSettings(displaySettings: [], displayValueSettings: []);
    } else {
      var settings = Dependencies.logics.settings.userSettings();
      metrics = settings.metricSettings ?? MetricSettings(displaySettings: []);
      groups = settings.groups ?? MetricGroupSettings(displaySettings: []);
      events =
          settings.eventSettings ??
          EventSettings(displaySettings: [], displayValueSettings: []);
    }

    var editGroups = groups.displaySettings
        .map((e) => OrderedEditItem.of(e))
        .toList();
    var editMetrics = metrics.displaySettings
        .map((e) => OrderedEditItem.of(e))
        .toList();
    var editEvents = events.displaySettings
        .map((e) => OrderedEditItem.of(e))
        .toList();

    final grouped = editMetrics.groupListsBy((e) => e.parent);
    final groupedEvent = editEvents.groupListsBy((e) => e.parent);

    return _SettingsData(
      editGroups,
      editMetrics,
      editEvents,
      groupedMetrics: grouped,
      groupedEvents: groupedEvent,
    );
  }

  Future<void> _submit(_SettingsData data, AppLocalizations locale) async {
    try {
      var metricsToSave = data.metrics.map((e) => e.ordered()).toList();
      var eventsToSave = data.events.map((e) => e.ordered()).toList();
      var groupsToSave = data.groups.map((e) => e.ordered()).toList();
      // save the user's settings;
      if (widget.isPatient) {
        final settings = Dependencies.logics.patientsSettings.patientSettings(
          widget.patient,
        );
        await Dependencies.logics.patientsSettings.savePatientsSettings(
          settings.copyWith(
            groups: settings.groups?.copyWith(displaySettings: groupsToSave),
            metricSettings: settings.metricSettings?.copyWith(
              displaySettings: metricsToSave,
            ),
            eventSettings: settings.eventSettings?.copyWith(
              displaySettings: eventsToSave,
            ),
          ),
          true,
        );
      } else {
        final settings = Dependencies.logics.settings.userSettings();
        await Dependencies.logics.settings.saveSettings(
          settings.copyWith(
            groups: settings.groups?.copyWith(displaySettings: groupsToSave),
            metricSettings: settings.metricSettings?.copyWith(
              displaySettings: metricsToSave,
            ),
            eventSettings: settings.eventSettings?.copyWith(
              displaySettings: eventsToSave,
            ),
          ),
          true,
        );
      }

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);

    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 120,
                  child: SquareButton(locale.save, () async {
                    await _submit(data, locale);
                    reset();
                  }),
                ),
              ),
              const SizedBox(height: UIConstants.formPad),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.groups.length,
                  itemBuilder: (context, index) {
                    final group = data.groups[index];

                    return _GroupCard(
                      key: ValueKey(group.id),
                      group: group,
                      metrics: data.groupedMetrics[group.id] ?? const [],
                      events: data.groupedEvents[group.id] ?? const [],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final OrderedEditItem group;
  final List<OrderedEditItem> metrics;
  final List<OrderedEditItem> events;

  const _GroupCard({
    super.key,
    required this.group,
    required this.metrics,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.formPad),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Dependencies.theme.stateColor(
                group.id.toString(),
                StateType.metricGroup,
                context,
              ),
              width: 8,
            ),
          ),
        ),
        child: CommonCard(
          padding: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: UIConstants.formPad),
                child: HelseSwitch(group.name, group.visible, (value) {
                  group.visible = value;
                }),
              ),
              if (metrics.isNotEmpty) ...[
                TableHeader(
                  header: [
                    Header(locale.name, 160),
                    Header(locale.visible, 80),
                    Header(locale.showOnDashboard, 80),
                    Header(locale.widgetType, 160),
                    Header(locale.detailType, 160),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: metrics.length,
                  itemBuilder: (context, index) {
                    var metric = metrics[index];
                    return _MetricRow(metric: metric, key: ValueKey(metric.id));
                  },
                ),
              ],
              SizedBox(height: UIConstants.formPad),
              if (events.isNotEmpty) ...[
                TableHeader(
                  header: [
                    Header(locale.name, 160),
                    Header(locale.visible, 80),
                    Header(locale.showOnDashboard, 80),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    var event = events[index];
                    return _EventRow(event: event, key: ValueKey(event.id));
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({super.key, required this.event});

  final OrderedEditItem event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableRow([
      RowData(
        width: 160,
        child: Text(event.name, style: theme.textTheme.titleLarge),
      ),
      RowData(
        width: 80,
        child: StatefullCheck(event.visible, (value) => event.visible = value),
      ),
      RowData(
        width: 80,
        child: StatefullCheck(
          event.showOnDashboard,
          (value) => event.showOnDashboard = value,
        ),
      ),
    ]);
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({super.key, required this.metric});

  final OrderedEditItem metric;

  static final List<DropdownItem<GraphKind>> _graphItems = GraphKind.values
      .where((e) => e.index > 0)
      .map((x) => DropdownItem(x, x.name))
      .toList();

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    final theme = Theme.of(context);
    return TableRow([
      RowData(
        width: 160,
        child: Text(metric.name, style: theme.textTheme.titleLarge),
      ),
      RowData(
        width: 80,
        child: StatefullCheck(
          metric.visible,
          (value) => metric.visible = value,
        ),
      ),
      RowData(
        width: 80,
        child: StatefullCheck(
          metric.showOnDashboard,
          (value) => metric.showOnDashboard = value,
        ),
      ),

      RowData(
        width: 160,
        child: Padding(
          padding: const EdgeInsets.only(right: UIConstants.tablePad),
          child: ValuesInput(
            value: metric.graph,
            _graphItems,
            (value) => metric.graph = value ?? metric.graph,
            label: locale.type,
          ),
        ),
      ),

      RowData(
        width: 160,
        child: ValuesInput(
          value: metric.detailGraph,
          _graphItems,
          (value) => metric.detailGraph = value ?? metric.detailGraph,
          label: locale.type,
        ),
      ),
    ]);
  }
}
