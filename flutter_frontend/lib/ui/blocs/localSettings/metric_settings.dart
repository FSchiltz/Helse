import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
import 'package:helse/ui/common/ui_constants.dart';

class MetricsSettings extends StatefulWidget {
  final bool isPatient;
  final int? patient;
  const MetricsSettings({super.key, this.isPatient = false, this.patient});

  @override
  State<MetricsSettings> createState() => _MetricsSettingsState();
}

class _MetricsSettingsState extends State<MetricsSettings> {
  Future<(List<OrderedEditItem>, List<OrderedEditItem>)> _getData(
    bool refresh,
  ) async {
    MetricSettings metrics;
    MetricGroupSettings groups;

    if (widget.isPatient) {
      var settings = Dependencies.logics.patientsSettings.patientSettings(
        widget.patient,
      );
      metrics = settings.metricSettings ?? MetricSettings(displaySettings: []);
      groups = settings.groups ?? MetricGroupSettings(displaySettings: []);
    } else {
      var settings = Dependencies.logics.settings.userSettings();
      metrics = settings.metricSettings ?? MetricSettings(displaySettings: []);
      groups = settings.groups ?? MetricGroupSettings(displaySettings: []);
    }

    var editGroups = groups.displaySettings
        .map((e) => OrderedEditItem.of(e))
        .toList();
    var editMetrics = metrics.displaySettings
        .map((e) => OrderedEditItem.of(e))
        .toList();

    return (editGroups, editMetrics);
  }

  Future<void> _submit(
    List<OrderedEditItem> metrics,
    List<OrderedEditItem> groups,
    AppLocalizations locale,
  ) async {
    try {
      var metricsToSave = metrics.map((e) => e.ordered()).toList();
      var groupsToSave = groups.map((e) => e.ordered()).toList();
      // save the user's settings;
      if (widget.isPatient) {
        final settings = Dependencies.logics.patientsSettings.getMetrics(
          widget.patient,
        );
        await Dependencies.logics.patientsSettings.saveMetrics(
          settings.copyWith(
            displaySettings: metricsToSave,
            groups:
                (settings.groups ?? MetricGroupSettings(displaySettings: []))
                    .copyWith(displaySettings: groupsToSave),
          ),
          true,
          widget.patient,
        );
      } else {
        final settings = Dependencies.logics.settings.getMetrics();
        await Dependencies.logics.settings.saveMetrics(
          settings.copyWith(
            displaySettings: metricsToSave,
            groups:
                (settings.groups ?? MetricGroupSettings(displaySettings: []))
                    .copyWith(displaySettings: groupsToSave),
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
    final theme = Theme.of(context);
    final locale = Translation.of(context);

    return LoadingBuilder(
      _getData,
      builder: (context, tree, reset) {
        final groups = tree.$1;
        final metrics = tree.$2;
        final grouped = metrics.groupListsBy((e) => e.parent);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 120,
                  child: SquareButton(locale.save, () async {
                    await _submit(metrics, groups, locale);
                    reset();
                  }),
                ),
              ),
              const SizedBox(height: UIConstants.formPad),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: groups.map((group) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: UIConstants.formPad,
                      ),
                      child: CommonCard(
                        padding: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: UIConstants.formPad,
                                vertical: UIConstants.formPad,
                              ),
                              child: HelseSwitch(group.name, group.visible, (
                                value,
                              ) {
                                group.visible = value;
                              }),
                            ),
                            Container(
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
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Expanded(child: Text(locale.name)),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(locale.visible),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(locale.showOnDashboard),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(locale.widgetType),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(locale.detailType),
                                      ),
                                    ),
                                  ],
                                  rows: (grouped[group.id] ?? [])
                                      .map(
                                        (item) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                item.name,
                                                style:
                                                    theme.textTheme.titleLarge,
                                              ),
                                            ),
                                            DataCell(
                                              StatefullCheck(
                                                item.visible,
                                                (value) => item.visible = value,
                                              ),
                                            ),
                                            DataCell(
                                              StatefullCheck(
                                                item.showOnDashboard,
                                                (value) =>
                                                    item.showOnDashboard =
                                                        value,
                                              ),
                                            ),
                                            DataCell(
                                              SizedBox(
                                                width: 160,
                                                child: ValuesInput(
                                                  value: item.graph,
                                                  GraphKind.values
                                                      .where((e) => e.index > 0)
                                                      .map(
                                                        (x) => DropdownItem(
                                                          x,
                                                          x.name,
                                                        ),
                                                      )
                                                      .toList(),
                                                  (value) => item.graph =
                                                      value ?? item.graph,
                                                  label: locale.type,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              SizedBox(
                                                width: 160,
                                                child: ValuesInput(
                                                  value: item.detailGraph,
                                                  GraphKind.values
                                                      .where((e) => e.index > 0)
                                                      .map(
                                                        (x) => DropdownItem(
                                                          x,
                                                          x.name,
                                                        ),
                                                      )
                                                      .toList(),
                                                  (value) => item.detailGraph =
                                                      value ?? item.detailGraph,
                                                  label: locale.type,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
