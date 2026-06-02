import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:helse/worker.dart';
import 'package:toastification/toastification.dart';
import 'package:workmanager/workmanager.dart';

import 'logic/account/authentication_logic.dart';
import 'logic/account/authentication_bloc.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Dependencies.init();

  if (!kIsWeb && Platform.isAndroid) {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      "data_sync",
      "data_sync",
      frequency: Duration(minutes: 15),
    );
  }
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static AppState of(BuildContext context) =>
      context.findAncestorStateOfType<AppState>()!;

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    Dependencies.logics.authentication.listen();
  }

  void changeTheme(InterfaceTheme themeMode) {
    switch (themeMode) {
      case InterfaceTheme.light:
        setState(() {
          _themeMode = ThemeMode.light;
        });
        break;
      case InterfaceTheme.dark:
        setState(() {
          _themeMode = ThemeMode.dark;
        });
        break;
      default:
        setState(() {
          _themeMode = ThemeMode.system;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: BlocProvider(
        create: (_) => AuthenticationBloc(),
        child: BlocListener<SettingsBloc<InterfaceTheme>, InterfaceTheme>(
          listener: (context, v) {
            changeTheme(v);
          },
          bloc: Dependencies.logics.settings.themebloc,
          child: MaterialApp(
            title: 'Helse',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 123, 250, 123),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 0, 97, 0),
                brightness: Brightness.dark,
              ),
              /* dark theme settings */
            ),
            themeMode: _themeMode,
            debugShowCheckedModeBanner: false,
            navigatorKey: _navigatorKey,
            builder: (context, child) {
              return BlocListener<AuthenticationBloc, AuthenticationStatus>(
                listener: (context, state) {
                  switch (state) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        Home.route(),
                        (route) => false,
                      );
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                        (route) => false,
                      );
                    case AuthenticationStatus.unknown:
                      break;
                  }
                },
                child: child,
              );
            },
            onGenerateRoute: (RouteSettings routeSettings) => SplashPage.route(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
  }
}
