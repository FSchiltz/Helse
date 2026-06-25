import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/common/inputs/date_input.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/loader.dart';
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
  final TextEditingController _value = TextEditingController();
  final TextEditingController _min = TextEditingController();
  final TextEditingController _max = TextEditingController();
  bool _working = false;
  DateTime? _from;
  DateTime? _to;
  int _count = 0;
  late SearchMetric _search;
  FileTypes? _source;

  @override
  void initState() {
    super.initState();
    _search = SearchMetric(type: widget.type.id);
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(locale.searchItem(widget.type.name))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.formPad),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: UIConstants.formPad,
                  runSpacing: UIConstants.formPad,
                  children: [
                    ..._getFilter(theme, locale),
                    DateInput(locale.start, _from, (v) => _from = v),
                    DateInput(locale.stop, _to, (v) => _to = v),
                    SizedBox(
                      width: 240,
                      child: ValuesInput(
                        value: _source,
                        FileTypes.values
                            .map(
                              (x) => DropdownItem(
                                x,
                                (x == FileTypes.swaggerGeneratedUnknown)
                                    ? "All"
                                    : x.name,
                              ),
                            )
                            .toList(),
                        (value) => setState(() {
                          _source = value;
                        }),
                        label: locale.source,
                      ),
                    ),
                    IconButton(
                      onPressed: (_working) ? null : _countEvents,
                      icon: Icon(Icons.search_sharp),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.formPad),
                if (_working) HelseLoader(),
                MetricDataTable(
                  count: _count,
                  person: widget.person,
                  type: widget.type,
                  reset: _countEvents,
                  callback: (page, count) async =>
                      await Dependencies.services.metric.searchMetrics(
                        widget.person,
                        _search,
                        page,
                        count,
                      ) ??
                      [],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _countEvents() async {
    setState(() {
      _working = true;
      _count = 0;
    });
    try {
      final max = _max.text.isEmpty ? null : int.parse(_max.text);
      final min = _min.text.isEmpty ? null : int.parse(_min.text);
      final text = (_value.text.isEmpty) ? null : _value.text;
      FileTypes source = _source ?? FileTypes.none;
      if (_source == FileTypes.swaggerGeneratedUnknown) {
        source = FileTypes.none;
      }

      final search = SearchMetric(
        type: widget.type.id,
        value: text,
        maxValue: max,
        minValue: min,
        from: _from,
        to: _to,
        source: source,
        filterSource:
            _source != null && _source != FileTypes.swaggerGeneratedUnknown,
      );
      var events = await Dependencies.services.metric.countMetrics(
        widget.person,
        search,
      );
      setState(() {
        _count = events ?? 0;
        _search = search;
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
        SquareTextField(
          icon: Icons.add_sharp,
          label: locale.value,
          controller: _value,
        ),
      ];
    }

    if (widget.type.type == MetricDataType.number) {
      return [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: SquareTextField(
            icon: Icons.arrow_downward_sharp,
            label: locale.min,
            controller: _min,
            type: TextInputType.number,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
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
