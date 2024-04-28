import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../loader.dart';
import 'metric_add.dart';
import 'metric_graph.dart';

class MetricWidget extends StatefulWidget {
  final MetricType type;
  final DateTimeRange date;
  final int? person;

  const MetricWidget(this.type, this.date, {super.key, this.person});

  @override
  State<MetricWidget> createState() => _MetricWidgetState();
}

class _MetricWidgetState extends State<MetricWidget> {
  List<Metric>? _metrics;

  _MetricWidgetState();

  @override
  void initState() {
    _metrics = null;
    super.initState();
  }

  int _sort(Metric m1, Metric m2) {
    var a = m1.date;
    var b = m2.date;
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return -1;
    } else if (b == null) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  }

  void _resetMetric() {
    setState(() {
      _metrics = [];
    });
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

    _metrics = await AppState.metric?.metrics(id, start, end, person: widget.person);
    _metrics?.sort(_sort);
    return _metrics;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
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
                final last = metrics.isNotEmpty ? metrics.last : null;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(widget.type.name ?? "", style: Theme.of(context).textTheme.titleMedium),
                          if (last != null) Text((last.$value ?? "") + (widget.type.unit ?? ""), style: Theme.of(context).textTheme.labelMedium),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MetricAdd(widget.type, _resetMetric, person: widget.person);
                                    });
                              },
                              icon: const Icon(Icons.add_sharp)),
                        ],
                      ),
                      Expanded(
                        child: MetricGraph(metrics, widget.type.unit, widget.date),
                      )
                    ],
                  ),
                );
              }
            }
            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }
}
