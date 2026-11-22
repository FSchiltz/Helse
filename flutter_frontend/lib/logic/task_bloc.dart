import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:helse/di/app_logger.dart';
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
  final List<Execution> reportedExecutions = [];
  Timer? timer;
  Future<Execution> Function() action;
  bool Function() check;
  Duration duration;
  bool _running = false;
  bool _reporting = false;
  String? _reportTitle;
  double? _reportProgress;

  TaskBloc(this.action, this.duration, this.check) : super(Execution.empty());

  bool get isReporting => _reporting;

  void startReport({required String title, required String status}) {
    if (_reporting) {
      throw StateError('A task report is already in progress');
    }

    _reporting = true;
    _reportTitle = title;
    _reportProgress = 0;
    emit(
      Execution(
        DateTime.now(),
        SubmissionStatus.inProgress,
        title: title,
        status: status,
        progress: 0,
      ),
    );
  }

  void updateReport({required String status, required double progress}) {
    if (!_reporting) {
      throw StateError('No task report is in progress');
    }

    _reportProgress = progress;
    emit(
      Execution(
        DateTime.now(),
        SubmissionStatus.inProgress,
        title: _reportTitle,
        status: status,
        progress: progress,
      ),
    );
  }

  void finishReport({required bool success, required String status}) {
    if (!_reporting) {
      throw StateError('No task report is in progress');
    }

    final execution = Execution(
      DateTime.now(),
      success ? SubmissionStatus.success : SubmissionStatus.failure,
      title: _reportTitle,
      status: status,
      progress: success ? 100 : _reportProgress,
    );
    reportedExecutions.insert(0, execution);
    _reporting = false;
    _reportTitle = null;
    _reportProgress = null;
    emit(execution);
  }

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
      if (!_running && !_reporting) {
        _running = true;
        if (check.call()) {
          emit(Execution.progress());
          var status = await action.call();

          executions.insert(0, status);
          if (!_reporting) emit(status);
        } else {
          if (!_reporting) emit(Execution.empty());
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
      if (!_reporting) emit(Execution.failure());
      appLogger.e("Task execution failed", error: ex);
    }
  }
}
