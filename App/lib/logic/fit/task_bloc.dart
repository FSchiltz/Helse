import 'dart:async';

import 'package:bloc/bloc.dart';

import '../event.dart';

class TaskBloc extends Cubit<SubmissionStatus> {
  TaskBloc() : super(SubmissionStatus.initial);

  Future<void> execute(Future<void> Function() action, Duration delay) async {
    Timer.periodic(delay, (timer) async {
      try {
        emit(SubmissionStatus.inProgress);
        await action.call();
        emit(SubmissionStatus.success);
      } catch (ex) {
        emit(SubmissionStatus.failure);
      }
    });
  }
}
