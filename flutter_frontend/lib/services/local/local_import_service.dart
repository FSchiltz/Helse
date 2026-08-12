import 'package:drift/drift.dart';
import 'package:file_selector/file_selector.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalImportService extends LocalService implements ImportService {
  @override
  Future<List<ImportType>?> fileTypes() async {
    return [];
  }

  @override
  Future<List<JobResultInfo>> getJobs() async {
    return [];
  }

  @override
  Future<JobId?> import(XFile file, int type, int? patient) {
    throw UnimplementedError();
  }

  @override
  Future<ImportsResult?> importData(ImportData file, {int? person}) async {
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
      }
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
      }
    }

    return ImportsResult(
      events: ImportResult(
        imported: file.events?.length ?? 0,
        skipped: 0,
        failed: 0,
      ),
      metrics: ImportResult(
        imported: file.metrics?.length ?? 0,
        skipped: 0,
        failed: 0,
      ),
    );
  }

  @override
  Future<JobResult?> status(String id) async {
    return null;
  }
}
