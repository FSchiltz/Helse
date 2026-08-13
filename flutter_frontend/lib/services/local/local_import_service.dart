import 'package:drift/drift.dart';
import 'package:file_selector/file_selector.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalImportService extends LocalService implements ImportService {
  static final Map<String, JobResult> _jobs = {};

  @override
  Future<List<ImportType>?> fileTypes() async {
    return [];
  }

  @override
  Future<List<JobResultInfo>> getJobs() async {
    return _jobs.entries
        .map((e) => JobResultInfo(id: e.key, result: e.value))
        .toList();
  }

  @override
  Future<JobId?> import(XFile file, int type, int? patient) {
    throw UnimplementedError();
  }

  @override
  Future<ImportsResult?> importData(ImportData file, {int? person}) async {
    final id = _jobs.length.toString();
    _jobs[id] = JobResult(
      description: "Import",
      userId: person ?? 0,
      start: DateTime.now(),
      enque: DateTime.now(),
      progress: 0,
      status: JobStatus.inprogress,
    );

    final total = (file.metrics?.length ?? 0) + (file.events?.length ?? 0);
    var count = 0;
    var skippedMetric = 0;
    var addedMetric = 0;
    var skippedEvent = 0;
    var addedEvent = 0;

    try {
      for (final metric in file.metrics ?? <CreateMetric>[]) {
        final exists =
            await (database.metric.select()..where(
                  (x) =>
                      x.person.equals(person ?? 0) &
                      x.type.equals(metric.type) &
                      x.sourceId.equals(metric.sourceId) &
                      x.source.equals(
                        metric.source?.name ?? ImportTypes.none.name,
                      ),
                ))
                .getSingleOrNull();

        if (exists == null) {
          await Dependencies.services.metric.addMetrics(metric, person: person);
          addedMetric++;
        } else {
          skippedMetric++;
        }
        count++;

        _jobs[id] = _jobs[id]!.copyWith(
          progress: (count / total.toDouble()) * 100,
        );
      }

      for (final event in file.events ?? <CreateEvent>[]) {
        final exists =
            await (database.event.select()..where(
                  (x) =>
                      x.person.equals(person ?? 0) &
                      x.source.equals(
                        event.source?.name ?? ImportTypes.none.name,
                      ) &
                      x.sourceId.equals(event.sourceId) &
                      x.type.equals(event.type),
                ))
                .getSingleOrNull();

        if (exists == null) {
          await Dependencies.services.event.addEvent(event, person: person);
          addedEvent++;
        } else {
          skippedEvent++;
        }

        count++;

        _jobs[id] = _jobs[id]!.copyWith(
          progress: (count / total.toDouble()) * 100,
        );
      }

      _jobs[id] = _jobs[id]!.copyWith(
        progress: 100,
        status: JobStatus.done,
        stop: DateTime.now(),
      );
    } catch (e) {
      _jobs[id] = _jobs[id]!.copyWith(
        status: JobStatus.inerror,
        error: e.toString(),
        stop: DateTime.now(),
      );
    }

    return ImportsResult(
      events: ImportResult(
        imported: addedEvent,
        skipped: skippedEvent,
        failed: 0,
      ),
      metrics: ImportResult(
        imported: addedMetric,
        skipped: skippedMetric,
        failed: 0,
      ),
    );
  }

  @override
  Future<JobResult?> status(String id) async {
    return _jobs[id];
  }
}
