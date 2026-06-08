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
  Future<List<OrderedEditItem>> _getData(bool refresh) async {
    List<OrderedItem> items;
    if (widget.isPatient) {
      items = await Dependencies.logics.patientsSettings.getMetrics(widget.patient);
    } else {
      items = await Dependencies.logics.settings.getMetrics();
    }
    return items
        .map(
          (e) => OrderedEditItem(
            id: e.id,
            name: e.name,
            detailGraph: e.detailGraph,
            graph: e.graph,
            visible: e.visible ?? true,
            order: e.order,
            showOnDashboard: e.showOnDashboard ?? true,
          ),
        )
        .toList();
  }

  Future<List<OrderedEditItem>> _getGroupData(bool reset) async {
    List<OrderedItem> items;
    if (widget.isPatient) {
      items = await Dependencies.logics.patientsSettings.getMetricGroups(widget.patient);
    } else {
      items = await Dependencies.logics.settings.getMetricGroups();
    }
    return items
        .map(
          (e) => OrderedEditItem(
            id: e.id,
            name: e.name,
            detailGraph: e.detailGraph,
            graph: e.graph,
            visible: e.visible ?? true,
            order: e.order,
            showOnDashboard: e.showOnDashboard ?? true,
          ),
        )
        .toList();
  }

  Future<void> _submitMetricGroups(
    List<OrderedEditItem> groups,
    AppLocalizations locale,
  ) async {
    try {
      var toSave = groups.map((e) => e.ordered()).toList();
      // save the user's settings
      if (widget.isPatient) {
        await Dependencies.logics.patientsSettings.saveMetricGroups(
          toSave,
          true,
          widget.patient
        );
      } else {
        await Dependencies.logics.settings.saveMetricGroups(toSave, true);
      }

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  Future<void> _submitMetrics(
    List<OrderedEditItem> metrics,
    AppLocalizations locale,
  ) async {
    try {
      var toSave = metrics.map((e) => e.ordered()).toList();
      // save the user's settings
      if (widget.isPatient) {
        await Dependencies.logics.patientsSettings.saveMetrics(toSave, true, widget.patient);
      } else {
        await Dependencies.logics.settings.saveMetrics(toSave, true);
      }

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var locale = Translation.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.post_add_sharp), text: locale.metrics),
              Tab(icon: Icon(Icons.group_add_sharp), text: locale.metricgroups),
            ],
          ),
          Flexible(
            child: TabBarView(
              children: [
                _metricsGrid(theme, locale),
                _metricGroupsGrid(theme, locale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsGrid(ThemeData theme, AppLocalizations locale) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    shape: const ContinuousRectangleBorder(),
                  ),
                  onPressed: () async {
                    await _submitMetrics(data, locale);
                    reset();
                  },
                  child: Text(locale.save),
                ),
              ),
              const SizedBox(height: 20),
              FittedBox(
                child: DataTable(
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 60,
                  columns: [
                    DataColumn(label: Expanded(child: Text(locale.name))),
                    DataColumn(label: Expanded(child: Text(locale.visible))),
                    DataColumn(
                      label: Expanded(child: Text(locale.showOnDashboard)),
                    ),
                    DataColumn(label: Expanded(child: Text(locale.widgetType))),
                    DataColumn(label: Expanded(child: Text(locale.detailType))),
                  ],
                  rows: data
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
                                      .map((x) => DropDownItem(x, x.name))
                                      .toList(),
                                  (value) => item.graph = value ?? item.graph,
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
                                      .map((x) => DropDownItem(x, x.name))
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricGroupsGrid(ThemeData theme, AppLocalizations locale) {
    return LoadingBuilder(
      _getGroupData,
      builder: (context, data, reset) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      shape: const ContinuousRectangleBorder(),
                    ),
                    onPressed: () async {
                      await _submitMetricGroups(data, locale);
                      reset();
                    },
                    child: Text(locale.save),
                  ),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Expanded(child: Text(locale.name))),
                      DataColumn(label: Expanded(child: Text(locale.visible))),
                    ],
                    rows: data
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
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
