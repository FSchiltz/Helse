import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/ui/blocs/metrics/metric_detail.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../common/loader.dart';
import 'metric_add.dart';
import 'metric_condensed.dart';

class MetricWidget extends StatefulWidget {
  final MetricType type;
  final DateTimeRange date;
  final int? person;
  final OrderedItem settings;

  const MetricWidget(this.type, this.settings, this.date, {super.key, this.person});

  @override
  State<MetricWidget> createState() => _MetricWidgetState();
}

class _MetricWidgetState extends State<MetricWidget> {
  List<Metric>? _metrics;

  _MetricWidgetState();

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

    _metrics = await DI.metric?.metrics(id, start, end, person: widget.person, simple: true);

    return _metrics;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      clipBehavior: Clip.hardEdge,
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
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (context) => MetricDetailPage(
                              date: widget.date,
                              type: widget.type,
                              person: widget.person,
                              settings:  widget.settings.detailGraph,
                            )),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 1, right: 1),
                    child: Column(
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(widget.type.name ?? "", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                              ),
                              Flexible(
                                child: SizedBox(
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
                              ),
                            ],
                          ),
                        ),
                        if (metrics.isNotEmpty)
                          Expanded(
                            child: Text(_getTextInfo(metrics, widget.type), style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        Flexible(child: MetricCondensed(metrics, widget.type, widget.settings, widget.date)),
                      ],
                    ),
                  ),
                );
              }
            }
            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }

  String _getTextInfo(List<Metric> metrics, MetricType type) {
    String? value;
    switch (type.summaryType) {
      case MetricSummary.sum:
        value = metrics.map((metric) => double.parse(metric.$value ?? '0')).sum.toString();
        break;
      case MetricSummary.mean:
        value = (metrics.map((metric) => double.parse(metric.$value ?? '0')).sum / metrics.length).round().toString();
        break;
      case MetricSummary.latest:
      default:
        value = metrics.last.$value ?? '';
        break;
    }

    if (type.unit != null) {
      value += ' ${type.unit}';
    }

    return value;
  }
}
