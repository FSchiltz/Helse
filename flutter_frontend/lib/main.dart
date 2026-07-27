import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/worker.dart';
import 'logic/account/authentication_logic.dart';
import 'logic/account/authentication_bloc.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/splash.dart';

final snackbarKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dependencies.init();
  WorkHelper.init();
  Dependencies.logics.authentication.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc<ThemeMode>, ThemeMode>(
      bloc: Dependencies.logics.settings.themebloc,
      builder: (context, theme) => MaterialApp(
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
        themeMode: theme,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: snackbarKey,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationStatus>(
            bloc: Dependencies.blocs.auth,
            listener: (context, state) {
              log('State changed');
              switch (state) {
                case AuthenticationStatus.authenticated:
                  navigatorKey.currentState!.pushAndRemoveUntil<void>(
                    Home.route(),
                    (route) => false,
                  );
                default:
                  navigatorKey.currentState!.pushAndRemoveUntil<void>(
                    LoginPage.route(),
                    (route) => false,
                  );
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (RouteSettings routeSettings) => SplashPage.route(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
