import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../logic/event.dart';
import '../main.dart';
import '../services/account.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';
import 'blocs/administration/users/user_form.dart';
import 'blocs/loader.dart';
import 'blocs/notification.dart';

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
  bool? _isInit;
  bool _obscurePassword = true;
  String? _url;

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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Welcome ${_isInit == true ? "Back" : ""}", style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 20),
                      TextField(
                        controller: textController,
                        onChanged: _urlChanged,
                        key: const Key('loginForm_urlInput_textField'),
                        decoration: InputDecoration(
                          labelText: 'Server url',
                          prefixIcon: const Icon(Icons.home_sharp),
                          prefixIconColor: theme.primary,
                          filled: true,
                          fillColor: theme.surface,
                          border: OutlineInputBorder(
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
                                  (_isInit == true)
                                      ? Column(
                                          children: [
                                            UserNameInput(
                                              controller: _controllerUsername,
                                              validate: validateUserName,
                                            ),
                                            const SizedBox(height: 10),
                                            PasswordInput(
                                              controller: _controllerPassword,
                                              toggleCallback: togglePasswordVisibility,
                                              obscurePassword: _obscurePassword,
                                            ),
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
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size.fromHeight(50),
                                            shape: const ContinuousRectangleBorder(),
                                          ),
                                          key: const Key('loginForm_continue_raisedButton'),
                                          onPressed: _submit,
                                          child: Text(
                                            _isInit == true ? 'Login' : 'Create',
                                            style: Theme.of(context).textTheme.titleLarge,
                                          ),
                                        )
                                ])
                              : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  String? validateUserName(value) {
    if (value == null || value.isEmpty) {
      return "Please enter a username.";
    }

    return null;
  }

  void _urlChanged(url) async {
    setState(() {
      _url = url;
      _loaded = SubmissionStatus.inProgress;
    });

    var isInit = await AppState.helper?.isInit(_url ?? "");
    var status = ((isInit?.init == null) ? SubmissionStatus.failure : SubmissionStatus.success);

    // If the server is init or not
    // Todo use stream
    if (mounted) {
      setState(() {
        _isInit = isInit?.init;
        _loaded = status;
      });

      if (isInit?.externalAuth == true) {
        // directly start the login procedure
        _submit(noUser: true);
      }
    }
  }

  /// Prefill the url from storage or other
  Future<void> _initUrl() async {
    AppState.authentication?.checkLogin();
    // We first try to get it from storage
    var url = await Account().getUrl();

    // if not in storage, we can try to get it from the current url on the web
    if (url == null && kIsWeb) {
      url = "${Uri.base.scheme}://${Uri.base.host}${Uri.base.port > 0 ? ":${Uri.base.port}" : ""}";
    }

    if (url != null && url.isNotEmpty) {
      textController.text = url;
      setState(() {
        _url = url;
      });

      _urlChanged(url);
    }
  }

  void _submit({bool noUser = false}) async {
    var localContext = context;

    var init = _isInit;
    var url = _url;
    if (init == null || url == null) return;

    var user = _controllerUsername.text;
    var password = _controllerPassword.text;
    if (!noUser && (user.isEmpty || password.isEmpty)) return;

    setState(() {
      _status = SubmissionStatus.inProgress;
    });

    try {
      if (init) {
        await AppState.authentication?.logIn(url: url, username: user, password: password);
      } else {
        var person = PersonCreation(type: UserType.admin, userName: user, password: password, name: _controllerName.text, surname: _controllerSurname.text);
        await AppState.authentication?.initAccount(url: url, person: person);

        // after a succes, we auto login
        await AppState.authentication?.logIn(url: url, username: user, password: password);
        if (localContext.mounted) {
          SuccessSnackBar.show('User created, welcome', localContext);
        }
      }

      setState(() {
        _status = SubmissionStatus.success;
      });
    } catch (ex) {
      if (localContext.mounted) {
        ErrorSnackBar.show("Error: $ex", localContext);
      }

      // we start the login process again
      setState(() {
        _status = SubmissionStatus.initial;
      });
    }
  }

  void togglePasswordVisibility() => setState(() {
        _obscurePassword = !_obscurePassword;
      });
}
