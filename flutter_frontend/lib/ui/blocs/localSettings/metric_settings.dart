import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/metric_groups_settings.dart';
import 'package:helse/logic/settings/metrics_settings.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/statefull_check.dart';
import 'package:helse/ui/common/type_input.dart';

class MetricSettings extends StatefulWidget {
  const MetricSettings({super.key});

  @override
  State<MetricSettings> createState() => _MetricSettingsState();
}

class _MetricSettingsState extends State<MetricSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formGroupKey = GlobalKey();

  Future<List<OrderedItem>> _getData(bool refresh) async {
    return (await DI.settings.getMetrics()).metrics;
  }

  Future<List<OrderedItem>> _getGroupData(bool reset) async {
    return (await DI.settings.getMetricGroups()).metrics;
  }

  Future<void> _submitMetricGroups(List<OrderedItem> groups) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await DI.settings.saveMetricGroups(MetricGroupsSettings(groups));

        Notify.show("Saved Successfully");
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  Future<void> _submitMetrics(List<OrderedItem> metrics) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await DI.settings.saveMetrics(MetricsSettings(metrics));

        Notify.show("Saved Successfully");
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.post_add_sharp), text: 'Metrics'),
              Tab(icon: Icon(Icons.group_add_sharp), text: 'Metric Groups'),
            ],
          ),
          Flexible(
            child: TabBarView(
              children: [_metricsGrid(theme), _metricGroupsGrid(theme)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsGrid(ThemeData theme) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      await _submitMetrics(data);
                      reset();
                    },
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  child: DataTable(
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 60,
                    columns: [
                      DataColumn(label: Expanded(child: Text("Name"))),
                      DataColumn(label: Expanded(child: Text("Visible"))),
                      DataColumn(label: Expanded(child: Text("Widget type"))),
                      DataColumn(label: Expanded(child: Text("Detail type"))),
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
                                SizedBox(
                                  width: 160,
                                  height: 45,
                                  child: EnumInput(
                                    value: item.graph,
                                    GraphKind.values
                                        .map((x) => DropDownItem(x, x.name))
                                        .toList(),
                                    (value) => item.graph = value ?? item.graph,
                                    label: 'Type',
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
                                        .map((x) => DropDownItem(x, x.name))
                                        .toList(),
                                    (value) => item.detailGraph =
                                        value ?? item.detailGraph,
                                    label: 'Type',
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
      ),
    );
  }

  Widget _metricGroupsGrid(ThemeData theme) {
    return LoadingBuilder(
      _getGroupData,
      builder: (context, data, reset) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formGroupKey,
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
                        await _submitMetricGroups(data);
                        reset();
                      },
                      child: const Text("Save"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Expanded(child: Text("Name"))),
                        DataColumn(label: Expanded(child: Text("Visible"))),
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
          ),
        );
      },
    );
  }
}
