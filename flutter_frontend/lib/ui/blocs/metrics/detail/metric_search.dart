import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/common/square_dialog.dart';
import 'package:helse/ui/common/square_text_field.dart';

class MetricSearch extends StatefulWidget {
  final MetricType type;
  final int? person;
  const MetricSearch(this.type, {super.key, this.person});

  @override
  State<MetricSearch> createState() => _MetricSearchState();
}

class _MetricSearchState extends State<MetricSearch> {
  List<Metric> _metrics = [];
  final TextEditingController _value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context).colorScheme;
    return SquareDialog(
      title: Text(locale.searchItem(widget.type.name)),
      content: SizedBox(
        height: 500,
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SquareTextField(
                    theme: theme,
                    icon: Icons.add_sharp,
                    label: locale.value,
                    controller: _value,
                  ),
                ),
                IconButton(onPressed: _search, icon: Icon(Icons.search_sharp)),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: MetricDataTable(
                  locale: locale,
                  metrics: _metrics,
                  person: widget.person,
                  type: widget.type,
                  reset: _search,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _search() async {
    var metrics = await Dependencies.services.metric.searchMetrics(
      widget.person,
      SearchMetric(type: widget.type.id, value: _value.text),
    );
    setState(() {
      _metrics = metrics;
    });
  }
}
