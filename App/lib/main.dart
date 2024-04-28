import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/services/user_service.dart';

import 'logic/account/authentication_logic.dart';
import 'logic/account/authentication_bloc.dart';
import 'logic/settings_logic.dart';
import 'services/account.dart';
import 'services/event_service.dart';
import 'services/helper_service.dart';
import 'services/metric_service.dart';
import 'services/treatment_service.dart';
import 'ui/blocs/common/restart.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/splash.dart';

void main() => runApp(const RestartWidget(child: App()));

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  static AuthenticationLogic? authentication;
  static MetricService? metric;
  static HelperService? helper;
  static EventService? event;
  static UserService? user;
  static TreatmentService? treatement;
  static SettingsLogic? settings;

  @override
  void initState() {
    super.initState();
    var account = Account(callback: () => RestartWidget.restartApp(context));
    authentication = AuthenticationLogic(account);
    metric = MetricService(account);
    helper = HelperService(account);
    event = EventService(account);
    user = UserService(account);
    treatement = TreatmentService(account);
    settings = SettingsLogic(account);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (authentication == null) {
      throw Exception("Init Error");
    }

    return RepositoryProvider.value(
      value: authentication,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authenticationRepository: authentication!),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  static AppViewState of(BuildContext context) => context.findAncestorStateOfType<AppViewState>()!;

  @override
  State<AppView> createState() => AppViewState();
}

class AppViewState extends State<AppView> {
  ThemeMode _themeMode = ThemeMode.system;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  AppViewState() {
    AppState.settings?.getLocalSettings().then((value) => changeTheme(value.theme));
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 123, 250, 123)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 97, 0), brightness: Brightness.dark),
        /* dark theme settings */
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
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
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
