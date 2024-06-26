import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/users.dart';
import '../helpers/date.dart';
import '../logic/d_i.dart';
import '../logic/event.dart';
import '../logic/fit/task_bloc.dart';
import '../logic/settings/settings_logic.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'administration.dart';
import 'blocs/imports/file_import.dart';
import 'common/date_range_picker.dart';
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

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

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
  DateTimeRange date = DateHelper.now();

  @override
  void initState() {
    super.initState();
    _getUser();
    _startFitJob(DI.fit);
    _setDefaultRange();
  }

  DeviceType getDevice() {
    return MediaQuery.of(context).size.width <= 800 ? DeviceType.mobile : DeviceType.desktop;
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

  void _setDate(DateTimeRange value) {
    setState(() {
      date = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page = switch (user?.type ?? UserType.patient) {
      UserType.patient => const Center(child: Text("Welcome")),
      UserType.admin => const Center(child: Text("Logged in as only admin")),
      _ => Dashboard(date: date, type: user?.type),
    };

    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);

      var isLargeScreen = MediaQuery.of(context).size.width > 600;

      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 10,
          elevation: 1,
          centerTitle: true,
          title: DateRangePicker(_setDate, date, isLargeScreen),
          actions: [
            BlocProvider<TaskBloc>.value(
              value: DI.fit,
              child: BlocBuilder<TaskBloc, SubmissionStatus>(builder: (context, state) {
                switch (state) {
                  case SubmissionStatus.success:
                    return HelseLoader(static: true, color: Colors.green, size: 22, onTouch: () => _showTasks(context));
                  case SubmissionStatus.failure:
                    return HelseLoader(static: true, color: Colors.red, size: 22, onTouch: () => _showTasks(context));
                  case SubmissionStatus.inProgress:
                    return HelseLoader(size: 32, onTouch: () => _showTasks(context));
                  default:
                    return HelseLoader(size: 20, static: true, onTouch: () => _showTasks(context));
                }
              }),
            ),
            PopupMenuButton(
                icon: Icon(Icons.menu_sharp, color: theme.colorScheme.onSurface),
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
                    if (user?.type?.isAdmin() == true)
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
                          });
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (context) => const LocalSettingsPage()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (context) => const AdministrationPage()),
                      );
                      break;
                    case 3:
                      DI.authentication.logOut();
                      break;
                  }
                })
          ],
        ),
        body: page,
      );
    });
  }

  Future<void> _startFitJob(TaskBloc fit) async {
    var settings = await SettingsLogic.getHealth();
    if (settings.syncHealth) {
      fit.start();
    }
  }

  void _showTasks(BuildContext context) {
    var tasks = DI.fit.executions;
    showDialog<void>(context: context, builder: (context) => TaskStatusDialog(tasks));
  }

  Future<void> _setDefaultRange() async {
    var range = await SettingsLogic.getDateRange();
    setState(() {
      date = DateHelper.getRange(range);
    });
  }
}
