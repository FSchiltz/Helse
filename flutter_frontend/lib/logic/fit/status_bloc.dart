import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import '../event.dart';

class StatusBloc extends Cubit<SubmissionStatus> {
  Timer? timer;
  Future<SubmissionStatus> Function() action;
  bool Function() check;
  Duration duration;
  bool _running = false;

  StatusBloc(this.action, this.duration, this.check)
    : super(SubmissionStatus.initial);

  void cancel() {
    timer?.cancel();
    emit(SubmissionStatus.initial);
  }

  Future<void> start() async {
    timer = Timer.periodic(duration, (timer) async {
      try {
        if (!_running) {
          _running = true;
          if (check.call()) {
            var status = await action.call();
            emit(status);
          } else {
            emit(SubmissionStatus.initial);
          }
          _running = false;
        }
      } catch (ex) {
        _running = false;
        emit(SubmissionStatus.failure);
        log("$ex");
      }
    });
  }
}
