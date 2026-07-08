import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/metrics/metric_add_button.dart';
import 'package:helse/ui/blocs/metrics/metric_search_button.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../di/dependencies.dart';
import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/calendar_view.dart';
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
  final List<Metric> summary;

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
      tile: null,
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
      body: LoadingBuilder(
        _getData,
        builder: (ctx, data, reset) {
          Future<List<CalendarGroup<Metric>>> getEventsForDay(
            DateTime day,
          ) async {
            return [CalendarGroup(name: '', events: _map(data, day))];
          }

          return data.isEmpty
              ? Center(
                  child: Text(
                    Translation.of(context).nodata,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              : (widget.type.type == MetricDataType.text ||
                        widget.settings == GraphKind.text
                    ? CalendarView<Metric>(
                        getEventsForDay,
                        widget.date,
                        getEvents: (day) => _map(data, day),
                        build: _buildMetricDetail,
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
    );
  }

  List<CalendarEvent<Metric>> _map(List<Metric> data, DateTime day) {
    return data
        .where(
          (e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day,
        )
        .map((x) => CalendarEvent(from: x.date, to: x.date, value: x))
        .toList();
  }

  Widget _buildMetricDetail(BuildContext context, CalendarEvent<Metric> e) {
    final m = e.value;
    final extended = !UIHelpers.isMobile(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: UIConstants.textPad,
      children: [
        Text('${m.value} ${widget.type.unit.code}'),
        Text(DateHelper.format(m.date.toLocal(), context: context)),
        if (extended) Text(m.tag.toString()),
        if (extended && m.source != ImportTypes.none)
          Text(m.source?.name ?? ''),

        Row(
          children: MetricHelper.getButtons(
            m,
            widget.type,
            _resetMetric,
            context: context,
            person: widget.person,
          ),
        ),
      ],
    );
  }
}
