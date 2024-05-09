import 'dart:async';

import 'package:bloc/bloc.dart';

import '../event.dart';

class Execution {
  DateTime date;
  SubmissionStatus state;

  Execution(this.date, this.state);
}

class TaskBloc extends Cubit<SubmissionStatus> {
  final List<Execution> executions = [];
  Timer? timer;
  Future<void> Function() action;
  Future<bool> Function() check;
  Duration duration;

  TaskBloc(this.action, this.duration, this.check) : super(SubmissionStatus.initial);

  void cancel() {
    timer?.cancel();
    emit(SubmissionStatus.initial);
  }

  Future<void> start() async {
    if (await check.call()) {
      timer = Timer.periodic(duration, (timer) async {
        try {
          emit(SubmissionStatus.inProgress);
          await action.call();
          executions.add(Execution(DateTime.now(), SubmissionStatus.success));
          emit(SubmissionStatus.success);
        } catch (ex) {
          executions.add(Execution(DateTime.now(), SubmissionStatus.failure));
          emit(SubmissionStatus.failure);
        }
      });
    }
  }
}
