import 'dart:async';

import 'package:bloc/bloc.dart';
import 'authentication_logic.dart';

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc({
    required this.authenticationRepository,
  }) : super(AuthenticationStatus.unknown) {
    _authenticationStatusSubscription = authenticationRepository.status
        .listen((status) => _onAuthenticationStatusChanged(status));
  }

  final AuthenticationLogic authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
      AuthenticationStatus status) async {
    emit(status);
  }
}
