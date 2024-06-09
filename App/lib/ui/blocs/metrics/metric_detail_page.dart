import 'package:flutter/material.dart';

import '../../../helpers/date.dart';
import '../../../logic/d_i.dart';
import '../../../logic/settings/ordered_item.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/loader.dart';
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
  List<Metric> _metrics = [];
  Future<List<Metric>?>? _dataFuture;
  Metric? _metric;

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

    _metrics = await DI.metric.metrics(id, start, end, person: widget.person, simple: false);

    return _metrics;
  }

  void _selectionChanged(Metric metric) {
    setState(() {
      _metric = metric;
    });
  }

  void _resetMetric() {
    setState(() {
      _metrics = [];
    });
    _dataFuture = _getData();
  }

  @override
  Widget build(BuildContext context) {
    var id = _metric?.id;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Detail of ${widget.type.name}', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return MetricAdd(widget.type, _resetMetric, person: widget.person);
                        });
                  },
                  icon: const Icon(Icons.add_sharp)),
            ),
          ],
        ),
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
                final metric = _metric;
                return metrics.isEmpty
                    ? Center(
                        child: Text("No data", style: Theme.of(context).textTheme.labelLarge),
                      )
                    : (widget.type.type == MetricDataType.text
                        ? SizedBox.expand(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0, top: 60.0),
                                child: CalendarView(metrics, widget.date)))
                        : Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  shadowColor: Theme.of(context).colorScheme.shadow,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Selected ${metric != null ? '(${metric.id})' : ''} :'),
                                        ),
                                       
                                        if (metric != null)
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(metric.$value.toString() + widget.type.unit.toString()),
                                          ),
                                           if (metric != null)
                                          const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('on'),
                                          ),
                                           if (metric != null)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(DateHelper.format(metric.date?.toLocal(), context: ctx)),
                                          ),
                                        if (metric != null)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(metric.tag.toString()),
                                          ),
                                        if (metric != null && metric.source != FileTypes.none)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('by ${metric.source}'),
                                          ),
                                        if (metric != null)
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                                onPressed: () {
                                                  showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return MetricAdd(widget.type, _resetMetric, person: widget.person, edit: metric);
                                                      });
                                                },
                                                icon: const Icon(Icons.edit_sharp)),
                                          ),
                                        if (id != null)
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                                onPressed: () {
                                                  showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return DeleteMetric(() async {
                                                          await DI.metric.deleteMetrics(id);
                                                          _resetMetric();
                                                          setState(() {
                                                            _metric = null;
                                                          });
                                                        }, person: widget.person);
                                                      });
                                                },
                                                icon: const Icon(Icons.delete_sharp)),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(fit: FlexFit.tight, child: MetricGraph(metrics, widget.date, widget.settings, _selectionChanged)),
                              ],
                            ),
                          ));
              }
            }

            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }
}

class DeleteMetric extends StatelessWidget {
  final Function callback;
  const DeleteMetric(this.callback, {super.key, int? person});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_sharp),
      title: const Text('Delete the metric ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await callback();
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
