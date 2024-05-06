import 'dart:async';

import 'package:bloc/bloc.dart';
import '../d_i.dart';
import 'authentication_logic.dart';

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc() : super(AuthenticationStatus.unknown) {
    _authenticationStatusSubscription = DI.authentication.status.listen((status) => _onAuthenticationStatusChanged(status));
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
