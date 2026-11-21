import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:helse/di/app_logger.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc() : super(AuthenticationStatus.unknown);

  Future<void> add(AuthenticationStatus status) async {
    appLogger.d('Status changed to ${status.name}');
    emit(status);
  }
}
