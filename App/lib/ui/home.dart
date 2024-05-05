import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import '../helpers/date.dart';
import '../main.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'administration.dart';
import 'blocs/common/date_range_input.dart';
import 'blocs/imports/file_import.dart';
import 'blocs/loader.dart';
import 'blocs/notification.dart';
import 'care_dashboard.dart';
import 'dashboard.dart';
import 'local_settings.dart';

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
  }

  DeviceType getDevice() {
    return MediaQuery.of(context).size.width <= 800
        ? DeviceType.mobile
        : DeviceType.desktop;
  }

  void _getUser() async {
    try {
      var model = await DI.authentication?.getUser();
      if (model != null) {
        setState(() {
          user = model;
        });
      }
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
    Widget page;
    page = switch (user?.type) {
      UserType.admin => AdminDashBoard(date: date),
      UserType.user => Dashboard(date: date),
      UserType.caregiver => CareDashBoard(date: date),
      _ => const Center(child: HelseLoader()),
    };

    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Hi ${user?.surname ?? user?.name ?? ""}',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                ),
              ),
              Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                color: theme.colorScheme.onSecondary,
                child: DateRangeInput(_setDate, date),
              ))
            ],
          ),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.menu_sharp,
                    color: theme.colorScheme.onBackground),
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
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const FileImport();
                          });
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (context) => const LocalSettingsPage()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (context) => const AdministrationPage()),
                      );
                      break;
                    case 3:
                      DI.authentication?.logOut();
                      break;
                  }
                })
          ],
        ),
        body: page,
      );
    });
  }
}
