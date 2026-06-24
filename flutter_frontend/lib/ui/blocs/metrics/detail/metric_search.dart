import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/common/inputs/date_input.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/ui_constants.dart';

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
  final TextEditingController _min = TextEditingController();
  final TextEditingController _max = TextEditingController();
  bool _working = false;
  DateTime? _from;
  DateTime? _to;

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context).colorScheme;
    return SquareDialog(
      title: Text(locale.searchItem(widget.type.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: UIConstants.formPad,
            runSpacing: UIConstants.formPad,
            children: [
              ..._getFilter(theme, locale),
              DateInput(locale.start, _from, (v) => _from = v),
              DateInput(locale.stop, _to, (v) => _to = v),
              IconButton(
                onPressed: (_working) ? null : _search,
                icon: Icon(Icons.search_sharp),
              ),
            ],
          ),
          SizedBox(height: UIConstants.formPad),
          if (_working) HelseLoader(),
          Expanded(
            child: SingleChildScrollView(
              child: MetricDataTable(
                metrics: _metrics,
                person: widget.person,
                type: widget.type,
                reset: _search,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _search() async {
    setState(() {
      _working = true;
    });
    try {
      final max = _max.text.isEmpty ? null : int.parse(_max.text);
      final min = _min.text.isEmpty ? null : int.parse(_min.text);
      final text = (_value.text.isEmpty) ? null : _value.text;
      var metrics = await Dependencies.services.metric.searchMetrics(
        widget.person,
        SearchMetric(
          type: widget.type.id,
          value: text,
          maxValue: max,
          minValue: min,
          from: _from,
          to: _to,
        ),
      );
      setState(() {
        _metrics = metrics ?? [];
      });
    } finally {
      setState(() {
        _working = false;
      });
    }
  }

  List<Widget> _getFilter(ColorScheme theme, AppLocalizations locale) {
    if (widget.type.type == MetricDataType.text) {
      return [
        Expanded(
          child: SquareTextField(
            icon: Icons.add_sharp,
            label: locale.value,
            controller: _value,
          ),
        ),
      ];
    }

    if (widget.type.type == MetricDataType.number) {
      return [
        Flexible(
          child: SquareTextField(
            icon: Icons.arrow_downward_sharp,
            label: locale.min,
            controller: _min,
            type: TextInputType.number,
          ),
        ),
        Flexible(
          child: SquareTextField(
            icon: Icons.arrow_upward_sharp,
            label: locale.max,
            controller: _max,
            type: TextInputType.number,
          ),
        ),
      ];
    }

    return [Text("No filters for this type")];
  }
}
