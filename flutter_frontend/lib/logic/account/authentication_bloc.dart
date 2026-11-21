import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:material_ui/material_ui.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationBloc extends Cubit<AuthenticationStatus> {
  AuthenticationBloc() : super(AuthenticationStatus.unknown);

  Future<void> add(AuthenticationStatus status) async {
    debugPrint('Status changed to ${status.name}');
    emit(status);    
  }
}
