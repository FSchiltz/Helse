import 'package:flutter/material.dart';

import '../main.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'blocs/events/events_add.dart';
import 'blocs/events/events_grid.dart';
import 'blocs/metrics/metric_add.dart';
import 'blocs/metrics/metrics_grid.dart';
import 'blocs/treatments/treatment_add.dart';
import 'blocs/treatments/treatments_grid.dart';

class Dashboard extends StatefulWidget {
  final DateTimeRange date;
  final int? person;
  const Dashboard({super.key, required this.date, this.person});

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
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Metrics", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        if (metricTypes.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MetricAdd(metricTypes, _resetMetric, person: widget.person);
                              });
                        }
                      },
                      icon: const Icon(Icons.add_sharp)),
                ],
              ),
            ),
            MetricsGrid(types: metricTypes, date: widget.date, person: widget.person),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Events", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        if (eventTypes.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EventAdd(_resetEvents, eventTypes, person: widget.person);
                              });
                        }
                      },
                      icon: const Icon(Icons.add_sharp)),
                ],
              ),
            ),
            EventsGrid(date: widget.date, types: eventTypes, person: widget.person),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Treatments", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        if (metricTypes.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TreatmentAdd(person: widget.person);
                              });
                        }
                      },
                      icon: const Icon(Icons.add_sharp)),
                ],
              ),
            ),
            TreatmentsGrid(date: widget.date, person: widget.person),
          ],
        ),
      ),
    );
  }
}
