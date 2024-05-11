import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../ui/theme/notification.dart';
import '../event.dart';

class Execution {
  DateTime date;
  SubmissionStatus state;
  String? status;

  Execution(this.date, this.state, this.status);
}

class TaskBloc extends Cubit<SubmissionStatus> {
  final List<Execution> executions = [];
  Timer? timer;
  Future<String?> Function() action;
  Future<bool> Function() check;
  Duration duration;
  bool _running = false;

  TaskBloc(this.action, this.duration, this.check) : super(SubmissionStatus.initial);

  void cancel() {
    timer?.cancel();
    emit(SubmissionStatus.initial);
  }

  Future<void> start() async {
    timer = Timer.periodic(duration, (timer) async {
      try {
        if (!_running) {
          _running = true;
          if (await check.call()) {
            emit(SubmissionStatus.inProgress);
            var status = await action.call();

            executions.add(Execution(DateTime.now(), status != null ? SubmissionStatus.success : SubmissionStatus.skipped, status));
            emit(SubmissionStatus.success);
          } else {
            emit(SubmissionStatus.initial);
          }
          _running = false;
        }
      } catch (ex) {
        _running = false;
        executions.add(Execution(DateTime.now(), SubmissionStatus.failure, ex.toString()));
        emit(SubmissionStatus.failure);
        Notify.showError("$ex");
      }
    });
  }
}
