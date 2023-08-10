import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/account/authentication_logic.dart';
import 'logic/account/authentication_bloc.dart';
import 'logic/events_logic.dart';
import 'logic/import_logic.dart';
import 'logic/metrics_logic.dart';
import 'logic/persons_logic.dart';
import 'logic/treatment_logic.dart';
import 'services/account.dart';
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
  static AuthenticationLogic? authenticationLogic;
  static MetricsLogic? metricsLogic;
  static ImportLogic? importLogic;
  static EventsLogic? eventLogic;
  static PersonsLogic? personsLogic;
  static TreatementLogic? treatementLogic;

  @override
  void initState() {
    super.initState();
    var account = Account(callback: () => RestartWidget.restartApp(context));
    authenticationLogic = AuthenticationLogic(account);
    metricsLogic = MetricsLogic(account);
    importLogic = ImportLogic(account);
    eventLogic = EventsLogic(account);
    personsLogic = PersonsLogic(account);
    treatementLogic = TreatementLogic(account);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (authenticationLogic == null) {
      throw Exception("Init Error");
    }

    return RepositoryProvider.value(
      value: authenticationLogic,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authenticationRepository: authenticationLogic!),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

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
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
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
