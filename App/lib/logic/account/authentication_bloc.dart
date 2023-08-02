import 'dart:async';

import 'package:bloc/bloc.dart';
import 'authentication_logic.dart';

class AuthenticationState {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.token = "",
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(String token) : this._(status: AuthenticationStatus.authenticated, token: token);

  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final String token;
}

class AuthenticationBloc extends Cubit<AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationLogic authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen((status) => _onAuthenticationStatusChanged(status));
  }

  final AuthenticationLogic _authenticationRepository;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(AuthenticationStatus status) async {
    switch (status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final token = await _authenticationRepository.getToken();
        return emit(
          token != null ? AuthenticationState.authenticated(token) : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }
}
