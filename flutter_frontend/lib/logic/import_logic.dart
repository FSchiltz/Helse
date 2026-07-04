import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/task_bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/notification.dart';

class ImportLogic {
  final Map<String, JobResult> jobs = {};
  ImportLogic();

  bool isEnabled() {
    return jobs.isNotEmpty;
  }

  Future<Execution> sync() async {
    var entries = jobs.entries.toList();
    SubmissionStatus result = SubmissionStatus.initial;
    double? progress;

    for (var job in entries) {
      if (job.value.status == JobStatus.inprogress ||
          job.value.status == JobStatus.notstarted) {
        var status = await Dependencies.services.import.status(job.key);
        if (status != null) {
          if (status.status == JobStatus.done) {
            Notify.showSystem(
              '${status.description} done',
              description: status.result,
              channel: "Imports"
            );
          } else if (status.status == JobStatus.inerror) {
            Notify.showSystem(
              '${status.description} failed',
              description: '${status.error}',
              kind: NotificationKind.error,
              channel: "Imports"
            );
          } else if (status.status == JobStatus.inprogress) {
            result = SubmissionStatus.inProgress;
            progress = status.progress;
          }

          jobs[job.key] = status;
        }
      }
    }

    return Execution(DateTime.now(), result, progress: progress);
  }

  void add(String id) {
    jobs.putIfAbsent(
      id,
      () => JobResult(
        status: JobStatus.notstarted,
        progress: null,
        userId: 0,
        description: "",
        enque: DateTime.now(),
        start: DateTime.now(),
      ),
    );
  }

  Future<void> import(Uint8List content, int type, int? patient) async {
    var id = await Dependencies.services.import.import(content, type, patient);
    if (id == null) {
      throw StateError("Incorrect job id");
    }

    add(id.id);
  }

  List<Execution> executions() {
    return jobs.entries
        .sortedByCompare((e) => e.value.enque, (a, b) => -a.compareTo(b))
        .map(
          (e) => Execution(
            e.value.enque,
            _getStatus(e.value.status),
            status: e.value.result,
            title: e.value.description,
            progress: e.value.progress,
          ),
        )
        .toList();
  }

  SubmissionStatus _getStatus(JobStatus? status) {
    switch (status) {
      case JobStatus.notstarted:
      case JobStatus.swaggerGeneratedUnknown:
      case null:
        return SubmissionStatus.initial;
      case JobStatus.inprogress:
        return SubmissionStatus.inProgress;
      case JobStatus.done:
        return SubmissionStatus.success;
      case JobStatus.inerror:
      case JobStatus.cancel:
        return SubmissionStatus.failure;
    }
  }
}
