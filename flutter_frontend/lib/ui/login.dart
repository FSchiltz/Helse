import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
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

  SubmissionStatus _status = SubmissionStatus.waiting;
  Status? _initStatus;
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
    return Scaffold(
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
                  children: [
                    const SizedBox(height: UIConstants.formPad),
                    Text(
                      locale.welcome,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
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
                    const SizedBox(height: UIConstants.headerPad),
                    (_status == SubmissionStatus.waiting)
                        ? const HelseLoader()
                        : Column(
                            children: [
                              (_initStatus?.init == true)
                                  ? Column(
                                      children: [
                                        UserNameInput(
                                          controller: _controllerUsername,
                                          validate: validateUserName,
                                        ),
                                        const SizedBox(
                                          height: UIConstants.formPad,
                                        ),
                                        PasswordInput(
                                          controller: _controllerPassword,
                                          error: _loginError,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          locale.createAccount,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineLarge,
                                        ),
                                        Text(
                                          locale.adminDescription,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                        const SizedBox(
                                          height: UIConstants.headerPad,
                                        ),
                                        UserForm(
                                          [UserType.admin],
                                          controllerUsername:
                                              _controllerUsername,
                                          controllerEmail: _controllerEmail,
                                          controllerPassword:
                                              _controllerPassword,
                                          controllerConFirmPassword:
                                              _controllerConFirmPassword,
                                          controllerName: _controllerName,
                                          controllerSurname: _controllerSurname,
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: UIConstants.headerPad),
                              _status == SubmissionStatus.inProgress
                                  ? const HelseLoader()
                                  : Column(
                                      children: [
                                        SquareButton(
                                          _initStatus?.init == true
                                              ? locale.login
                                              : locale.create,
                                          _initStatus?.init == true
                                              ? _login
                                              : _create,
                                        ),
                                        const SizedBox(
                                          height: UIConstants.headerPad,
                                        ),
                                        ..._providers(
                                          _initStatus?.oauths,
                                          Theme.of(context).textTheme,
                                          locale,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                  ],
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
      _status = SubmissionStatus.waiting;
    });

    if (url.isNotEmpty) {
      // Launch the urlchanged handler with a delay
      // To only call when the user has finished typing and allows giving feedback
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
      var isInit = await Dependencies.services.helper.isInit(uri);

      if (mounted) {
        setState(() {
          _initStatus = isInit;
        });
      }

      // If the server is init or not
      // Todo use the loaded stream
      var needsLogging = await Dependencies.logics.authentication
          .checkIfNeedsLogging();
      if (isInit != null && isInit.init == true && mounted && needsLogging) {
        if (isInit.oauths.isNotEmpty) {
          // Start the oauth login procedure
          var autologin = isInit.oauths.firstWhereOrNull((x) => x.autoLogin);
          if (autologin != null) {
            await _submitOauth(autologin);
          }
        } else if (isInit.externalAuth == true) {
          // directly start the login procedure
          await _submit('Header');
        }
      }

      if (mounted) {
        setState(() {
          _status = ((isInit?.init == null)
              ? SubmissionStatus.waiting
              : SubmissionStatus.initial);
        });
      }
    } catch (ex) {
      if (mounted) {
        final locale = Translation.of(context);
        setState(() {
          _status = SubmissionStatus.waiting;
          _urlError = locale.invalid(locale.url);
        });
      }
    }
  }

  /// Prefill the url from storage or other
  Future<void> _initUrl() async {
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
    var init = _initStatus;
    var url = _url;
    if (init != null && url != null) {
      _start();
      try {
        var grant = await Dependencies.services.authService.getGrant(
          url,
          oauth,
        );
        if (grant != null) {
          await _submit(grant);
        }

        return;
      } catch (ex) {
        if (mounted) {
          Notify.showError(locale.error(ex.toString()), context);
        }
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
      await Dependencies.logics.authentication.logOutLocal();

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
      await Dependencies.logics.authentication.logOutLocal();

      _reset(error: "Login failed");
    }
  }

  Future<void> _submit(String oAuth) async {
    _start();

    Notify.show("Oauth in progress", context);

    var init = _initStatus?.init;
    var url = _url;
    if (init == null || url == null) {
      _reset();
      return;
    }

    var user = _controllerUsername.text;
    var password = oAuth;

    if (user.isEmpty) {
      _reset(error: "Missing username");
      return;
    }

    try {
      await Dependencies.logics.authentication.startOauthLogin(
        password: password,
        url: url,
        user: user,
      );

      _success();
    } catch (ex) {
      log('error of login: $ex');
      // clear any info about the login
      await Dependencies.logics.authentication.logOutLocal();

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
}
