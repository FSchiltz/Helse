import 'package:flutter/material.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_source.dart';

class MetricDataTable extends StatelessWidget {
  const MetricDataTable({
    super.key,
    required this.locale,
    required this.metrics,
    this.person,
    required this.type,
    required this.reset,
  });
  final void Function() reset;
  final MetricType type;
  final int? person;
  final AppLocalizations locale;
  final List<Metric>? metrics;

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
        metrics ?? [],
        context,
        person,
        type,
        reset: reset,
      ),
    );
  }
}
