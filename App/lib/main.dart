import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/d_i.dart';
import 'package:toastification/toastification.dart';

import 'helpers/url_dummy.dart' if (dart.library.html) 'helpers/url.dart';
import 'logic/account/authentication_logic.dart';
import 'logic/account/authentication_bloc.dart';
import 'logic/settings/settings_logic.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/splash.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Demo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (RouteSettings routeSettings) {
          DI.init();
          if (kIsWeb) {
            var uri = Uri.base.queryParameters;

            if (uri.containsKey("code")) {
              DI.authService?.doAuthOnWeb(uri);
              UrlHelper.removeParam();
            }
          }
          return MaterialPageRoute(builder: (BuildContext context) {
            return const AppView();
          });
        },
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;

  @override
  State<AppView> createState() => AppState();
}

class AppState extends State<AppView> {
  ThemeMode _themeMode = ThemeMode.system;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    SettingsLogic.getTheme().then((value) => changeTheme(value.theme));
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (DI.authentication == null) {
      throw Exception("Init Error");
    }

    return RepositoryProvider.value(
      value: DI.authentication,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authenticationRepository: DI.authentication!),
        child: MaterialApp(
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
          onGenerateRoute: (_) => SplashPage.route(),
        ),
      ),
    );
  }
}
