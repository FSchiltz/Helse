import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/ui/common/progress_icon_button.dart';
import 'package:helse/ui/server_job_dialog.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../di/dependencies.dart';
import '../logic/task_bloc.dart';
import '../services/swagger/generated_code/helseapi.swagger.dart';
import 'administration.dart';
import 'blocs/imports/file_import.dart';
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

    Future.delayed(Duration.zero, () => _getUser());
    Dependencies.blocs.fit.start();
    _startTaskResultJob(Dependencies.blocs.jobs);
  }

  DeviceType getDevice() {
    return MediaQuery.of(context).size.width <= 800
        ? DeviceType.mobile
        : DeviceType.desktop;
  }

  void _getUser() {
    final locale = Translation.of(context);
    try {
      var model = Dependencies.logics.authentication.getUser();
      setState(() {
        user = model;
      });
    } catch (ex) {
      Notify.show(
        locale.error(ex.toString()),
        context: mounted ? context : null,
        kind: NotificationKind.error,
      );
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
              IconButton(
                onPressed: () {
                  final uri = Uri.parse(
                    'https://github.com/FSchiltz/Helse/issues/new',
                  );

                  launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: Icon(
                  SimpleIcons.github,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              BlocProvider<TaskBloc>.value(
                value: Dependencies.blocs.jobs,
                child: BlocBuilder<TaskBloc, Execution>(
                  builder: (context, data) => ProgressIconButton(
                    state: data,
                    icon: Icons.list_alt_sharp,
                    onOpen: () => showDialog<void>(
                      context: context,
                      builder: (context) => ServerJobDialog(context: context),
                    ),
                  ),
                ),
              ),
              if (FitHelper.isSupported())
                BlocProvider<TaskBloc>.value(
                  value: Dependencies.blocs.fit,
                  child: BlocBuilder<TaskBloc, Execution>(
                    builder: (context, state) => ProgressIconButton(
                      state: state,
                      onOpen: () => showDialog<void>(
                        context: context,
                        builder: (context) => _showSynchroRuns(),
                      ),
                    ),
                  ),
                ),
              PopupMenuButton(
                icon: Icon(
                  Icons.menu_sharp,
                  color: theme.colorScheme.onSurface,
                ),
                itemBuilder: (context) {
                  var locale = Translation.of(context);
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.upload_file_sharp),
                        title: Text(locale.import),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.settings_sharp),
                        title: Text(locale.settings),
                      ),
                    ),
                    if (types.contains(UserType.admin) == true)
                      PopupMenuItem<int>(
                        value: 2,
                        child: ListTile(
                          leading: Icon(Icons.admin_panel_settings_sharp),
                          title: Text(locale.administration),
                        ),
                      ),
                    PopupMenuItem<int>(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Icons.logout_sharp),
                        title: Text(locale.logout),
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
                      Dependencies.logics.authentication.logOut(false);
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

  Future<void> _startTaskResultJob(TaskBloc jobs) async {
    jobs.start();
    var existingJobs = await Dependencies.services.import.getJobs();
    for (var job in existingJobs) {
      Dependencies.logics.import.jobs[job.id] = job.result;
    }
  }

  Widget _showSynchroRuns() {
    var tasks = Dependencies.blocs.jobs.executions;
    return TaskStatusDialog(tasks, Translation.of(context).syncHistory);
  }
}
