import 'package:flutter/material.dart';

import '../main.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'blocs/events/events_add.dart';
import 'blocs/events/events_grid.dart';
import 'blocs/metrics/metric_add.dart';
import 'blocs/metrics/metrics_grid.dart';

class Dashboard extends StatefulWidget {
  final DateTimeRange date;
  const Dashboard({Key? key, required this.date}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<MetricType> metricTypes = [];
  List<EventType> eventTypes = [];

  @override
  void initState() {
    super.initState();
    _getEventData();
    _getMetricData();
  }

  void _getMetricData() async {
    var model = await AppState.metricsLogic?.getType();
    if (model != null) {
      setState(() {
        metricTypes = model;
      });
    }
  }

  void _getEventData() async {
    var model = await AppState.eventLogic?.getType();
    if (model != null) {
      setState(() {
        eventTypes = model;
      });
    }
  }

  void _resetMetric() {
    setState(() {
      metricTypes = [];
    });
    _getMetricData();
  }

  void _resetEvents() {
    setState(() {
      eventTypes = [];
    });
    _getEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Metrics", style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        if (metricTypes.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MetricAdd(metricTypes, _resetMetric);
                              });
                        }
                      },
                      icon: const Icon(Icons.add_sharp)),
                ],
              ),
            ),
            MetricsGrid(types: metricTypes, date: widget.date),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Events", style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        if (eventTypes.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EventAdd(_resetEvents, eventTypes);
                              });
                        }
                      },
                      icon: const Icon(Icons.add_sharp)),
                ],
              ),
            ),
            EventsGrid(date: widget.date, types: eventTypes),
          ],
        ),
      ),
    );
  }
}
