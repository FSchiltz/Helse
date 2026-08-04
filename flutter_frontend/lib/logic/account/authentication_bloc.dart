import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc() : super(AuthenticationStatus.unknown);

  Future<void> add(AuthenticationStatus status) async {
    log('Status changed to ${status.name}');
    emit(status);    
  }
}
