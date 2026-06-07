import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/delete_metric.dart';
import 'package:helse/ui/blocs/metrics/metric_add.dart';

class MetricDataSource extends DataTableSource {
  final List<Metric> metrics;
  final BuildContext context;
  final int? person;
  final MetricType type;
  final void Function() reset;

  MetricDataSource(
    this.metrics,
    this.context,
    this.person,
    this.type, {
    required this.reset,
  });

  @override
  DataRow? getRow(int index) {
    var m = metrics[index];
    return DataRow(
      cells: [
        DataCell(Text((m.id).toString())),
        DataCell(Text('${m.value} ${type.unit.code}')),
        DataCell(Text(DateHelper.format(m.date.toLocal(), context: context))),
        DataCell(Text(m.tag.toString())),
        DataCell(Text(m.source.toString())),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return MetricAdd(type, reset, person: person, edit: m);
                    },
                  );
                },
                icon: const Icon(Icons.edit_sharp),
              ),
              IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteMetric(() async {
                        await Dependencies.services.metric.deleteMetrics(m.id);
                        reset();
                      }, person: person);
                    },
                  );
                },
                icon: const Icon(Icons.delete_sharp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => metrics.length;

  @override
  int get selectedRowCount => 0;
}
