import 'dart:developer';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/inputs/password_input.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final textController = TextEditingController();

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  SubmissionStatus _status = SubmissionStatus.initial;
  SubmissionStatus _loaded = SubmissionStatus.initial;
  Status? _initStatus;
  String? _url;
  CancelableOperation<void>? _operation;

  @override
  initState() {
    super.initState();
    _initUrl();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: UIConstants.formPad),
                      Text(
                        locale.welcome,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: UIConstants.headerPad),
                      TextField(
                        controller: textController,
                        keyboardType: TextInputType.url,
                        onChanged: (v) => _urlTextChanged(v, locale),
                        key: const Key('loginForm_urlInput_textField'),
                        decoration: InputDecoration(
                          labelText: locale.serverurl,
                          prefixIcon: const Icon(Icons.home_sharp),
                          prefixIconColor: theme.primary,
                          filled: true,
                          fillColor: theme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorText: _status == SubmissionStatus.failure
                              ? locale.invalid(locale.url)
                              : null,
                        ),
                      ),
                      const SizedBox(height: UIConstants.headerPad),
                      (_loaded == SubmissionStatus.inProgress)
                          ? const HelseLoader()
                          : (_loaded == SubmissionStatus.success)
                          ? Column(
                              children: [
                                (_initStatus?.init == true)
                                    ? Column(
                                        children: [
                                          UserNameInput(
                                            controller: _controllerUsername,
                                            validate: validateUserName,
                                          ),
                                          const SizedBox(height: UIConstants.formPad),
                                          PasswordInput(
                                            controller: _controllerPassword,
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
                                          const SizedBox(height: UIConstants.headerPad),
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
                                            controllerSurname:
                                                _controllerSurname,
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
                                            _submit,
                                          ),
                                          const SizedBox(height: UIConstants.headerPad),
                                          ..._providers(
                                            _initStatus?.oauths,
                                            Theme.of(context).textTheme,
                                            locale,
                                          ),
                                        ],
                                      ),
                              ],
                            )
                          : Container(),
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
    if (_loaded == SubmissionStatus.waiting && _operation != null) {
      // cancel the existing call
      _operation?.cancel();

      setState(() {
        _operation = null;
      });
    }

    setState(() {
      _url = url;
      _loaded = SubmissionStatus.waiting;
    });

    if (url.isEmpty) {
      setState(() {
        _loaded = SubmissionStatus.initial;
      });
    } else {
      // Launch the urlchanged handler with a delay
      // To only call when the user has finished typing and allows giving feedback
      var operation = CancelableOperation.fromFuture(
        Future<void>.delayed(Durations.extralong3),
      );

      operation.value.then((value) async => await _urlChanged(url));
      setState(() {
        _operation = operation;
      });
    }
  }

  Future<void> _urlChanged(String url) async {
    var uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return;
    }

    setState(() {
      _loaded = SubmissionStatus.inProgress;
    });

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
          await _submit(oAuth: 'Header');
        }
      }

      if (mounted) {
        setState(() {
          _loaded = ((isInit?.init == null)
              ? SubmissionStatus.failure
              : SubmissionStatus.success);
        });
      }
    } catch (ex) {
      if (mounted) {
        setState(() {
          _loaded = SubmissionStatus.failure;
        });
        Notify.showError("Invalid Url");
      }
    }
  }

  /// Prefill the url from storage or other
  Future<void> _initUrl() async {
    // We first try to get it from storage
    var url = Dependencies.logics.authentication.getUrl();

    if (url != null && url.isNotEmpty) {
      textController.text = url;

      if (mounted) {
        setState(() {
          _url = url;
        });
        await _urlChanged(url);
      }
    }
  }

  Future<void> _submitOauth(OauthConnection oauth) async {
    var init = _initStatus;
    var url = _url;
    if (init != null && url != null) {
      Notify.show("Oauth started");
      setState(() {
        _status = SubmissionStatus.inProgress;
      });
      try {
        var grant = await Dependencies.services.authService.getGrant(
          url,
          oauth,
        );
        if (grant != null) {
          await _submit(oAuth: grant);
        }
      } catch (ex) {
        Notify.showError('Failed to start the oauth process:$ex');
        Dependencies.logics.authentication.logOut();

        // we start the login process again
        setState(() {
          _status = SubmissionStatus.initial;
        });
      }
    } else {
      Notify.showError('Server not ready');
      Dependencies.logics.authentication.logOut();
      setState(() {
        _status = SubmissionStatus.initial;
      });
    }
  }

  Future<void> _submit({String? oAuth}) async {
    log('Login started');
    setState(() {
      _status = SubmissionStatus.inProgress;
    });

    if (oAuth != null) {
      Notify.show("Oauth in progress");
    }

    var init = _initStatus?.init;
    var url = _url;
    if (init == null || url == null) {
      Notify.showError('Server not yet init');
      setState(() {
        _status = SubmissionStatus.initial;
      });
      return;
    }

    var user = _controllerUsername.text;
    var password = oAuth ?? _controllerPassword.text;

    if (oAuth == null && (user.isEmpty || password.isEmpty)) {
      Notify.showError("Invalid login flow");
      setState(() {
        _status = SubmissionStatus.initial;
      });
      return;
    }
    try {
      var created = await Dependencies.logics.authentication.startLogin(
        init: init,
        oauth: oAuth != null,
        password: password,
        url: url,
        user: user,
        name: _controllerName.text,
        surname: _controllerSurname.text,
      );

      final localContext = context;
      if (localContext.mounted) {
        var locale = Translation.of(localContext);

        if (created) {
          Notify.show(locale.welcomenew);
        } else {
          Notify.show(locale.welcome);
        }
      }
      log('Login successful');
      setState(() {
        _status = SubmissionStatus.success;
      });
    } catch (ex) {
      log('error of login: $ex');
      Notify.showError("Login failed:n$ex");

      // clear any info about the login
      await Dependencies.logics.authentication.logOut();

      // we start the login process again
      setState(() {
        _status = SubmissionStatus.initial;
      });
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
