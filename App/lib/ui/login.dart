import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/theme/password_input.dart';
import '../logic/event.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'blocs/administration/users/user_form.dart';
import 'theme/loader.dart';
import 'theme/notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

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
  final TextEditingController _controllerConFirmPassword = TextEditingController();

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
                        Text("Welcome ${_initStatus?.init == true ? "Back" : ""}", style: Theme.of(context).textTheme.headlineLarge),
                        const SizedBox(height: 20),
                        TextField(
                          controller: textController,
                          keyboardType: TextInputType.url,
                          onChanged: _urlTextChanged,
                          key: const Key('loginForm_urlInput_textField'),
                          decoration: InputDecoration(
                            labelText: 'Server url',
                            prefixIcon: const Icon(Icons.home_sharp),
                            prefixIconColor: theme.primary,
                            filled: true,
                            fillColor: theme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(color: theme.primary),
                            ),
                            errorText: _status == SubmissionStatus.failure ? 'invalid url' : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        (_loaded == SubmissionStatus.inProgress)
                            ? const HelseLoader()
                            : (_loaded == SubmissionStatus.success)
                                ? Column(children: [
                                    (_initStatus?.init == true)
                                        ? Column(
                                            children: [
                                              UserNameInput(
                                                controller: _controllerUsername,
                                                validate: validateUserName,
                                              ),
                                              const SizedBox(height: 10),
                                              PasswordInput(controller: _controllerPassword),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Text("Create your account", style: Theme.of(context).textTheme.headlineLarge),
                                              Text("This is the admin account for the server", style: Theme.of(context).textTheme.bodyLarge),
                                              const SizedBox(height: 20),
                                              UserForm(
                                                UserType.admin,
                                                controllerUsername: _controllerUsername,
                                                controllerEmail: _controllerEmail,
                                                controllerPassword: _controllerPassword,
                                                controllerConFirmPassword: _controllerConFirmPassword,
                                                controllerName: _controllerName,
                                                controllerSurname: _controllerSurname,
                                              )
                                            ],
                                          ),
                                    const SizedBox(height: 60),
                                    _status == SubmissionStatus.inProgress
                                        ? const HelseLoader()
                                        : Column(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size.fromHeight(50),
                                                  shape: const ContinuousRectangleBorder(),
                                                ),
                                                onPressed: _submit,
                                                child: Text(
                                                  _initStatus?.init == true ? 'Login' : 'Create',
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              if (_initStatus?.oauth != null)
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    minimumSize: const Size.fromHeight(50),
                                                    shape: const ContinuousRectangleBorder(),
                                                  ),
                                                  onPressed: _submitOauth,
                                                  child: Text('Login with Oauth', style: Theme.of(context).textTheme.titleLarge),
                                                )
                                            ],
                                          )
                                  ])
                                : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a username.";
    }

    return null;
  }

  void _urlTextChanged(String url) async {
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
      var operation = CancelableOperation.fromFuture(Future<void>.delayed(Durations.extralong3));

      operation.value.then((value) async => await _urlChanged(url));
      setState(() {
        _operation = operation;
      });
    }
  }

  Future<void> _urlChanged(String url) async {
    setState(() {
      _loaded = SubmissionStatus.inProgress;
    });

    try {
      var isInit = await DI.helper?.isInit(_url ?? "");
      var status = ((isInit?.init == null) ? SubmissionStatus.failure : SubmissionStatus.success);

      // If the server is init or not
      // Todo use stream
      if (mounted) {
        if (isInit != null && isInit.init == true) {
          if (isInit.oauth != null) {

            // Start the oauth login procedure
            var grant = await DI.authentication.getGrant();
            if (grant != null) {
              _submit(
                noUser: true,
                oAuth: grant,
                redirect: await DI.authentication.getRedirect(),
              );
            } else if (isInit.autoLogin == true) {
              _connectOauth(isInit, url);
            }
          } else if (isInit.externalAuth == true) {
            // Todo read from config

            // directly start the login procedure
            _submit(noUser: true);
          }
        }

        setState(() {
          _initStatus = isInit;
          _loaded = status;
        });
      }
    } catch (ex) {   
      setState(() {
        _loaded = SubmissionStatus.failure;
      });
      Notify.showError(ex.toString());
    }
  }

  /// Prefill the url from storage or other
  Future<void> _initUrl() async {
    DI.authentication.checkLogin();
    // We first try to get it from storage
    var url = await DI.authentication.getUrl();

    if (url != null && url.isNotEmpty) {
      textController.text = url;
      setState(() {
        _url = url;
      });

      _urlChanged(url);
    }
  }

  Future<void> _submitOauth() async {
    var init = _initStatus;
    var url = _url;
    if (init != null && url != null) {
      await _connectOauth(init, url);
    }
  }

  void _submit({bool noUser = false, String? oAuth, String? redirect}) async {
    var init = _initStatus?.init;
    var url = _url;
    if (init == null || url == null) return;

    var user = _controllerUsername.text;
    var password = _controllerPassword.text;

    if (oAuth != null) {
      password = oAuth;
    }

    if (!noUser && (user.isEmpty || password.isEmpty)) return;

    setState(() {
      _status = SubmissionStatus.inProgress;
    });

    try {
      if (init || noUser) {
        await DI.authentication.logIn(
          url: url,
          username: user,
          password: password,
          redirect: redirect,
        );
      } else {
        var person = PersonCreation(
          type: UserType.admin,
          userName: user,
          password: password,
          name: _controllerName.text,
          surname: _controllerSurname.text,
        );
        await DI.authentication.initAccount(url: url, person: person);

        // after a succes, we auto login
        await DI.authentication.logIn(
          url: url,
          username: user,
          password: password,
        );

        await DI.authentication.clean();

        Notify.show('User created, welcome');
      }

      setState(() {
        _status = SubmissionStatus.success;
      });
    } catch (ex) {
      Notify.showError("Error: $ex");

      // clear any info about the login
      await DI.authentication.logOut();

      // we start the login process again
      setState(() {
        _status = SubmissionStatus.initial;
      });
    }
  }

  Future<void> _connectOauth(Status isInit, String url) async {
    try {
      DI.authService?.init(
        auth: isInit.oauth ?? '',
        clientId: isInit.oauthId ?? '',
      );

      await DI.authService?.login(url);
    } catch (ex) {
      Notify.showError(ex.toString());

      DI.authentication.logOut();

      // we start the login process again
      setState(() {
        _status = SubmissionStatus.initial;
      });
    }
  }
}
