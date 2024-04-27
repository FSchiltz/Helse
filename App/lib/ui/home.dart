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
    return MediaQuery.of(context).size.width <= 800 ? DeviceType.mobile : DeviceType.desktop;
  }

  void _getUser() async {
    var localContext = context;
    try {
      var model = await AppState.authenticationLogic?.getUser();
      if (model != null) {
        setState(() {
          user = model;
        });
      }
    } catch (ex) {
      if (localContext.mounted) {
        ErrorSnackBar.show("Error: $ex", localContext);
      }
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
        appBar: CustomAppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome ${user?.surname ?? user?.name ?? ""}',
              style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onTertiary),
            ),
          ),
          actions: PopupMenuButton(
              icon: Icon(Icons.menu_sharp, color: theme.colorScheme.onTertiary),
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
                      MaterialPageRoute(builder: (context) => const LocalSettingsPage()),
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
          child: DateRangeInput(_setDate, date),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 56.0),
          child: Row(
            children: [
              Expanded(
                child: page,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 80;
  final PopupMenuButton<int> actions;
  final Widget title;
  final Widget child;

  const CustomAppBar({super.key, required this.title, required this.actions, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: height,
              child: CustomPaint(
                painter: CustomToolbarShape(theme: Theme.of(context).colorScheme),
              )),
          Align(
              alignment: const Alignment(0.0, 2.8),
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0,
                        // shadow
                        spreadRadius: .5,
                        // set effect of extending the shadow
                        offset: Offset(
                          0.0,
                          5.0,
                        ),
                      )
                    ],
                  ),
                  child: child,
                ),
              )),
          Align(alignment: Alignment.topCenter, child: title),
          Align(alignment: Alignment.topRight, child: actions),
        ]));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomToolbarShape extends CustomPainter {
  final ColorScheme theme;

  const CustomToolbarShape({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    //First oval
    Path path = Path();
    Rect pathGradientRect = Rect.fromCircle(
      center: Offset(size.width / 4, 0),
      radius: size.width / 1.8,
    );

    Gradient gradient = LinearGradient(
      colors: <Color>[
        theme.tertiary.withOpacity(0.6),
        theme.tertiary.withOpacity(1),
      ],
      stops: const [
        0.5,
        1.0,
      ],
    );

    path.lineTo(-size.width / 1.4, 0);
    path.quadraticBezierTo(size.width / 6, size.height * 2.5, size.width + size.width / 1.5, 0);

    paint.color = theme.primary;
    paint.shader = gradient.createShader(pathGradientRect);
    paint.strokeWidth = 40;
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
