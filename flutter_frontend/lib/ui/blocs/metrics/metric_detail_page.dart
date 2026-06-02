import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../calendar/calendar_view.dart';
import 'metric_add.dart';
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
    var id = widget.type.id;
    if (id == null) {
      return [];
    }

    var date = widget.date;

    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(
      date.end.year,
      date.end.month,
      date.end.day,
    ).add(const Duration(days: 1));

    return await Dependencies.services.metric.metrics(
      id,
      start,
      end,
      person: widget.person,
      simple: false,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 32,
              child: IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return MetricAdd(
                        widget.type,
                        _resetMetric,
                        person: widget.person,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add_sharp),
              ),
            ),
          ),
        ],
        title: Text(
          Translation.locale(context).detailof(widget.type.name),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: LoadingBuilder(
        _getData,
        builder: (ctx, data, reset) {
          Future<List<CalendarEvent>> getEventsForDay(DateTime day) async {
            return data
                .where(
                  (x) =>
                      day.year == x.date.year &&
                      day.month == x.date.month &&
                      day.day == x.date.day,
                )
                .map(
                  (x) =>
                      CalendarEvent(from: x.date, to: x.date, value: x.value),
                )
                .toList();
          }

          return data.isEmpty
              ? Center(
                  child: Text(
                    Translation.locale(context).nodata,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              : (widget.type.type == MetricDataType.text ||
                        widget.settings == GraphKind.text
                    ? CalendarView(getEventsForDay, widget.date)
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
}
