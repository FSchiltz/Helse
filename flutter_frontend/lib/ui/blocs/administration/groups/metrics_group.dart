import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/groups/metric_group_add.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';

class MetricGroupView extends StatelessWidget {
  const MetricGroupView({super.key});

  Future<List<Group>> _getGroupData(bool refresh) async {
    return await Dependencies.services.metric.metricsGroup() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return LoadingBuilder(
      _getGroupData,
      builder: (context, data, reset) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
            ),
            Text(
              "Setup the default metric group information for new user. Those settings can be overidden by the user",
            ),
            SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  columns: [
                    DataColumn(label: Expanded(child: Text(locale.id))),
                    DataColumn(label: Expanded(child: Text(locale.name))),
                    DataColumn(
                      label: Expanded(child: Text(locale.description)),
                    ),
                    DataColumn(label: Expanded(child: Text(locale.visible))),
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
                                      await _deleteGroup(type, context);
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

  Future<void> _deleteGroup(Group type, BuildContext context) async {
    var id = type.id;
    try {
      if (id != null) {
        await Dependencies.services.metric.deleteMetricsGroup(id);
        Notify.showIcon(NotificationKind.success);
      }
    } catch (ex) {
      Notify.show(
        'Error deleting metric group ${type.name}',
        context: context.mounted ? context : null,
        kind: NotificationKind.error,
      );
    }
  }
}
