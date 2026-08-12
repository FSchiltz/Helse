import 'dart:convert';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:file_selector/file_selector.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/services/local/database/database.dart' as db;
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:path_provider/path_provider.dart';

class LocalFileService extends LocalService implements FileService {
  static String path = 'files';

  @override
  Future<FileData?> getData(int id, int? person) async {
    final dir = await getApplicationSupportDirectory();
    final fileDir = await io.Directory('${dir.path}/$path').create();

    final file = io.File('${fileDir.path}/$id');
    var data = await file.readAsBytes();

    return FileData(type: '', data: base64.encode(data));
  }

  @override
  Future<List<File>> getEventFiles(int id, int? person) async {
    final result =
        await (database.file.select()
              ..join([
                innerJoin(
                  database.eventFiles,
                  database.eventFiles.id.equalsExp(
                        database.file.id,
                      ) &
                      database.eventFiles.event.equals(id),
                  useColumns: false,
                ),
              ])
              ..where((x) => x.person.equals(person ?? 0)))
            .get();

    final typeMap = FileType.values.asNameMap();
    return result
        .map(
          (x) => File(
            description: x.description,
            name: x.name,
            created: x.created,
            id: x.id,
            start: x.start,
            stop: x.end,
            type: typeMap[x.type],
          ),
        )
        .toList();
  }

  @override
  Future<PaginatedOfFile?> getFiles(int? person) async {
    final result =
        await (database.file.select()
              ..where((x) => x.person.equals(person ?? 0)))
            .get();

    final typeMap = FileType.values.asNameMap();
    return PaginatedOfFile(
      items: result
          .map(
            (x) => File(
              description: x.description,
              name: x.name,
              created: x.created,
              id: x.id,
              start: x.start,
              stop: x.end,
              type: typeMap[x.type] ?? FileType.none,
            ),
          )
          .toList(),
      count: result.length,
    );
  }

  @override
  Future<List<File>> getMetricFiles(int id, int? person) async {
    final result =
        await (database.file.select()
              ..join([
                innerJoin(
                  database.metricFiles,
                  database.metricFiles.id.equalsExp(
                        database.file.id,
                      ) &
                      database.metricFiles.metric.equals(id),
                  useColumns: false,
                ),
              ])
              ..where((x) => x.person.equals(person ?? 0)))
            .get();

    final typeMap = FileType.values.asNameMap();
    return result
        .map(
          (x) => File(
            description: x.description,
            name: x.name,
            created: x.created,
            id: x.id,
            start: x.start,
            stop: x.end,
            type: typeMap[x.type],
          ),
        )
        .toList();
  }

  @override
  Future<void> linkEvent(int fileId, int eventId, int? person) async {
    await database.eventFiles.insertOne(
      db.EventFilesCompanion.insert(
        created: DateTime.now().toUtc(),
        file: fileId,
        event: eventId,
      ),
    );
  }

  @override
  Future<void> linkMetric(int fileId, int metricId, int? person) async {
    await database.metricFiles.insertOne(
      db.MetricFilesCompanion.insert(
        created: DateTime.now().toUtc(),
        file: fileId,
        metric: metricId,
      ),
    );
  }

  @override
  Future<int?> postFile(UIFile file, int? person) async {
    final data = await (database.file.insertReturningOrNull(
      db.FileCompanion.insert(
        created: DateTime.now().toUtc(),
        type: FileType.none.name,
        dataType: file.file?.mimeType ?? '',
        name: file.name,
        description: file.description,
        start: DateTime.now().toUtc(),
        valid: true,
        person: person ?? 0,
      ),
    ));

    return data?.id;
  }

  @override
  Future<void> postFileData(int fileId, XFile file, int? person) async {
    final dir = await getApplicationSupportDirectory();
    final fileDir = await io.Directory('${dir.path}/$path').create();
    await file.saveTo('${fileDir.path}/$fileId');
  }

  @override
  Future<void> unlinkEvent(int fileId, int eventId, int? person) async {
    await database.eventFiles.deleteWhere(
      (x) => x.file.equals(fileId) & x.event.equals(eventId),
    );
  }

  @override
  Future<void> unlinkMetric(int fileId, int metricId, int? person) async {
    await database.metricFiles.deleteWhere(
      (x) => x.file.equals(fileId) & x.metric.equals(metricId),
    );
  }
}
