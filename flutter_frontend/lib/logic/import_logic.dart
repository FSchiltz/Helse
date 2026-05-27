import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/task_bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ImportLogic {
  final Map<String, JobResult> jobs = {};
  ImportLogic();

  Future<bool> isEnabled() async {
    return jobs.isNotEmpty;
  }

  Future<SubmissionStatus> sync() async {
    var entries = jobs.entries.toList();
    SubmissionStatus result = SubmissionStatus.initial;

    for (var job in entries) {
      if (job.value.status == JobStatus.inprogress ||
          job.value.status == JobStatus.notstarted) {
        var status = await DI.import.status(job.key);
        if (status != null) {
          result = SubmissionStatus.inProgress;
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
            e.value.start,
            _getStatus(e.value.status),
            title: e.value.description,
            progress: e.value.progress ,
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
