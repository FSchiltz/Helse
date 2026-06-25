import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/delete_metric.dart';
import 'package:helse/ui/blocs/metrics/metric_add.dart';
import 'package:helse/ui/common/pagination.dart';

class MetricDataTable extends StatefulWidget {
  const MetricDataTable({
    super.key,
    required this.count,
    this.person,
    required this.type,
    required this.reset,
    required this.callback,
  });
  final void Function() reset;
  final MetricType type;
  final int? person;
  final int count;
  final Future<List<Metric>> Function(int page, int count) callback;

  @override
  State<MetricDataTable> createState() => _MetricDataTableState();
}

class _MetricDataTableState extends State<MetricDataTable> {
  List<Metric> _metrics = [];
  List<Metric> _selected = [];
  int _page = 0;

  @override
  void initState() {
    super.initState();

    _search();
  }

  @override
  void didUpdateWidget(covariant MetricDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _page = 0;
    _metrics = [];
    _search();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Pagination(
          count: widget.count,
          pageSize: 50,
          page: _page,
          callBack: (v) {
            setState(() {
              _page = v;
            });
            _search();
          },
          selected: _selected.length,
          menu: [],
        ),
        DataTable(
          showCheckboxColumn: true,
          onSelectAll: (value) {
            if (value == true) {
              setState(() {
                _selected = _metrics.toList();
              });
            } else {
              setState(() {
                _selected = [];
              });
            }
          },
          columns: [
            DataColumn(label: Expanded(child: Text("Id"))),
            DataColumn(label: Expanded(child: Text(locale.value))),
            DataColumn(label: Expanded(child: Text(locale.date))),
            DataColumn(label: Expanded(child: Text(locale.tag))),
            DataColumn(label: Expanded(child: Text(locale.source))),
            DataColumn(label: Expanded(child: Text(""))),
          ],
          rows: _metrics.map((m) {
            return DataRow(
              selected: _selected.contains(m),
              onSelectChanged: (v) {
                setState(() {
                  if (v = true) {
                    _selected.add(m);
                  } else {
                    _selected.remove(m);
                  }
                });
              },
              cells: [
                DataCell(Text((m.id).toString())),
                DataCell(Text('${m.value} ${widget.type.unit.code}')),
                DataCell(
                  Text(DateHelper.format(m.date.toLocal(), context: context)),
                ),
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
                              return MetricAdd(
                                widget.type,
                                widget.reset,
                                person: widget.person,
                                edit: m,
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
                                await Dependencies.services.metric
                                    .deleteMetrics(m.id);
                                widget.reset();
                              }, person: widget.person);
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
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _search() async {
    if (widget.count > 0) {
      var metrics = await widget.callback(_page, 50);

      setState(() {
        _metrics = metrics;
      });
    } else {
      setState(() {
        _metrics = [];
      });
    }
  }
}
