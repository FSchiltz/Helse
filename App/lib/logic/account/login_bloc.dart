import 'package:bloc/bloc.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';
import '../event.dart';
import 'authentication_logic.dart';

class LoginBloc extends Bloc<ChangedEvent, LoginState> {
  static const String userNameField = "user";
  static const String passwordField = "password";
  static const String urlField = "url";

  static const String visibilityField = "visible";
  static const String loadedField = "loaded";

  LoginBloc({
    required AuthenticationLogic authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<TextChangedEvent>(_onTextChanged);
    on<BoolChangedEvent>(_onVisibilityChanged);
    on<SubmittedEvent>(_onSubmitted);
  }

  final AuthenticationLogic _authenticationRepository;

  bool _hasError(String? text) {
    return text == null || text.isEmpty;
  }

  bool _validateAll(String? url, String? user, String? password) {
    return !_hasError(url) && !_hasError(user) && !_hasError(password);
  }

  Future<void> _onTextChanged(TextChangedEvent event, Emitter<LoginState> emit) async {
    switch (event.field) {
      case userNameField:
        _onUsernameChanged(event, emit);
        break;
      case passwordField:
        _onPasswordChanged(event, emit);
        break;
      case urlField:
        await _onUrlChanged(event, emit);
    }
  }

  Future<void> _onUrlChanged(TextChangedEvent event, Emitter<LoginState> emit) async {
    final url = event.value;

    var valid = _validateAll(url, state.username, state.password);

    // Check if the url is valid
    emit(
      state.copyWith(url: url, loaded: SubmissionStatus.inProgress, isValid: valid),
    );

    var isInit = await _authenticationRepository.isInit(state.url);
    var status = ((isInit == null) ? SubmissionStatus.failure : SubmissionStatus.success);
    var error = status == SubmissionStatus.failure;

    // If the server is init or not
    emit(
      state.copyWith(isInit: isInit, urlError: error, loaded: status),
    );
  }

  void _onVisibilityChanged(BoolChangedEvent event, Emitter<LoginState> emit) {
    final obscurePassword = event.value;
    emit(
      state.copyWith(obscurePassword: obscurePassword),
    );
  }

  void _onUsernameChanged(TextChangedEvent event, Emitter<LoginState> emit) {
    final username = event.value;
    var hasError = _hasError(username);
    var valid = _validateAll(state.url, username, state.password);
    emit(
      state.copyWith(username: username, usernameError: hasError, isValid: valid),
    );
  }

  void _onPasswordChanged(TextChangedEvent event, Emitter<LoginState> emit) {
    final password = event.value;
    var hasError = _hasError(password);
    var valid = _validateAll(state.url, state.username, password);
    emit(
      state.copyWith(password: password, passwordError: hasError, isValid: valid),
    );
  }

  void checkLogin() {
    _authenticationRepository.checkLogin();
  }

  Future<void> _onSubmitted(SubmittedEvent event, Emitter<LoginState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: SubmissionStatus.inProgress));
      try {
        if (state.isInit) {
          await _authenticationRepository.logIn(url: state.url, username: state.username, password: state.password);
        } else {
          var person = Person(type: UserType.admin, userName: state.username, password: state.password);
          await _authenticationRepository.createAccount(url: state.url, person: person);

          // after a succes, we auto login
          await _authenticationRepository.logIn(url: state.url, username: state.username, password: state.password);
        }

        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (ex) {
        emit(state.copyWith(status: SubmissionStatus.failure, error: ex.toString()));
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
    this.isInit = false,
    this.loaded = SubmissionStatus.initial,
    this.error = "",
  });

  final SubmissionStatus status;
  final String error;
  final String username;
  final String password;
  final String url;
  final bool obscurePassword;
  final bool isValid;
  final bool passwordError;
  final bool usernameError;
  final bool urlError;

  final bool isInit;
  final SubmissionStatus loaded;

  LoginState copyWith({
    SubmissionStatus? status,
    String? error,
    String? url,
    String? username,
    String? password,
    bool? isValid,
    bool? obscurePassword,
    bool? passwordError,
    bool? usernameError,
    bool? urlError,
    bool? isInit,
    SubmissionStatus? loaded,
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
      isInit: isInit ?? this.isInit,
      loaded: loaded ?? this.loaded,
      error: error ?? this.error,
    );
  }
}
