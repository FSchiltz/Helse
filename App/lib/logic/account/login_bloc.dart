import 'package:bloc/bloc.dart';
import 'authentication_logic.dart';

enum SubmissionStatus { initial, success, failure, inProgress }

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationLogic authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginUrlChanged>(_onUrlChanged);
    on<LoginPasswordVisibilityChanged>(_onVisibilityChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationLogic _authenticationRepository;

  bool _hasError(String? text) {
    return text == null || text.isEmpty;
  }

  bool _validateAll(String url, String user, String password) {
    return !_hasError(url) && !_hasError(user) && !_hasError(password);
  }

  void _onUrlChanged(LoginUrlChanged event, Emitter<LoginState> emit) {
    final url = event.url;
    var hasError = _hasError(url);
    var valid = _validateAll(url, state.username, state.password);
    emit(
      state.copyWith(url: url, urlError: hasError, isValid: valid),
    );
  }

  void _onVisibilityChanged(LoginPasswordVisibilityChanged event, Emitter<LoginState> emit) {
    final obscurePassword = event.visibility;
    emit(
      state.copyWith(obscurePassword: obscurePassword),
    );
  }

  void _onUsernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) {
    final username = event.username;
    var hasError = _hasError(username);
    var valid = _validateAll(state.url, username, state.password);
    emit(
      state.copyWith(username: username, usernameError: hasError, isValid: valid),
    );
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = event.password;
    var hasError = _hasError(password);
    var valid = _validateAll(state.url, state.username, password);
    emit(
      state.copyWith(password: password, passwordError: hasError, isValid: valid),
    );
  }

  void checkLogin() {
    _authenticationRepository.checkLogin();
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: SubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logIn(url: state.url, username: state.username, password: state.password);
        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
    }
  }
}

final class LoginState {
  const LoginState({
    this.status = SubmissionStatus.initial,
    this.username = "",
    this.password = "",
    this.isValid = false,
    this.obscurePassword = false,
    this.url = "",
    this.passwordError = false,
    this.usernameError = false,
    this.urlError = false,
  });

  final SubmissionStatus status;
  final String username;
  final String password;
  final String url;
  final bool obscurePassword;
  final bool isValid;
  final bool passwordError;
  final bool usernameError;
  final bool urlError;

  LoginState copyWith({
    SubmissionStatus? status,
    String? url,
    String? username,
    String? password,
    bool? isValid,
    bool? obscurePassword,
    bool? passwordError,
    bool? usernameError,
    bool? urlError,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      passwordError: passwordError ?? this.passwordError,
      usernameError: usernameError ?? this.usernameError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      urlError: urlError ?? this.urlError,
      url: url ?? this.url,
    );
  }
}

sealed class LoginEvent {
  const LoginEvent();
}

final class LoginUrlChanged extends LoginEvent {
  const LoginUrlChanged(this.url);

  final String url;
}

final class LoginPasswordVisibilityChanged extends LoginEvent {
  const LoginPasswordVisibilityChanged(this.visibility);

  final bool visibility;
}

final class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
