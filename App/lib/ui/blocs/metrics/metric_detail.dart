import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/blocs/calendar/calendar_view.dart';
import 'package:helse/ui/blocs/metrics/metric_condensed.dart';
import 'package:helse/ui/blocs/metrics/metric_graph.dart';

import '../../../logic/d_i.dart';
import '../../../logic/settings/ordered_item.dart';
import '../../common/date_range_input.dart';
import '../../common/loader.dart';

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
  DateTimeRange? _date;
  List<Metric> _metrics = [];
  List<Metric>? _allMetrics;

  @override
  void initState() {
    super.initState();
    var date = DateTimeRange(start: widget.date.start, end: widget.date.start.add(const Duration(days: 1)));
    _date = date;
    _metrics = _filter(_metrics, date);
  }

  Future<List<Metric>?> _getData() async {
    var id = widget.type.id;
    if (id == null) {
      _metrics = List<Metric>.empty();
      return _metrics;
    }

    var date = widget.date;

    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(date.end.year, date.end.month, date.end.day).add(const Duration(days: 1));

    _allMetrics = await DI.metric?.metrics(id, start, end, person: widget.person, simple: false);

    return _allMetrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: FutureBuilder(
          future: _getData(),
          builder: (ctx, snapshot) {
            // Checking if future is resolved
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final metrics = snapshot.data as List<Metric>;
                return SizedBox.expand(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0, top: 60.0),
                  child: metrics.isEmpty
                      ? Center(
                          child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
                        )
                      : (widget.type.type == MetricDataType.text
                          ? CalendarView(metrics, widget.date)
                          : Column(
                              children: [
                                SizedBox(height: 80, child: WidgetGraph(widget.summary, widget.date, GraphKind.line, highlight: _date,)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: DateRangeInput(
                                        _setDate,
                                        _date ?? widget.date,
                                        true,
                                        range: widget.date,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: MetricGraph(_metrics, _date!, widget.settings)),
                              ],
                            )),
                ));
              }
            }

            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }

  void _setDate(DateTimeRange date) {
    var metrics = _filter(_allMetrics ?? [], date);
    setState(() {
      _date = date;
      _metrics = metrics;
    });
  }

  List<Metric> _filter(List<Metric> metrics, DateTimeRange date) {
    return metrics.where((metric) => (metric.date!.compareTo(date.start) >= 0 && metric.date!.compareTo(date.end) <= 0)).toList();
  }
}
