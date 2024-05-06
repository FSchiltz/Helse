import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/ui/theme/notification.dart';

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
    try {
      var model = await DI.metric?.metricsType();
      if (model != null) {
        var settings = await SettingsLogic.getMetrics();
        // filter using the user settings
        var filtered = model
            .where(( x) => settings.metrics
                .any((element) => element.id == x.id && element.visible))
            .toList();

        setState(() {
          metricTypes = filtered;
        });
        SettingsLogic.updateMetrics(model);
      }
    } catch (ex) {
      Notify.show("Error: $ex");
    }
  }

  void _getEventData() async {
    try {
      var model = await DI.event?.eventsType(all: true);
      if (model != null) {
         var settings = await SettingsLogic.getEvents();
        // filter using the user settings
        var filtered = model
            .where(( x) => settings.events
                .any((element) => element.id == x.id && element.visible))
            .toList();

        setState(() {
          eventTypes = filtered;
        });
        SettingsLogic.updateEvents(model);
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
                types: metricTypes, date: widget.date, person: widget.person),
            const SizedBox(
              height: 10,
            ),
            EventsGrid(
                date: widget.date, types: eventTypes, person: widget.person),
          ],
        ),
      ),
    );
  }
}
