import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/localSettings/ordered_edit_item.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/statefull_check.dart';
import 'package:helse/ui/common/type_input.dart';

class MetricSettings extends StatefulWidget {
  final bool isPatient;
  final int? patient;
  const MetricSettings({super.key, this.isPatient = false, this.patient});

  @override
  State<MetricSettings> createState() => _MetricSettingsState();
}

class _MetricSettingsState extends State<MetricSettings> {
  Future<(List<OrderedEditItem>, List<OrderedEditItem>)> _getData(
    bool refresh,
  ) async {
    List<OrderedItem> metrics;
    List<OrderedItem> groups;
    if (widget.isPatient) {
      metrics = await Dependencies.logics.patientsSettings.getMetrics(
        widget.patient,
      );
      groups = await Dependencies.logics.patientsSettings.getMetricGroups(
        widget.patient,
      );
    } else {
      metrics = await Dependencies.logics.settings.getMetrics();
      groups = await Dependencies.logics.settings.getMetricGroups();
    }

    var editGroups = groups.map((e) => OrderedEditItem.of(e)).toList();
    var editMetrics = metrics.map((e) => OrderedEditItem.of(e)).toList();

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
      // save the user's settings
      if (widget.isPatient) {
        await Dependencies.logics.patientsSettings.saveMetrics(
          metricsToSave,
          true,
          widget.patient,
        );

        await Dependencies.logics.patientsSettings.saveMetricGroups(
          groupsToSave,
          true,
          widget.patient,
        );
      } else {
        await Dependencies.logics.settings.saveMetrics(metricsToSave, true);
        await Dependencies.logics.settings.saveMetricGroups(groupsToSave, true);
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

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      shape: const ContinuousRectangleBorder(),
                    ),
                    onPressed: () async {
                      await _submit(metrics, groups, locale);
                      reset();
                    },
                    child: Text(locale.save),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: groups.expand<Widget>((group) {
                    final children = metrics
                        .where((m) => m.parent == group.id)
                        .toList();

                    return [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                group.name,
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            StatefullCheck(group.visible, (value) {
                              group.visible = value;
                            }),
                          ],
                        ),
                      ),
                      Flexible(
                        child: DataTable(
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 60,
                          columns: [
                            DataColumn(
                              label: Expanded(child: Text(locale.name)),
                            ),
                            DataColumn(
                              label: Expanded(child: Text(locale.visible)),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(locale.showOnDashboard),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(child: Text(locale.widgetType)),
                            ),
                            DataColumn(
                              label: Expanded(child: Text(locale.detailType)),
                            ),
                          ],
                          rows: children
                              .map(
                                (item) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        item.name,
                                        style: theme.textTheme.titleLarge,
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
                                        (value) => item.showOnDashboard = value,
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 160,
                                        height: 45,
                                        child: EnumInput(
                                          value: item.graph,
                                          GraphKind.values
                                              .where((e) => e.index > 0)
                                              .map(
                                                (x) => DropDownItem(x, x.name),
                                              )
                                              .toList(),
                                          (value) =>
                                              item.graph = value ?? item.graph,
                                          label: locale.type,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 160,
                                        height: 45,
                                        child: EnumInput(
                                          value: item.detailGraph,
                                          GraphKind.values
                                              .where((e) => e.index > 0)
                                              .map(
                                                (x) => DropDownItem(x, x.name),
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
                      const SizedBox(height: 16),
                    ];
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
