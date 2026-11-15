import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_text_display.dart';
import 'package:helse/ui/blocs/metrics/metric_add_button.dart';
import 'package:helse/ui/blocs/metrics/metric_search_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'metric_number_display.dart';

class MetricDetailPage extends StatefulWidget {
  const MetricDetailPage({
    super.key,
    required this.date,
    required this.type,
    required this.settings,
    required this.person,
    required this.summary,
  });

  final DateTimeRange date;
  final MetricType type;
  final GraphKind settings;
  final int? person;
  final MetricSummaries summary;

  @override
  State<MetricDetailPage> createState() => _MetricDetailPageState();
}

class _MetricDetailPageState extends State<MetricDetailPage> {
  int _refreshVersion = 0;

  void _resetMetric() {
    setState(() {
      _refreshVersion++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MetricSearchButton(widget.type, person: widget.person),
          const SizedBox(width: UIConstants.formPad),
          MetricAddButton(widget.type, _resetMetric, person: widget.person),
          const SizedBox(width: UIConstants.formPad),
        ],
        title: Text(
          Translation.of(context).detailof(widget.type.name),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              (widget.type.type == MetricDataType.text ||
                  widget.settings == GraphKind.text
              ? MetricTextDisplay(
                  widget.date,
                  key: ValueKey(_refreshVersion),
                  type: widget.type,
                  person: widget.person,
                )
              : MetricNumberDisplay(
                  widget.date,
                  widget.settings,
                  key: ValueKey(_refreshVersion),
                  person: widget.person,
                  type: widget.type,
                )),
        ),
      ),
    );
  }
}
