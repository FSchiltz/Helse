import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'event.dart';

class Execution {
  final DateTime date;
  final SubmissionStatus state;
  final String? status;
  final double? progress;
  final String? title;

  const Execution(
    this.date,
    this.state, {
    this.status,
    this.progress,
    this.title,
  });

  Execution.empty() : this(DateTime.now(), SubmissionStatus.initial);

  Execution.progress({double? progress})
    : this(DateTime.now(), SubmissionStatus.inProgress, progress: progress);

  Execution.failure() : this(DateTime.now(), SubmissionStatus.failure);

  Execution.skipped({String? status})
    : this(DateTime.now(), SubmissionStatus.skipped, status: status);
}

class TaskBloc extends Cubit<Execution> {
  final List<Execution> executions = [];
  Timer? timer;
  Future<Execution> Function() action;
  bool Function() check;
  Duration duration;
  bool _running = false;

  TaskBloc(this.action, this.duration, this.check) : super(Execution.empty());

  void cancel() {
    timer?.cancel();
    emit(Execution.empty());
  }

  void start() {
    execute();
    timer = Timer.periodic(duration, (timer) async => await execute());
  }

  Future<void> execute() async {
    try {
      if (!_running) {
        _running = true;
        if (check.call()) {
          emit(Execution.progress());
          var status = await action.call();

          executions.insert(0, status);
          emit(status);
        } else {
          emit(Execution.empty());
        }
        _running = false;
      }
    } catch (ex) {
      _running = false;
      executions.insert(
        0,
        Execution(
          DateTime.now(),
          SubmissionStatus.failure,
          status: ex.toString(),
        ),
      );
      emit(Execution.failure());
      log("$ex");
    }
  }
}
