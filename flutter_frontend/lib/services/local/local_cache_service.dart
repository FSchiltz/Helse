import 'dart:convert';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart'
    as api;
import 'package:path_provider/path_provider.dart';

class LocalCacheService extends LocalService {
  LocalCacheService(super.account);

  Future<void> expireServerCache() => database.expireServerCache();

  Future<int> metricServerId(int id) async {
    final byServerId = await (database.select(
      database.metric,
    )..where((metric) => metric.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.serverId ?? byServerId.id;
    final byId = await (database.select(
      database.metric,
    )..where((metric) => metric.id.equals(id))).getSingleOrNull();
    return byId?.serverId ?? id;
  }

  Future<int> eventServerId(int id) async {
    final byServerId = await (database.select(
      database.event,
    )..where((event) => event.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.serverId ?? byServerId.id;
    final byId = await (database.select(
      database.event,
    )..where((event) => event.id.equals(id))).getSingleOrNull();
    return byId?.serverId ?? id;
  }

  Future<bool> metricSynced(int id) async {
    final byServerId = await (database.select(
      database.metric,
    )..where((metric) => metric.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.synced;
    final byId = await (database.select(
      database.metric,
    )..where((metric) => metric.id.equals(id))).getSingleOrNull();
    return byId?.synced ?? true;
  }

  Future<bool> eventSynced(int id) async {
    final byServerId = await (database.select(
      database.event,
    )..where((event) => event.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.synced;
    final byId = await (database.select(
      database.event,
    )..where((event) => event.id.equals(id))).getSingleOrNull();
    return byId?.synced ?? true;
  }

  Future<void> removeMetric(int id) async {
    final row = await (database.select(
      database.metric,
    )..where((metric) => metric.serverId.equals(id))).getSingleOrNull();
    final local =
        row ??
        await (database.select(
          database.metric,
        )..where((metric) => metric.id.equals(id))).getSingleOrNull();
    if (local == null) return;
    await (database.delete(
      database.metric,
    )..where((metric) => metric.id.equals(local.id))).go();
  }

  Future<void> removeEvent(int id) async {
    final row = await (database.select(
      database.event,
    )..where((event) => event.serverId.equals(id))).getSingleOrNull();
    final local =
        row ??
        await (database.select(
          database.event,
        )..where((event) => event.id.equals(id))).getSingleOrNull();
    if (local == null) return;
    await (database.delete(
      database.event,
    )..where((event) => event.id.equals(local.id))).go();
  }

  Future<void> saveGroups(List<api.Group> values) async {
    for (final value in values) {
      final id = value.id;
      if (id == null) continue;

      final byServerId = await (database.select(
        database.group,
      )..where((row) => row.serverId.equals(id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.group,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      final existing =
          byServerId ??
          (byId != null &&
                  byId.synced &&
                  (byId.serverId == null || byId.serverId == id)
              ? byId
              : null);
      final localId = existing?.id ?? (byId == null ? id : null);

      await database
          .into(database.group)
          .insertOnConflictUpdate(
            GroupCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              name: value.name,
              description: value.description,
              showOnDashboard: value.showOnDashboard ?? false,
              showTitle: value.showTitle ?? false,
              created: DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<void> saveMetricTypes(List<api.MetricType> values) async {
    for (final value in values) {
      final groupId = await _ensureGroup(value.groupId);
      final unitId = await _saveUnit(value.unit);
      final id = value.id;
      final byServerId = await (database.select(
        database.metricType,
      )..where((row) => row.serverId.equals(id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.metricType,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      final existing =
          byServerId ??
          (byId != null &&
                  byId.synced &&
                  (byId.serverId == null || byId.serverId == id)
              ? byId
              : null);
      final localId = existing?.id ?? (byId == null ? id : null);

      await database
          .into(database.metricType)
          .insertOnConflictUpdate(
            MetricTypeCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              name: value.name,
              description: Value(value.description),
              groupId: groupId,
              timeDifference: Value(value.timeDifference),
              visible: value.visible ?? false,
              valueCount: Value(value.valueCount),
              showOnDashboard: value.showOnDashboard ?? false,
              userEditable: value.userEditable,
              summaryType: value.summaryType?.name ?? '',
              type: value.type?.name ?? '',
              unit: unitId,
              created: DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(value.id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<void> saveEventTypes(List<api.EventType> values) async {
    for (final value in values) {
      final groupId = await _ensureGroup(value.groupId);
      final id = value.id;
      final byServerId = await (database.select(
        database.eventType,
      )..where((row) => row.serverId.equals(id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.eventType,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      final existing =
          byServerId ??
          (byId != null &&
                  byId.synced &&
                  (byId.serverId == null || byId.serverId == id)
              ? byId
              : null);
      final localId = existing?.id ?? (byId == null ? id : null);

      await database
          .into(database.eventType)
          .insertOnConflictUpdate(
            EventTypeCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              name: value.name,
              description: Value(value.description),
              standAlone: value.standAlone ?? false,
              visible: value.visible ?? false,
              timeDifference: Value(value.timeDifference),
              userEditable: value.userEditable,
              groupId: groupId,
              created: DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(value.id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<void> savePersons(
    List<api.Person> values, {
    bool addPatientType = false,
  }) async {
    for (final value in values) {
      final id = value.id;

      final byServerId = await (database.select(
        database.person,
      )..where((row) => row.serverId.equals(id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.person,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      final existing =
          byServerId ??
          (byId != null &&
                  byId.synced &&
                  (byId.serverId == null || byId.serverId == id)
              ? byId
              : null);
      final localId = existing?.id ?? (byId == null ? id : null);

      await database
          .into(database.person)
          .insertOnConflictUpdate(
            PersonCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              identifier: value.identifier ?? 'server-${value.id}',
              name: Value(value.name),
              birth: Value(value.birth),
              email: Value(value.email),
              phone: Value(value.phone),
              surname: Value(value.surname),
              types: Value(
                addPatientType
                    ? UserType.patient.name
                    : value.types?.map((type) => type.name).join(';'),
              ),
              created: value.created ?? DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(value.id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<void> saveProfilePicture(int person, String? picture) async {
    final existing =
        await (database.select(
          database.person,
        )..where((row) => row.serverId.equals(person))).getSingleOrNull() ??
        await (database.select(
          database.person,
        )..where((row) => row.id.equals(person))).getSingleOrNull();
    if (existing != null && !existing.synced) return;
    final localId = existing?.id ?? await _ensurePerson(person);

    await (database.update(
      database.person,
    )..where((row) => row.id.equals(localId))).write(
      PersonCompanion(
        profilePicture: Value(picture),
        synced: const Value(true),
        serverId: Value(existing?.serverId ?? person),
        syncTime: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> saveUnits(List<api.Unit> values) async {
    for (final value in values) {
      await _saveUnit(value);
    }
  }

  Future<void> saveFiles(
    List<api.File> values,
    int? person, {
    int? metricId,
    int? eventId,
  }) async {
    for (final value in values) {
      final id = value.id;
      if (id == null) continue;

      final localPerson = await _ensurePerson(person ?? 0);
      final byServerId = await (database.select(
        database.file,
      )..where((row) => row.serverId.equals(id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.file,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      final existing =
          byServerId ??
          (byId?.synced == true &&
                  (byId?.serverId == null || byId?.serverId == id)
              ? byId
              : null);
      final localId = existing?.id ?? (byId == null ? id : null);

      final localFileId = await database
          .into(database.file)
          .insertOnConflictUpdate(
            FileCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              type: value.type?.name ?? FileType.none.name,
              dataType: '',
              name: value.name,
              description: value.description,
              start: value.start ?? value.created ?? DateTime.now().toUtc(),
              end: Value(value.stop),
              valid: true,
              person: localPerson,
              created: value.created ?? DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );

      if (metricId != null) {
        await _linkFile(localFileId, metricId, isEvent: false);
      }
      if (eventId != null) {
        await _linkFile(localFileId, eventId, isEvent: true);
      }
    }
  }

  Future<void> saveFileData(int id, String? encoded) async {
    if (encoded == null) return;

    final existing = await (database.select(
      database.file,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    final localId = existing?.id ?? id;
    if (kIsWeb) {
      await (database.file.update()..where((row) => row.id.equals(localId)))
          .write(FileCompanion(content: Value(base64.decode(encoded))));
      return;
    }

    final directory = await getApplicationSupportDirectory();
    final files = await io.Directory('${directory.path}/files').create();
    await io.File(
      '${files.path}/$localId',
    ).writeAsBytes(base64.decode(encoded));
  }

  Future<void> saveMetrics(List<api.Metric> values) async {
    for (final value in values) {
      final byServerId = await (database.select(
        database.metric,
      )..where((row) => row.serverId.equals(value.id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.metric,
      )..where((row) => row.id.equals(value.id))).getSingleOrNull();
      final local =
          byServerId ??
          (byId != null &&
                  byId.synced &&
                  (byId.serverId == null || byId.serverId == value.id)
              ? byId
              : null);
      final localId = local?.id ?? (byId == null ? value.id : null);
      final localPerson = await _ensurePerson(value.person);
      final localType = await _ensureMetricType(value.type);
      final unit = value.unit;
      final unitId = unit is int ? await _ensureUnit(unit) : null;

      await database
          .into(database.metric)
          .insertOnConflictUpdate(
            MetricCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              person: localPerson,
              type: localType,
              unit: Value(unitId),
              date: value.date,
              value: value.value,
              tag: Value(value.tag),
              source: value.source?.name ?? ImportTypes.none.name,
              sourceId: value.sourceId,
              created: DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(value.id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<void> saveEvents(List<api.Event> values) async {
    for (final value in values) {
      final byServerId = await (database.select(
        database.event,
      )..where((row) => row.serverId.equals(value.id))).getSingleOrNull();
      if (byServerId != null && !byServerId.synced) continue;
      final byId = await (database.select(
        database.event,
      )..where((row) => row.id.equals(value.id))).getSingleOrNull();
      final local =
          byServerId ??
          (byId != null &&
                  byId.synced &&
                  (byId.serverId == null || byId.serverId == value.id)
              ? byId
              : null);
      final localId = local?.id ?? (byId == null ? value.id : null);

      final localPerson = await _ensurePerson(value.person);
      final localType = await _ensureEventType(value.type);

      await database
          .into(database.event)
          .insertOnConflictUpdate(
            EventCompanion.insert(
              id: localId == null ? const Value.absent() : Value(localId),
              person: localPerson,
              type: localType,
              description: Value(value.description),
              start: value.start,
              end: value.stop,
              tag: Value(value.tag),
              notificationTime: Value(value.notificationTime),
              source: value.source?.name ?? ImportTypes.none.name,
              sourceId: value.sourceId,
              created: DateTime.now().toUtc(),
              synced: const Value(true),
              serverId: Value(value.id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<int> _ensureGroup(int id) async {
    final byServerId = await (database.select(
      database.group,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.id;
    final byId = await (database.select(
      database.group,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (byId != null && byId.synced && byId.serverId == null) {
      await (database.group.update()..where((row) => row.id.equals(byId.id)))
          .write(
            GroupCompanion(
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
      return byId.id;
    }

    return await database
        .into(database.group)
        .insert(
          GroupCompanion.insert(
            id: byId == null ? Value(id) : const Value.absent(),
            name: 'Group $id',
            description: '',
            showOnDashboard: false,
            showTitle: false,
            created: DateTime.now().toUtc(),
            synced: const Value(true),
            serverId: Value(id),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<int> _ensureMetricType(int id) async {
    final byServerId = await (database.select(
      database.metricType,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.id;
    final byId = await (database.select(
      database.metricType,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (byId != null && byId.synced && byId.serverId == null) {
      await (database.metricType.update()
            ..where((row) => row.id.equals(byId.id)))
          .write(
            MetricTypeCompanion(
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
      return byId.id;
    }

    return await database
        .into(database.metricType)
        .insert(
          MetricTypeCompanion.insert(
            id: byId == null ? Value(id) : const Value.absent(),
            name: 'Metric $id',
            groupId: await _ensureGroup(1),
            visible: false,
            showOnDashboard: false,
            userEditable: false,
            summaryType: MetricSummary.latest.name,
            type: MetricDataType.number.name,
            unit: await _ensureUnit(0),
            created: DateTime.now().toUtc(),
            synced: const Value(true),
            serverId: Value(id),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<int> _ensureEventType(int id) async {
    final byServerId = await (database.select(
      database.eventType,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.id;
    final byId = await (database.select(
      database.eventType,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (byId != null && byId.synced && byId.serverId == null) {
      await (database.eventType.update()
            ..where((row) => row.id.equals(byId.id)))
          .write(
            EventTypeCompanion(
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
      return byId.id;
    }

    return await database
        .into(database.eventType)
        .insert(
          EventTypeCompanion.insert(
            id: byId == null ? Value(id) : const Value.absent(),
            name: 'Event $id',
            standAlone: false,
            visible: false,
            userEditable: false,
            groupId: await _ensureGroup(1),
            created: DateTime.now().toUtc(),
            synced: const Value(true),
            serverId: Value(id),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<int> _ensurePerson(int id) async {
    if (id == 0) return 0;
    final byServerId = await (database.select(
      database.person,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null) return byServerId.id;
    final byId = await (database.select(
      database.person,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (byId != null && byId.synced && byId.serverId == null) {
      await (database.person.update()..where((row) => row.id.equals(byId.id)))
          .write(
            PersonCompanion(
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
      return byId.id;
    }

    return await database
        .into(database.person)
        .insert(
          PersonCompanion.insert(
            id: byId == null ? Value(id) : const Value.absent(),
            identifier: 'server-$id',
            created: DateTime.now().toUtc(),
            synced: const Value(true),
            serverId: Value(id),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<int> _saveUnit(api.Unit value) async {
    final id = value.id;
    final byServerId = await (database.select(
      database.unit,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    if (byServerId != null && !byServerId.synced) return byServerId.id;
    final byId = await (database.select(
      database.unit,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    final existing =
        byServerId ??
        (byId?.synced == true &&
                (byId?.serverId == null || byId?.serverId == id)
            ? byId
            : null);
    final localId = existing?.id ?? (byId == null ? id : null);
    final baseUnit = value.baseUnit;

    return await database
        .into(database.unit)
        .insertOnConflictUpdate(
          UnitCompanion.insert(
            id: localId == null ? const Value.absent() : Value(localId),
            code: value.code,
            description: value.description ?? '',
            type: value.type.name,
            baseUnit: Value(
              baseUnit is int ? await _ensureUnit(baseUnit) : null,
            ),
            created: DateTime.now().toUtc(),
            synced: const Value(true),
            serverId: Value(id),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<int> _ensureUnit(int id) async {
    final existing = await (database.select(
      database.unit,
    )..where((row) => row.serverId.equals(id))).getSingleOrNull();
    if (existing != null) return existing.id;
    final byId = await (database.select(
      database.unit,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (byId != null && byId.synced && byId.serverId == null) {
      await (database.unit.update()..where((row) => row.id.equals(byId.id)))
          .write(
            UnitCompanion(
              serverId: Value(id),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
      return byId.id;
    }
    return await database
        .into(database.unit)
        .insert(
          UnitCompanion.insert(
            id: byId == null ? Value(id) : const Value.absent(),
            code: '',
            description: 'Unit $id',
            type: UnitType.none.name,
            baseUnit: const Value(null),
            created: DateTime.now().toUtc(),
            synced: const Value(true),
            serverId: Value(id),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<void> _linkFile(
    int fileId,
    int recordId, {
    required bool isEvent,
  }) async {
    if (isEvent) {
      final localEvent =
          await (database.select(database.event)
                ..where((event) => event.serverId.equals(recordId)))
              .getSingleOrNull() ??
          await (database.select(
            database.event,
          )..where((event) => event.id.equals(recordId))).getSingleOrNull();
      if (localEvent == null) {
        appLogger.w(
          '[OfflineCache] Skipped event file link; event $recordId is not cached',
        );
        return;
      }

      final exists =
          await (database.select(database.eventFiles)..where(
                (row) =>
                    row.file.equals(fileId) & row.event.equals(localEvent.id),
              ))
              .getSingleOrNull();
      if (exists == null) {
        await database.eventFiles.insertOne(
          EventFilesCompanion.insert(
            file: fileId,
            event: localEvent.id,
            created: DateTime.now().toUtc(),
            synced: const Value(true),
          ),
        );
      }
    } else {
      final localMetric =
          await (database.select(database.metric)
                ..where((metric) => metric.serverId.equals(recordId)))
              .getSingleOrNull() ??
          await (database.select(
            database.metric,
          )..where((metric) => metric.id.equals(recordId))).getSingleOrNull();
      if (localMetric == null) {
        appLogger.w(
          '[OfflineCache] Skipped metric file link; metric $recordId is not cached',
        );
        return;
      }

      final exists =
          await (database.select(database.metricFiles)..where(
                (row) =>
                    row.file.equals(fileId) & row.metric.equals(localMetric.id),
              ))
              .getSingleOrNull();
      if (exists == null) {
        await database.metricFiles.insertOne(
          MetricFilesCompanion.insert(
            file: fileId,
            metric: localMetric.id,
            created: DateTime.now().toUtc(),
            synced: const Value(true),
          ),
        );
      }
    }
  }
}
