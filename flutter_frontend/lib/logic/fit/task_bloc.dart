import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../ui/common/notification.dart';
import '../event.dart';

class Execution {
  DateTime date;
  SubmissionStatus state;
  String? status;
  double? progress;
  String? title;

  Execution(this.date, this.state, {this.status, this.progress, this.title});
}

class TaskBloc extends Cubit<SubmissionStatus> {
  final List<Execution> executions = [];
  Timer? timer;
  Future<String?> Function() action;
  bool Function() check;
  Duration duration;
  bool _running = false;

  TaskBloc(this.action, this.duration, this.check)
    : super(SubmissionStatus.initial);

  void cancel() {
    timer?.cancel();
    emit(SubmissionStatus.initial);
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
          emit(SubmissionStatus.inProgress);
          var status = await action.call();

          final result = status != null
              ? SubmissionStatus.success
              : SubmissionStatus.skipped;
          executions.add(Execution(DateTime.now(), result, status: status));
          emit(result);
        } else {
          emit(SubmissionStatus.initial);
        }
        _running = false;
      }
    } catch (ex) {
      _running = false;
      executions.add(
        Execution(
          DateTime.now(),
          SubmissionStatus.failure,
          status: ex.toString(),
        ),
      );
      emit(SubmissionStatus.failure);
      Notify.showError("$ex");
    }
  }
}
