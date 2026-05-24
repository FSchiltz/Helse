import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/blocs/administration/metrics/metric_group_add.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';

class MetricGroupView extends StatelessWidget {
  const MetricGroupView({super.key});

  Future<List<MetricGroup>> _getGroupData(bool refresh) async {
    return await DI.metric.metricsGroup() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getGroupData,
      builder: (context, data, reset) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "Metric Groups",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return MetricGroupAdd(reset);
                      },
                    );
                  },
                  icon: const Icon(Icons.add_sharp),
                ),
              ],
            ),
            SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Expanded(child: Text("Id"))),
                    DataColumn(label: Expanded(child: Text("Name"))),
                    DataColumn(label: Expanded(child: Text("Description"))),
                    DataColumn(label: Expanded(child: Text("Show title"))),
                    DataColumn(
                      label: Expanded(child: Text("Show on dashboard")),
                    ),
                    DataColumn(label: Expanded(child: Text(""))),
                  ],
                  rows: data
                      .map(
                        (type) => DataRow(
                          cells: [
                            DataCell(Text((type.id).toString())),
                            DataCell(Text(type.name)),
                            DataCell(Text(type.description)),
                            DataCell(
                              Checkbox(
                                value: type.showTitle ?? false,
                                onChanged: null,
                              ),
                            ),
                            DataCell(
                              Checkbox(
                                value: type.showOnDashboard ?? false,
                                onChanged: null,
                              ),
                            ),
                
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MetricGroupAdd(
                                            reset,
                                            edit: type,
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.edit_sharp),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await _deleteGroup(type);
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
          ],
        );
      },
    );
  }

  Future<void> _deleteGroup(MetricGroup type) async {
    var id = type.id;
    try {
      if (id != null) {
        await DI.metric.deleteMetricsGroup(id);
        Notify.show('Metric group ${type.name} deleted');
      }
    } catch (ex) {
      Notify.showError('Error deleting metric group ${type.name}');
    }
  }
}
