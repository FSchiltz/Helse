import 'dart:typed_data';

import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/task_bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/notification.dart';

class ImportLogic {
  final Map<String, JobResult> jobs = {};
  ImportLogic();

  bool isEnabled() {
    return jobs.isNotEmpty;
  }

  Future<SubmissionStatus> sync() async {
    var entries = jobs.entries.toList();
    SubmissionStatus result = SubmissionStatus.initial;

    for (var job in entries) {
      if (job.value.status == JobStatus.inprogress ||
          job.value.status == JobStatus.notstarted) {
        var status = await Dependencies.services.import.status(job.key);
        if (status != null) {
          result = SubmissionStatus.inProgress;
          if (status.status == JobStatus.done) {
            Notify.showBackground('${status.description} done');
          } else if (status.status == JobStatus.inerror) {
            Notify.show(
              '${status.description} failed with ${status.error}',
              kind: NotificationKind.error,
            );
          }

          jobs[job.key] = status;
        }
      }
    }

    return result;
  }

  void add(String id) {
    jobs.putIfAbsent(
      id,
      () => JobResult(
        status: JobStatus.notstarted,
        progress: 0,
        userId: 0,
        description: "",
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
        .map(
          (e) => Execution(
            e.value.start,
            _getStatus(e.value.status),
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
