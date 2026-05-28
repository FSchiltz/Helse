import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../di/dependencies.dart';
import 'authentication_logic.dart';

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc() : super(AuthenticationStatus.unknown) {
    _authenticationStatusSubscription = Dependencies.logics.authentication.status.listen((status) => _onAuthenticationStatusChanged(status));
  }

  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(AuthenticationStatus status) async {
    emit(status);
  }
}
