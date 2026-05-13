import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/metric_groups_settings.dart';
import 'package:helse/logic/settings/metrics_settings.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/ui/common/loader.dart';
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

  List<OrderedItem> _metrics = [];
  List<OrderedItem> _metricGroups = [];

  Future<int> _getData() async {
    _metrics = (await DI.settings.getMetrics()).metrics;

    return 1;
  }

  Future<int> _getGroupData() async {
    _metricGroups = (await DI.settings.getMetricGroups()).metrics;

    return 1;
  }

  void _submitMetricGroups() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await DI.settings.saveMetricGroups(MetricGroupsSettings(_metricGroups));

        Notify.show("Saved Successfully");
        _getData();
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  void _submitMetrics() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await DI.settings.saveMetrics(MetricsSettings(_metrics));

        Notify.show("Saved Successfully");
        _getData();
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _metricsGrid(theme),
            SizedBox(height: 32),
            _metricGroupsGrid(theme),
          ],
        ),
      ),
    );
  }

  FutureBuilder<int> _metricsGrid(ThemeData theme) {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) {
        // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
            // if we got our data
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Metrics",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(width: 32),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed: _submitMetrics,
                            child: const Text("Save"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DataTable(
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 60,
                      columns: [
                        DataColumn(label: Expanded(child: Text("Name"))),
                        DataColumn(label: Expanded(child: Text("Visible"))),
                        DataColumn(label: Expanded(child: Text("Widget tyoe"))),
                        DataColumn(label: Expanded(child: Text("Detail type"))),
                      ],
                      rows: _metrics
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
                                      (value) =>
                                          item.graph = value ?? item.graph,
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
                  ],
                ),
              ),
            );
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
      },
    );
  }

  FutureBuilder<int> _metricGroupsGrid(ThemeData theme) {
    return FutureBuilder(
      future: _getGroupData(),
      builder: (context, snapshot) {
        // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
            // if we got our data
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formGroupKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Metric Groups",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(width: 32),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed: _submitMetricGroups,
                            child: const Text("Save"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DataTable(
                      columns: [
                        DataColumn(label: Expanded(child: Text("Name"))),
                        DataColumn(label: Expanded(child: Text("Visible"))),
                      ],
                      rows: _metricGroups
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
                  ],
                ),
              ),
            );
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
      },
    );
  }
}
