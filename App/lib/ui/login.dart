import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/event.dart';

import '../main.dart';
import '../services/account.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final textController = TextEditingController();

  String? _url;
  String? _user;
  String? _password;
  SubmissionStatus _status = SubmissionStatus.initial;
  SubmissionStatus _loaded = SubmissionStatus.initial;
  bool? _isInit;
  bool _obscurePassword = false;
  String? _error;

  @override
  initState() {
    super.initState();
    _initUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Align(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    Text("Welcome back", style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 10),
                    Text("Login to your account", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 60),
                    TextField(
                      controller: textController,
                      onChanged: _urlChanged,
                      key: const Key('loginForm_urlInput_textField'),
                      decoration: InputDecoration(
                        labelText: 'Server url',
                        prefixIcon: const Icon(Icons.home_sharp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _status == SubmissionStatus.failure ? 'invalid url' : null,
                      ),
                    ),
                    const SizedBox(height: 60),
                    (_loaded == SubmissionStatus.inProgress)
                        ? const CircularProgressIndicator()
                        : (_loaded == SubmissionStatus.success)
                            ? Column(children: [
                                (_isInit == true)
                                    ? Column(
                                        children: [
                                          _UsernameInput(setUser),
                                          const SizedBox(height: 10),
                                          _PasswordInput(setPassword, togglePasswordVisibility, _obscurePassword),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text("Create your account", style: Theme.of(context).textTheme.headlineLarge),
                                          const SizedBox(height: 60),
                                          _UsernameInput(setUser),
                                          const SizedBox(height: 10),
                                          _PasswordInput(setPassword, togglePasswordVisibility, _obscurePassword),
                                        ],
                                      ),
                                const SizedBox(height: 60),
                                _status == SubmissionStatus.inProgress
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        key: const Key('loginForm_continue_raisedButton'),
                                        onPressed: _submit,
                                        child: const Text('Login'),
                                      )
                              ])
                            : Container(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _urlChanged(url) async {
    setState(() {
      _url = url;
      _loaded = SubmissionStatus.inProgress;
    });

    var isInit = await AppState.authenticationLogic?.isInit(_url ?? "");
    var status = ((isInit == null) ? SubmissionStatus.failure : SubmissionStatus.success);

    _checkState();

    // If the server is init or not
    // Todo use stream
    if (mounted) {
      setState(() {
        _isInit = isInit;
        _loaded = status;
      });
    }
  }

  /// Prefill the url from storage or other
  Future<void> _initUrl() async {
    AppState.authenticationLogic?.checkLogin();
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

  void _submit() async {
    var init = _isInit;
    var url = _url;
    if (init == null || url == null) return;

    var user = _user;
    var password = _password;
    if (user == null || password == null) return;

    setState(() {
      _status = SubmissionStatus.inProgress;
    });

    try {
      if (init) {
        await AppState.authenticationLogic?.logIn(url: url, username: user, password: password);
      } else {
        var person = Person(type: UserType.admin, userName: _user, password: _password);
        await AppState.authenticationLogic?.initAccount(url: url, person: person);

        // after a succes, we auto login
        await AppState.authenticationLogic?.logIn(url: url, username: user, password: password);
      }

      setState(() {
        _status = SubmissionStatus.success;
      });
    } catch (ex) {
      setState(() {
        _status = SubmissionStatus.failure;
        _error = ex.toString();
      });
    }
  }

  void togglePasswordVisibility() => setState(() {
        _obscurePassword = !_obscurePassword;
      });

  void setPassword(String? password) => setState(() {
        _password = password;
      });

  void setUser(String? value) => setState(() {
        _user = value;
      });

  _checkState() {
    if (_status == SubmissionStatus.failure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Failure: $_error')),
        );
    } else if (_status == SubmissionStatus.success && _isInit == false) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('User created, welcome')),
        );
    }
  }
}

class _UsernameInput extends StatelessWidget {
  final void Function(String? value) callback;

  const _UsernameInput(this.callback);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('loginForm_usernameInput_textField'),
      onChanged: callback,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a username.";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: 'username',
        prefixIcon: const Icon(Icons.person_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final void Function(String?) callback;
  final void Function() iconCallback;
  final bool obscurePassword;

  const _PasswordInput(this.callback, this.iconCallback, this.obscurePassword);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: callback,
      obscureText: !obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a username.";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: 'password',
        prefixIcon: const Icon(Icons.password_sharp),
        suffixIcon: IconButton(onPressed: iconCallback, icon: obscurePassword ? const Icon(Icons.visibility_sharp) : const Icon(Icons.visibility_off_sharp)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
