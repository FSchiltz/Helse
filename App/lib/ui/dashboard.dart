import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/notification.dart';

import '../main.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'blocs/events/events_grid.dart';
import 'blocs/metrics/metrics_grid.dart';

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
    var model = await DI.metric?.metricsType();
    if (model != null) {
      setState(() {
        metricTypes = model;
      });
    }
  }

  void _getEventData() async {
    try {
      var model = await DI.event?.eventsType(all: true);
      if (model != null) {
        setState(() {
          eventTypes = model;
        });
      }
    } catch (ex) {
      Notify.show("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MetricsGrid(
                types: metricTypes,
                date: widget.date,
                person: widget.person),
            const SizedBox(
              height: 10,
            ),
            EventsGrid(
                date: widget.date,
                types: eventTypes,
                person: widget.person),
          ],
        ),
      ),
    );
  }
}
