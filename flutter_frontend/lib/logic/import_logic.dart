import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/task_bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class JobCheckResult {
  final JobResult result;
  final DateTime time;

  JobCheckResult(this.result, this.time);
}

class ImportLogic {
  final Map<String, JobCheckResult> jobs = {};
  ImportLogic();

  Future<bool> isEnabled() async {
    return jobs.isNotEmpty;
  }

  Future<SubmissionStatus> sync() async {
    var entries = jobs.entries.toList();
    SubmissionStatus result = SubmissionStatus.initial;

    for (var job in entries) {
      if (job.value.result.status == JobStatus.inprogress ||
          job.value.result.status == JobStatus.notstarted) {
        var status = await DI.import.status(job.key);
        if (status != null) {
          result = SubmissionStatus.inProgress;
          jobs[job.key] = JobCheckResult(status, DateTime.now().toLocal());
        }
      }
    }

    return result;
  }

  void add(String id) {
    jobs.putIfAbsent(
      id,
      () => JobCheckResult(
        JobResult(status: JobStatus.inprogress, progress: 0, userId: 0),
        DateTime.now(),
      ),
    );
  }

  Future<void> import(String content, int type) async {
    var id = await DI.import.import(content, type);
    if (id == null) {
      throw StateError("Incorrect job id");
    }

    add(id.id);
  }

  List<Execution> executions() {
    return jobs.entries
        .map(
          (e) => Execution(
            e.value.time,
            _getStatus(e.value.result.status),
            "Task ${e.key} has progress ${e.value.result.progress?.toStringAsFixed(2)} %",
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
        return SubmissionStatus.failure;
    }
  }
}
