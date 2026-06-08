import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'metric_type_add.dart';

class MetricTypeView extends StatelessWidget {
  const MetricTypeView({super.key});

  Future<List<MetricType>> _getData(bool refresh) async {
    return await Dependencies.services.metric.metricsType(true, null) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "Metric Types",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return MetricTypeAdd(reset);
                        },
                      );
                    },
                    icon: const Icon(Icons.add_sharp),
                  ),
                ],
              ),
            ),
            Text(
              "Setup the default metric type information for new user. Those settings can be overidden by the user",
            ),
            Flexible(
              child: SingleChildScrollView(
                child: FittedBox(
                  child: DataTable(
                    columns:  [
                      DataColumn(label: Expanded(child: Text(locale.id))),
                      DataColumn(label: Expanded(child: Text(locale.name))),
                      DataColumn(label: Expanded(child: Text(locale.description))),
                      DataColumn(label: Expanded(child: Text("Unit"))),
                      DataColumn(label: Expanded(child: Text(locale.type))),
                      DataColumn(label: Expanded(child: Text("Summary"))),
                      DataColumn(label: Expanded(child: Text(locale.visible))),
                      DataColumn(
                        label: Expanded(child: Text("Show on dashboard")),
                      ),
                      DataColumn(label: Expanded(child: Text("Group"))),
                      DataColumn(label: Expanded(child: Text(""))),
                    ],
                    rows: data
                        .map(
                          (type) => DataRow(
                            cells: [
                              DataCell(Text((type.id).toString())),
                              DataCell(Text(type.name)),
                              DataCell(Text(type.description ?? "")),
                              DataCell(Text(type.unit.code)),
                              DataCell(Text(type.type?.name ?? "")),
                              DataCell(Text(type.summaryType?.name ?? "")),
                              DataCell(
                                Checkbox(value: type.visible, onChanged: null),
                              ),
                              DataCell(
                                Checkbox(
                                  value: type.showOnDashboard,
                                  onChanged: null,
                                ),
                              ),
                              DataCell(Text(type.groupId.toString())),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MetricTypeAdd(
                                              reset,
                                              edit: type,
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit_sharp),
                                    ),
                                    if (type.userEditable == true)
                                      IconButton(
                                        onPressed: () async {
                                          await _deleteType(type);
                                          reset();
                                        },
                                        icon: const Icon(Icons.delete_sharp),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteType(MetricType type) async {
    var id = type.id;
    try {
      await Dependencies.services.metric.deleteMetricsType(id);
      Notify.show('Metric ${type.name} deleted');
    } catch (ex) {
      Notify.showError('Error deleting metric ${type.name}');
    }
  }
}
