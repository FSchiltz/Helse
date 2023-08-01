import 'package:flutter/material.dart';
import 'package:helse/ui/administration.dart';
import 'package:helse/ui/settings.dart';

import '../helpers/date.dart';
import '../main.dart';
import '../model/user.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'blocs/common/date_range_input.dart';
import 'blocs/events/events_add.dart';
import 'blocs/events/events_grid.dart';
import 'blocs/imports/file_import.dart';
import 'blocs/metrics/metric_add.dart';
import 'blocs/metrics/metrics_grid.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<MetricType> metricTypes = [];
  List<EventType> eventTypes = [];
  User? user;
  DateTimeRange date = DateHelper.now();

  @override
  void initState() {
    super.initState();
    _getEventData();
    _getMetricData();
    _getUser();
  }

  void _getUser() async {
    var model = await AppState.authenticationLogic?.getUser();
    if (model != null) {
      setState(() {
        user = model;
      });
    }
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

  void _setDate(DateTimeRange value) {
    setState(() {
      date = value;
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', style: Theme.of(context).textTheme.displayMedium),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: DateRangeInput(_setDate, date),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton(
                icon: const Icon(Icons.menu_sharp),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.upload_file_sharp),
                        title: Text("Import"),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.settings_sharp),
                        title: Text("Settings"),
                      ),
                    ),
                    if (user?.type == UserType.admin)
                      const PopupMenuItem<int>(
                        value: 2,
                        child: ListTile(
                          leading: Icon(Icons.admin_panel_settings_sharp),
                          title: Text("Administration"),
                        ),
                      ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Icons.logout_sharp),
                        title: Text("Logout"),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const FileImport();
                          });
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdministrationPage()),
                      );
                      break;
                    case 3:
                      AppState.authenticationLogic?.logOut();
                      break;
                  }
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              MetricsGrid(types: metricTypes, date: date),
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
              EventsGrid(date: date, types: eventTypes),
            ],
          ),
        ),
      ),
    );
  }
}
