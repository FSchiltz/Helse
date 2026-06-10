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
            parent: e.parent,
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
            parent: e.parent,
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

  
  Future<(List<OrderedEditItem>, List<OrderedEditItem>)> _getTreeData(
    bool refresh,
  ) async {
    final groups = await _getGroupData(refresh);
    final metrics = await _getData(refresh);
    return (groups, metrics);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Translation.of(context);

    return LoadingBuilder(
      _getTreeData,
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
                      await _submitMetricGroups(groups, locale);
                      await _submitMetrics(metrics, locale);
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
                            const Icon(Icons.folder),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                group.name,
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            StatefullCheck(
                              group.visible,
                              (value) {
                                group.visible = value;
                                for (final metric in children) {
                                  metric.visible = value;
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      ...children.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.subdirectory_arrow_right,
                                size: 18,
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(item.name),
                              ),
                              Expanded(
                                child: StatefullCheck(
                                  item.visible,
                                  (v) => item.visible = v,
                                ),
                              ),
                              Expanded(
                                child: StatefullCheck(
                                  item.showOnDashboard,
                                  (v) => item.showOnDashboard = v,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: EnumInput(
                                  value: item.graph,
                                  GraphKind.values
                                      .where((e) => e.index > 0)
                                      .map((x) => DropDownItem(x, x.name))
                                      .toList(),
                                  (v) => item.graph = v ?? item.graph,
                                  label: locale.type,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: EnumInput(
                                  value: item.detailGraph,
                                  GraphKind.values
                                      .where((e) => e.index > 0)
                                      .map((x) => DropDownItem(x, x.name))
                                      .toList(),
                                  (v) => item.detailGraph =
                                      v ?? item.detailGraph,
                                  label: locale.type,
                                ),
                              ),
                            ],
                          ),
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
