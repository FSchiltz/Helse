import 'package:flutter/material.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_source.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_graph.dart';
import 'package:helse/ui/blocs/metrics/metric_group.dart';

class MetricDataTable extends StatelessWidget {
  const MetricDataTable({
    super.key,
    required this.locale,
    required this.metric,
    required this.widget,
  });

  final AppLocalizations locale;
  final MetricGrouped? metric;
  final MetricGraph widget;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      rowsPerPage: 50,
      showEmptyRows: false,
      primary: true,
      columns: [
        DataColumn(label: Expanded(child: Text("Id"))),
        DataColumn(label: Expanded(child: Text(locale.value))),
        DataColumn(label: Expanded(child: Text(locale.date))),
        DataColumn(label: Expanded(child: Text(locale.tag))),
        DataColumn(label: Expanded(child: Text(locale.source))),
        DataColumn(label: Expanded(child: Text(""))),
      ],
      source: MetricDataSource(
        metric?.metrics ?? [],
        context,
        widget.person,
        widget.type,
        reset: widget.reset,
      ),
    );
  }
}
