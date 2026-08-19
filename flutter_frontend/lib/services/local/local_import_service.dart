import 'dart:developer';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:file_selector/file_selector.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ImportInput {
  final SendPort sendPort;
  final DriftIsolate connection;
  final ImportData file;
  final int? person;
  final JobResult initial;

  ImportInput(
    this.sendPort,
    this.connection,
    this.file,
    this.person,
    this.initial,
  );
}

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
  Future<JobId?> importData(ImportData file, {int? person}) async {
    final id = _jobs.length.toString();
    final initial = JobResult(
      description: "Health connect sync",
      userId: person ?? 0,
      start: DateTime.now(),
      enque: DateTime.now(),
      progress: 0,
      status: JobStatus.inprogress,
    );
    _jobs[id] = initial;

    final connection = await database.serializableConnection();

    final receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message is JobResult) {
        _jobs[id] = message;
      } else if (message == 'done') {
        receivePort.close();
      }
    });

    Isolate.spawn(
      _import,
      ImportInput(receivePort.sendPort, connection, file, person, initial),
    );

    return JobId(id: id);
  }

  @override
  Future<JobResult?> status(String id) async {
    return _jobs[id];
  }

  Future<void> _import(ImportInput input) async {
    // We can't share the [database] object across isolates, but the connection
    // is fine!
    final databaseForIsolate = Database(await input.connection.connect());
    var initial = input.initial;
    final total =
        (input.file.metrics?.length ?? 0) + (input.file.events?.length ?? 0);
    var count = 0;

    var skippedMetric = 0;
    var addedMetric = 0;
    var skippedEvent = 0;
    var addedEvent = 0;

    try {
      for (final metric in input.file.metrics ?? <CreateMetric>[]) {
        final exists =
            await (databaseForIsolate.metric.select()..where(
                  (x) =>
                      x.person.equals(input.person ?? 0) &
                      x.type.equals(metric.type) &
                      x.sourceId.equals(metric.sourceId) &
                      x.source.equals(
                        metric.source?.name ?? ImportTypes.none.name,
                      ),
                ))
                .getSingleOrNull();

        if (exists == null) {
          await databaseForIsolate.metric.insertReturning(
            MetricCompanion.insert(
              date: metric.date,
              type: metric.type,
              value: metric.value,
              person: input.person ?? 0,
              created: DateTime.now().toUtc(),
              source: metric.source!.name,
              sourceId: metric.sourceId,
            ),
          );
          addedMetric++;
        } else {
          skippedMetric++;
        }

        count++;

        initial = initial.copyWith(progress: (count / total.toDouble()) * 100);
        input.sendPort.send(initial);
      }

      for (final event in input.file.events ?? <CreateEvent>[]) {
        final exists =
            await (databaseForIsolate.event.select()..where(
                  (x) =>
                      x.person.equals(input.person ?? 0) &
                      x.source.equals(
                        event.source?.name ?? ImportTypes.none.name,
                      ) &
                      x.sourceId.equals(event.sourceId) &
                      x.type.equals(event.type),
                ))
                .getSingleOrNull();

        if (exists == null) {
          await databaseForIsolate.event.insertReturning(
            EventCompanion.insert(
              description: Value(event.description),
              end: event.stop,
              start: event.start,
              type: event.type,
              person: input.person ?? 0,
              created: DateTime.now().toUtc(),
              notificationTime: Value(event.notificationTime),
              sourceId: event.sourceId,
              source: event.source!.name,
              tag: Value(event.tag),
            ),
          );
          addedEvent++;
        } else {
          skippedEvent++;
        }

        count++;

        initial = initial.copyWith(progress: (count / total.toDouble()) * 100);
        input.sendPort.send(initial);
      }

      var text =
          "Metrics: $addedMetric added - $skippedMetric skipped of ${input.file.metrics?.length} \n Events: $addedEvent added - $skippedEvent skipped of ${input.file.events?.length}";
      log(text);

      initial = initial.copyWith(
        progress: 100,
        status: JobStatus.done,
        stop: DateTime.now(),
        result: text,
      );
      input.sendPort.send(initial);
    } catch (e) {
      input.sendPort.send(
        initial.copyWith(
          status: JobStatus.inerror,
          error: e.toString(),
          stop: DateTime.now(),
        ),
      );
    }

    input.sendPort.send('done');
  }

  @override
  Future<String?> export() {
    return Database.databasePath();
  }
}
