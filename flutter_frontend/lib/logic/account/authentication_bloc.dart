import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'authentication_logic.dart';

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc() : super(AuthenticationStatus.unset);

  Future<void> add(AuthenticationStatus status) async {
    log('Status changed to ${status.name}');
    emit(status);
  }
}
