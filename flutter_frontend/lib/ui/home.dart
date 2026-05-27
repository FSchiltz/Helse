import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/import_logic.dart';

import '../logic/d_i.dart';
import '../logic/event.dart';
import '../logic/fit/task_bloc.dart';
import '../services/swagger/generated_code/helseapi.swagger.dart';
import 'administration.dart';
import 'blocs/imports/file_import.dart';
import 'common/loader.dart';
import 'common/notification.dart';
import 'dashboard.dart';
import 'local_settings.dart';
import 'task_status_dialog.dart';

class DataModel {
  final String label;
  final IconData icon;
  const DataModel({required this.label, required this.icon});
}

enum DeviceType { mobile, tablet, desktop }

class Home extends StatefulWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Person? user;
  var selectedIndex = 0;
  Key _refreshKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _getUser();
    _startFitJob(DI.fit);
    _startTaskResultJob(DI.jobs);
  }

  DeviceType getDevice() {
    return MediaQuery.of(context).size.width <= 800
        ? DeviceType.mobile
        : DeviceType.desktop;
  }

  void _getUser() async {
    try {
      var model = await DI.authentication.getUser();
      setState(() {
        user = model;
      });
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var types = user?.types ?? [];
    return LayoutBuilder(
      builder: (context, constraints) {
        var theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 10,
            elevation: 1,
            centerTitle: true,
            actions: [
              BlocProvider<TaskBloc>.value(
                value: DI.jobs,
                child: BlocBuilder<TaskBloc, SubmissionStatus>(
                  builder: (context, state) {
                    switch (state) {
                      case SubmissionStatus.success:
                        return HelseLoader(
                          static: true,
                          color: Colors.green,
                          size: 22,
                          onTouch: () => _showJobs(context),
                        );
                      case SubmissionStatus.failure:
                        return HelseLoader(
                          static: true,
                          color: Colors.red,
                          size: 22,
                          onTouch: () => _showJobs(context),
                        );
                      case SubmissionStatus.inProgress:
                        return HelseLoader(
                          size: 32,
                          onTouch: () => _showJobs(context),
                        );
                      default:
                        return HelseLoader(
                          size: 20,
                          static: true,
                          onTouch: () => _showJobs(context),
                        );
                    }
                  },
                ),
              ),

              BlocProvider<TaskBloc>.value(
                value: DI.fit,
                child: BlocBuilder<TaskBloc, SubmissionStatus>(
                  builder: (context, state) {
                    switch (state) {
                      case SubmissionStatus.success:
                        return HelseLoader(
                          static: true,
                          color: Colors.green,
                          size: 22,
                          onTouch: () => _showSynchroRuns(context),
                        );
                      case SubmissionStatus.failure:
                        return HelseLoader(
                          static: true,
                          color: Colors.red,
                          size: 22,
                          onTouch: () => _showSynchroRuns(context),
                        );
                      case SubmissionStatus.inProgress:
                        return HelseLoader(
                          size: 32,
                          onTouch: () => _showSynchroRuns(context),
                        );
                      default:
                        return HelseLoader(
                          size: 20,
                          static: true,
                          onTouch: () => _showSynchroRuns(context),
                        );
                    }
                  },
                ),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.menu_sharp,
                  color: theme.colorScheme.onSurface,
                ),
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
                    if (types.contains(UserType.admin) == true)
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
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return const FileImport();
                        },
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const LocalSettingsPage(),
                        ),
                      ).then(
                        (c) => setState(() {
                          _refreshKey = UniqueKey();
                        }),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const AdministrationPage(),
                        ),
                      ).then(
                        (c) => setState(() {
                          _refreshKey = UniqueKey();
                        }),
                      );
                      break;
                    case 3:
                      DI.authentication.logOut();
                      break;
                  }
                },
              ),
            ],
          ),
          body: Dashboard(types: types, key: _refreshKey),
        );
      },
    );
  }

  Future<void> _startFitJob(TaskBloc fit) async {
    var settings = await DI.settings.getHealth();
    if (settings.syncHealth) {
      fit.start();
    }
  }

  Future<void> _startTaskResultJob(TaskBloc jobs) async {
    jobs.start();
    var existingJobs = await DI.import.getJobs();
    for (var job in existingJobs) {
      DI.importLogic.jobs[job.id] = JobCheckResult(job.result, DateTime.now());
    }
  }

  void _showSynchroRuns(BuildContext context) {
    var tasks = DI.fit.executions;
    _showTaskDialog(context, tasks, 'Health sync history');
  }

  void _showJobs(BuildContext context) {
    var tasks = DI.importLogic.executions();
    _showTaskDialog(context, tasks, 'File import history');
  }

  void _showTaskDialog(
    BuildContext context,
    List<Execution> tasks,
    String title,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => TaskStatusDialog(tasks, title),
    );
  }
}
