import 'package:flutter/material.dart';

import '../../../logic/d_i.dart';
import '../../../logic/settings/ordered_item.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/loader.dart';
import '../calendar/calendar_view.dart';
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
  List<Metric> _metrics = [];

  Future<List<Metric>?>? _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _getData();
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

    _metrics = await DI.metric?.metrics(id, start, end, person: widget.person, simple: false) ?? [];


    return _metrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
        //child: DateRangeInput((x) => {}, date),
      ),
      body: FutureBuilder(
          future: _dataFuture,
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
                          : MetricGraph(metrics, widget.date, widget.settings)),
                ));
              }
            }

            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }
}
