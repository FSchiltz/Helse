import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/logic/account/server_state.dart';
import 'package:helse/ui/common/inputs/password_input.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';
import '../logic/event.dart';
import '../services/swagger/generated_code/helseapi.swagger.dart';
import 'blocs/administration/users/user_form.dart';
import 'common/loader.dart';
import 'common/notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _urlController = TextEditingController();
  final _controllerUsername = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerSurname = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerConFirmPassword = TextEditingController();

  SubmissionStatus _status = SubmissionStatus.unkown;
  String? _url;
  String? _urlError;
  String? _loginError;
  Timer? _operation;

  @override
  initState() {
    super.initState();
    _initUrl();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _controllerUsername.dispose();
    _controllerName.dispose();
    _controllerSurname.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return BlocBuilder<ServerState, ServerStatus>(
      bloc: Dependencies.blocs.server,
      builder: (context, status) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    spacing: UIConstants.formPad,
                    children: [
                      Text(
                        locale.welcome,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: UIConstants.headerPad),
                      if (!kIsWeb)
                        SquareButton(
                          locale.offline,
                          _useOffline,
                          height: 55,
                          icon: Icons.location_off_outlined,
                        ),
                      if (!kIsWeb)
                        const SizedBox(height: UIConstants.headerPad),
                      SquareTextField(
                        label: locale.serverurl,
                        controller: _urlController,
                        icon: Icons.home_sharp,
                        type: TextInputType.url,
                        onChanged: (v) => _urlTextChanged(v, locale),
                        key: const Key('loginForm_urlInput_textField'),
                        errorText: _urlError,
                      ),
                      if (_status != SubmissionStatus.unkown)
                        ..._getLoginForm(locale, status.state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a username.";
    }

    return null;
  }

  void _urlTextChanged(String url, AppLocalizations locale) async {
    // cancel the existing call
    _operation?.cancel();
    _operation = null;

    if (!url.startsWith("http")) {
      // if the user id not specify the scheme, use https by default
      url = "https://$url";
    }

    setState(() {
      _url = url;
      _urlError = null;
      _loginError = null;
      _status = SubmissionStatus.unkown;
    });

    if (url.isNotEmpty) {
      // Launch the urlchanged handler with a delay
      // To only call when the user has finished typing and allows giving feedback
      setState(() {
        _status = SubmissionStatus.waiting;
      });

      _operation = Timer(Duration(seconds: 1), () async {
        await _urlChanged(url);
      });
    }
  }

  Future<void> _urlChanged(String url) async {
    var uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return;
    }

    try {
      Dependencies.blocs.server.setStatus(null);
      var isInit = await Dependencies.logics.authentication.checkUrl(uri);

      if (!mounted) {
        return;
      }

      setState(() {
        _status = ((isInit?.init == null)
            ? SubmissionStatus.unkown
            : SubmissionStatus.initial);
      });
    } catch (ex) {
      if (mounted) {
        final locale = Translation.of(context);
        setState(() {
          _status = SubmissionStatus.unkown;
          _urlError = locale.invalid(locale.url);
        });
      }
    }
  }

  /// Prefill the url from storage or other
  Future<void> _initUrl() async {
    log('Init url');
    // We first try to get it from storage
    var url = Dependencies.logics.authentication.getUrl();

    if (url != null && url.isNotEmpty) {
      _urlController.text = url;

      if (mounted) {
        setState(() {
          _status = SubmissionStatus.waiting;
          _loginError = null;
          _urlError = null;
          _url = url;
        });
        await _urlChanged(url);
      }
    }
  }

  Future<void> _submitOauth(OauthConnection oauth) async {
    final locale = Translation.of(context);
    var init = Dependencies.blocs.server.state;
    var url = _url;
    final state = init.state;
    if (state != null && url != null) {
      _start();
      try {
        await Dependencies.logics.authentication.submitOauth(url, oauth, state);
        _success();
      } catch (ex) {
        log('error of login: $ex');
        // clear any info about the login
        await Dependencies.logics.authentication.clean();
        Dependencies.logics.authentication.setNoAuth();

        _reset(error: "Login failed");
        Notify.show(
          locale.error(ex.toString()),
          context: mounted ? context : null,
          kind: NotificationKind.error,
        );
      }
    }

    Dependencies.logics.authentication.logOut(false);
    _reset();
  }

  void _start() {
    log('Login started');
    setState(() {
      _loginError = null;
      _status = SubmissionStatus.inProgress;
    });
  }

  void _reset({String? error}) {
    setState(() {
      _loginError = error;
      _status = SubmissionStatus.initial;
    });
  }

  void _success() {
    log('Login successful');
    setState(() {
      _status = SubmissionStatus.success;
    });
  }

  Future<void> _create() async {
    _start();

    var user = _controllerUsername.text;
    var password = _controllerPassword.text;
    var name = _controllerName.text;
    var surname = _controllerSurname.text;
    var url = _url;

    if (url == null) {
      _reset();
      return;
    }

    if (user.isEmpty) {
      _reset(error: "Missing username");
      return;
    }
    try {
      var person = PersonCreation(
        types: [UserType.admin],
        userName: user,
        password: password,
        name: name,
        surname: surname,
      );
      await Dependencies.logics.authentication.initAccount(
        url: url,
        person: person,
      );

      _success();
    } catch (ex) {
      log('error of login: $ex');
      // clear any info about the login
      await Dependencies.logics.authentication.clean();
      Dependencies.logics.authentication.setNoAuth();

      // we start the login process again
      _reset(error: "Login failed");
    }
  }

  Future<void> _login() async {
    _start();

    var user = _controllerUsername.text;
    var password = _controllerPassword.text;
    var url = _url;

    if (url == null) {
      _reset();
      return;
    }

    if (user.isEmpty) {
      _reset(error: "Missing username");

      return;
    }
    try {
      await Dependencies.logics.authentication.logIn(
        url: url,
        connection: Connection(user: user, password: password),
      );

      _success();
    } catch (ex) {
      log('error of login: $ex');
      // clear any info about the login
      await Dependencies.logics.authentication.clean();
      Dependencies.logics.authentication.setNoAuth();

      _reset(error: "Login failed");
    }
  }

  List<Widget> _providers(
    List<OauthConnection>? oauths,
    TextTheme theme,
    AppLocalizations locale,
  ) {
    if (oauths == null) {
      return [];
    }

    return oauths
        .map(
          (o) => SquareButton(locale.loginwith(o.name), () => _submitOauth(o)),
        )
        .toList();
  }

  Future<void> _useOffline() async {
    await Dependencies.logics.authentication.useOffline();
    await Dependencies.logics.authentication.logIn(
      url: '',
      connection: Connection(user: '', password: ''),
    );
  }

  List<Widget> _getLoginForm(AppLocalizations locale, Status? state) {
    if (_status == SubmissionStatus.waiting) return [const HelseLoader()];

    final List<Widget> widgets;

    if (state?.init == true) {
      widgets = [
        UserNameInput(
          controller: _controllerUsername,
          validate: validateUserName,
        ),
        PasswordInput(controller: _controllerPassword, error: _loginError),
      ];
    } else {
      widgets = [
        Text(
          locale.createAccount,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          locale.adminDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: UIConstants.headerPad),
        UserForm(
          [UserType.admin],
          controllerUsername: _controllerUsername,
          controllerEmail: _controllerEmail,
          controllerPassword: _controllerPassword,
          controllerConFirmPassword: _controllerConFirmPassword,
          controllerName: _controllerName,
          controllerSurname: _controllerSurname,
        ),
      ];
    }

    if (_status == SubmissionStatus.inProgress) {
      widgets.add(const HelseLoader());
    } else {
      widgets.add(
        SquareButton(
          state?.init == true ? locale.login : locale.create,
          state?.init == true ? _login : _create,
          height: 55,
        ),
      );
    }

    widgets.addAll(
      _providers(state?.oauths, Theme.of(context).textTheme, locale),
    );

    return widgets;
  }
}
