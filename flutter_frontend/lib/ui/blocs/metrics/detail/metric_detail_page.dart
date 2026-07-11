import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_text_display.dart';
import 'package:helse/ui/blocs/metrics/metric_add_button.dart';
import 'package:helse/ui/blocs/metrics/metric_search_button.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../di/dependencies.dart';
import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'metric_graph.dart';

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
  @override
  void initState() {
    super.initState();
  }

  Future<List<Metric>> _getData(bool refresh) async {
    return await Dependencies.services.metric.metrics(
      widget.type.id,
      widget.date.start,
      widget.date.end,
      person: widget.person,
    );
  }

  void _resetMetric() {
    setState(() {
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

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
          child: LoadingBuilder(
            _getData,
            builder: (ctx, data, reset) {
              return data.isEmpty
                  ? Center(
                      child: Text(
                        Translation.of(context).nodata,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    )
                  : (widget.type.type == MetricDataType.text ||
                            widget.settings == GraphKind.text
                        ? MetricTextDisplay(
                            data,
                            widget.date,
                            widget.type,
                            person: widget.person,
                            reset: reset,
                          )
                        : MetricGraph(
                            data,
                            widget.date,
                            widget.settings,
                            reset,
                            person: widget.person,
                            type: widget.type,
                          ));
            },
          ),
        ),
      ),
    );
  }
}
