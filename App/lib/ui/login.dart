import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/event.dart';

import '../services/account.dart';
import '../logic/account/authentication_logic.dart';
import '../logic/account/login_bloc.dart';

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

  /// Prefill the url from storage or other
  Future<void> _initUrl(LoginBloc bloc) async {
    // We first try to get it from storage
    var url = await Account().getUrl();

    // if not in storage, we can try to get it from the current url on the web
    if (url == null && kIsWeb) {
      url = "${Uri.base.scheme}://${Uri.base.host}${Uri.base.port > 0 ? ":${Uri.base.port}" : ""}";
    }

    if (url != null && url.isNotEmpty) {
      textController.text = url;
      bloc.add(TextChangedEvent(url, LoginBloc.urlField));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: BlocProvider(
        create: (context) {
          var bloc = LoginBloc(authenticationRepository: RepositoryProvider.of<AuthenticationLogic>(context));
          bloc.checkLogin();
          _initUrl(bloc);
          return bloc;
        },
        child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == SubmissionStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Failure')),
                  );
              } else if (state.status == SubmissionStatus.success && !state.isInit) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('User created, welcome')),
                  );
              }
            },
            child: Form(
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
                        _UrlInput(textController),
                        const SizedBox(height: 60),
                        _LoginInput(),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class _LoginInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.loaded != current.loaded,
        builder: (context, state) {
          if (state.loaded == SubmissionStatus.inProgress) {
            return const CircularProgressIndicator();
          } else if (state.loaded == SubmissionStatus.success) {
            if (state.isInit) {
              return Column(
                children: [
                  _UsernameInput(),
                  const SizedBox(height: 10),
                  _PasswordInput(),
                  const SizedBox(height: 60),
                  _LoginButton(),
                ],
              );
            } else {
              return Column(
                children: [
                  Text("Create your account", style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 60),
                  _UsernameInput(),
                  const SizedBox(height: 10),
                  _PasswordInput(),
                  const SizedBox(height: 60),
                  _LoginButton(),
                ],
              );
            }
          }
          return Container();
        });
  }
}

class _UrlInput extends StatelessWidget {
  final TextEditingController _textController;

  const _UrlInput(TextEditingController textController) : _textController = textController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.url != current.url || previous.urlError != current.urlError,
      builder: (context, state) {
        return TextField(
          controller: _textController,
          onChanged: (url) => context.read<LoginBloc>().add(TextChangedEvent(url, LoginBloc.urlField)),
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
            errorText: state.urlError ? 'invalid url' : null,
          ),
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username || previous.usernameError != current.usernameError,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) => context.read<LoginBloc>().add(TextChangedEvent(username, LoginBloc.userNameField)),
          decoration: InputDecoration(
            labelText: 'username',
            prefixIcon: const Icon(Icons.person_sharp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: state.usernameError ? 'invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => context.read<LoginBloc>().add(TextChangedEvent(password, LoginBloc.passwordField)),
          obscureText: !state.obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: 'password',
            prefixIcon: const Icon(Icons.password_sharp),
            suffixIcon: IconButton(
                onPressed: () {
                  context.read<LoginBloc>().add(BoolChangedEvent(!state.obscurePassword, "visible"));
                },
                icon: state.obscurePassword ? const Icon(Icons.visibility_sharp) : const Icon(Icons.visibility_off_sharp)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: state.passwordError ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status == SubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.isValid
                    ? () {
                        context.read<LoginBloc>().add(const SubmittedEvent(""));
                      }
                    : null,
                child: const Text('Login'),
              );
      },
    );
  }
}
