import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/delete_metric.dart';
import 'package:helse/ui/blocs/metrics/detail/metrics_edit.dart';
import 'package:helse/ui/common/async_data_table.dart';
import 'package:helse/ui/common/ui_constants.dart';

class MetricDataTable extends AsyncDataTable<Metric> {
  const MetricDataTable({
    super.key,
    required super.count,
    this.person,
    required this.type,
    required super.reset,
    required super.callback,
  });
  final MetricType type;
  final int? person;

  @override
  State<MetricDataTable> createState() => _MetricDataTableState();
}

class _MetricDataTableState
    extends AsyncDataTableState<Metric, MetricDataTable> {
  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    final extended = !UIHelpers.isMobile(context);

    final List<Widget> menu = selected.isEmpty
        ? []
        : [
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return MetricsEdit(
                      widget.type,
                      widget.reset,
                      person: widget.person,
                      edit: selected,
                    );
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
                      await Dependencies.services.metric.deleteMetrics(
                        selected,
                        person: widget.person,
                      );
                      widget.reset();
                    }, person: widget.person);
                  },
                );
              },
              icon: const Icon(Icons.delete_sharp),
            ),
          ];
    final columns = [
      if (extended) DataColumn(label: Expanded(child: Text(locale.id))),
      DataColumn(label: Expanded(child: Text(locale.value))),
      DataColumn(label: Expanded(child: Text(locale.date))),
      if (extended) DataColumn(label: Expanded(child: Text(locale.tag))),
      if (extended) DataColumn(label: Expanded(child: Text(locale.source))),
      DataColumn(label: Expanded(child: Text(""))),
    ];

    return buildTable(columns, _builder, menu, extended);
  }

  List<DataRow> _builder(
    List<Metric> items,
    List<Metric> selected,
    bool extended,
  ) {
    return items.map((m) {
      return DataRow(
        selected: selected.contains(m),
        onSelectChanged: (v) {
          setState(() {
            if (v = true) {
              selected.add(m);
            } else {
              selected.remove(m);
            }
          });
        },
        cells: [
          if (extended) DataCell(Text((m.id).toString())),
          DataCell(Text('${m.value} ${widget.type.unit.code}')),
          DataCell(Text(DateHelper.format(m.date.toLocal(), context: context))),
          if (extended) DataCell(Text(m.tag.toString())),
          if (extended) DataCell(Text(m.source?.name ?? '')),
          DataCell(
            Row(
              children: MetricHelper.getButtons(
                m,
                widget.type,
                widget.reset,
                context: context,
                person: widget.person,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
