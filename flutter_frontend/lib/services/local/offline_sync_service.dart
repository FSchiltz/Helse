import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:file_selector/file_selector.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/account/authentication_bloc.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/api/api_event_service.dart';
import 'package:helse/services/api/api_file_service.dart';
import 'package:helse/services/api/api_metric_service.dart';
import 'package:helse/services/api/api_user_service.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_file_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:path_provider/path_provider.dart';

class OfflineSyncService extends LocalService {
  OfflineSyncService(super.account);


  Future<void> sync() async {
    await _syncGroups();
    await _syncMetricTypes();
    await _syncEventTypes();
    await _syncPeople();
    await _syncMetrics();
    await _syncEvents();
    await _syncFiles();
    await _syncFileLinks();
    await _syncDeletions();
  }

  Future<void> syncPendingChanges() async {
    try {
      await sync();
    } catch (error, stackTrace) {
      appLogger.e(
        '[OfflineSync] Failed to synchronize local changes',
        error: error,
        stackTrace: stackTrace,
      );
    }

    if (Dependencies.blocs.auth.state != AuthenticationStatus.authenticated) {
      return;
    }

    if (account.isEnabled(Account.pendingUserSettings)) {
      try {
        await Dependencies.services.settings.savePersonSettings(
          Dependencies.logics.settings.userSettings(),
        );
        if (Dependencies.blocs.auth.state ==
            AuthenticationStatus.authenticated) {
          await account.setBool(Account.pendingUserSettings, false);
        }
      } catch (error, stackTrace) {
        appLogger.e(
          '[OfflineSync] Failed to synchronize user settings',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    if (account.isEnabled(Account.pendingPatientSettings)) {
      try {
        await Dependencies.services.settings.savePatientsSettings(
          Dependencies.logics.patientsSettings.patientsSettings(),
        );
        if (Dependencies.blocs.auth.state ==
            AuthenticationStatus.authenticated) {
          await account.setBool(Account.pendingPatientSettings, false);
        }
      } catch (error, stackTrace) {
        appLogger.e(
          '[OfflineSync] Failed to synchronize patient settings',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _syncGroups() async {
    final service = ApiMetricService(account);
    final rows = await (database.select(
      database.group,
    )..where((row) => row.synced.equals(false))).get();

    for (final row in rows) {
      final serverId = row.serverId;
      if (serverId == null) {
        final id = await service.addGroup(
          CreateGroup(
            name: row.name,
            description: row.description,
            showOnDashboard: row.showOnDashboard,
            showTitle: row.showTitle,
          ),
        );
        if (id == null) {
          throw StateError('Server did not return an ID for group ${row.id}');
        }
        await (database.group.update()
              ..where((group) => group.id.equals(row.id)))
            .write(
              GroupCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
                serverId: Value(id),
              ),
            );
      } else {
        await service.updateGroup(
          UpdateGroup(
            id: serverId,
            name: row.name,
            description: row.description,
            showOnDashboard: row.showOnDashboard,
            showTitle: row.showTitle,
          ),
        );
        _ensureSession();
        await (database.group.update()
              ..where((group) => group.id.equals(row.id)))
            .write(
              GroupCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
              ),
            );
      }
    }
  }

  Future<void> _syncMetricTypes() async {
    final service = ApiMetricService(account);
    final rows = await (database.select(
      database.metricType,
    )..where((row) => row.synced.equals(false))).get();

    for (final row in rows) {
      final groupId = await _groupServerId(row.groupId);
      final unitId = await _unitServerId(row.unit);
      final serverId = row.serverId;
      if (serverId == null) {
        final id = await service.addMetricsType(
          CreateMetricType(
            name: row.name,
            description: row.description,
            type: MetricDataType.values.byName(row.type),
            summaryType: MetricSummary.values.byName(row.summaryType),
            groupId: groupId,
            unit: unitId,
            timeDifference: row.timeDifference,
            valueCount: row.valueCount,
            showOnDashboard: row.showOnDashboard,
            visible: row.visible,
          ),
        );
        if (id == null) {
          throw StateError(
            'Server did not return an ID for metric type ${row.id}',
          );
        }
        await (database.metricType.update()
              ..where((type) => type.id.equals(row.id)))
            .write(
              MetricTypeCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
                serverId: Value(id),
              ),
            );
      } else {
        await service.updateMetricsType(
          UpdateMetricType(
            id: serverId,
            name: row.name,
            description: row.description,
            type: MetricDataType.values.byName(row.type),
            summaryType: MetricSummary.values.byName(row.summaryType),
            groupId: groupId,
            unit: unitId,
            timeDifference: row.timeDifference,
            valueCount: row.valueCount,
            showOnDashboard: row.showOnDashboard,
            visible: row.visible,
          ),
        );
        _ensureSession();
        await (database.metricType.update()
              ..where((type) => type.id.equals(row.id)))
            .write(
              MetricTypeCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
              ),
            );
      }
    }
  }

  Future<void> _syncEventTypes() async {
    final service = ApiEventService(account);
    final rows = await (database.select(
      database.eventType,
    )..where((row) => row.synced.equals(false))).get();

    for (final row in rows) {
      final groupId = await _groupServerId(row.groupId);
      final serverId = row.serverId;
      if (serverId == null) {
        final id = await service.addEventsType(
          CreateEventType(
            name: row.name,
            description: row.description,
            standAlone: row.standAlone,
            visible: row.visible,
            timeDifference: row.timeDifference,
            groupId: groupId,
          ),
        );
        if (id == null) {
          throw StateError(
            'Server did not return an ID for event type ${row.id}',
          );
        }
        await (database.eventType.update()
              ..where((type) => type.id.equals(row.id)))
            .write(
              EventTypeCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
                serverId: Value(id),
              ),
            );
      } else {
        await service.updateEventsType(
          UpdateEventType(
            id: serverId,
            name: row.name,
            description: row.description,
            standAlone: row.standAlone,
            visible: row.visible,
            timeDifference: row.timeDifference,
            groupId: groupId,
          ),
        );
        _ensureSession();
        await (database.eventType.update()
              ..where((type) => type.id.equals(row.id)))
            .write(
              EventTypeCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
              ),
            );
      }
    }
  }

  Future<void> _syncPeople() async {
    final service = ApiUserService(account);
    final rows = await (database.select(
      database.person,
    )..where((row) => row.synced.equals(false))).get();

    for (final row in rows) {
      if (row.id == 0) continue;

      final types =
          row.types
              ?.split(';')
              .where((type) => type.isNotEmpty)
              .map(UserType.values.byName)
              .toList() ??
          [];
      final serverId = row.serverId;
      if (serverId == null) {
        if (types.any((type) => type != UserType.patient)) {
          throw StateError(
            'Offline-created person ${row.id} has unsupported account roles',
          );
        }
        final created = await service.addPerson(
          PersonCreation(
            name: row.name,
            surname: row.surname,
            identifier: row.identifier,
            birth: row.birth,
            email: row.email,
            phone: row.phone,
            profilePicture: row.profilePicture,
            types: types,
          ),
        );
        if (created == null) {
          throw StateError('Server did not return an ID for person ${row.id}');
        }
        await (database.person.update()
              ..where((person) => person.id.equals(row.id)))
            .write(
              PersonCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
                serverId: Value(created.person),
              ),
            );
      } else if (types.contains(UserType.patient)) {
        await service.updatePatient(
          UpdatePatient(
            id: serverId,
            identifier: row.identifier,
            name: row.name,
            surname: row.surname,
            birth: row.birth,
            profilePicture: row.profilePicture,
          ),
        );
        _ensureSession();
        await _markPersonSynced(row.id);
      } else {
        await service.updatePerson(
          UpdatePerson(
            id: serverId,
            identifier: row.identifier,
            name: row.name,
            surname: row.surname,
            birth: row.birth,
            email: row.email,
            phone: row.phone,
            profilePicture: row.profilePicture,
            types: types,
          ),
        );
        _ensureSession();
        await _markPersonSynced(row.id);
      }
    }
  }

  Future<void> _syncMetrics() async {
    final service = ApiMetricService(account);
    final pending = await (database.select(
      database.metric,
    )..where((row) => row.synced.equals(false))).get();

    for (final row in pending) {
      final source = ImportTypes.values.asNameMap()[row.source];
      final typeId = await _metricTypeServerId(row.type);
      final serverId = row.serverId;
      if (serverId == null) {
        final id = await service.addMetrics(
          CreateMetric(
            date: row.date,
            value: row.value,
            tag: row.tag,
            type: typeId,
            unit: row.unit,
            source: source,
            sourceId: row.sourceId,
          ),
          person: await _personServerId(row.person),
        );
        if (id == null) {
          throw StateError('Server did not return an ID for metric ${row.id}');
        }
        await (database.metric.update()
              ..where((metric) => metric.id.equals(row.id)))
            .write(
              MetricCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
                serverId: Value(id),
              ),
            );
      } else {
        await service.updateMetric(
          UpdateMetric(
            id: row.id,
            date: row.date,
            value: row.value,
            tag: row.tag,
            type: typeId,
            unit: row.unit,
            source: source,
            sourceId: row.sourceId,
          ),
        );
        _ensureSession();
        await (database.metric.update()
              ..where((metric) => metric.id.equals(row.id)))
            .write(
              MetricCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
              ),
            );
      }
    }
  }

  Future<void> _syncEvents() async {
    final service = ApiEventService(account);
    final pending = await (database.select(
      database.event,
    )..where((row) => row.synced.equals(false))).get();

    for (final row in pending) {
      final source = ImportTypes.values.asNameMap()[row.source];
      final typeId = await _eventTypeServerId(row.type);
      final serverId = row.serverId;
      if (serverId == null) {
        final id = await service.addEvent(
          CreateEvent(
            type: typeId,
            description: row.description,
            start: row.start,
            stop: row.end,
            tag: row.tag,
            notificationTime: row.notificationTime,
            source: source,
            sourceId: row.sourceId,
          ),
          person: await _personServerId(row.person),
        );
        if (id == null) {
          throw StateError('Server did not return an ID for event ${row.id}');
        }
        await (database.event.update()
              ..where((event) => event.id.equals(row.id)))
            .write(
              EventCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
                serverId: Value(id),
              ),
            );
      } else {
        await service.updateEvent(
          UpdateEvent(
            id: row.id,
            type: typeId,
            description: row.description,
            start: row.start,
            stop: row.end,
            tag: row.tag,
            notificationTime: row.notificationTime,
            source: source,
            sourceId: row.sourceId,
          ),
        );
        _ensureSession();
        await (database.event.update()
              ..where((event) => event.id.equals(row.id)))
            .write(
              EventCompanion(
                synced: const Value(true),
                syncTime: Value(DateTime.now().toUtc()),
              ),
            );
      }
    }
  }

  Future<void> _syncFiles() async {
    final service = ApiFileService(account);
    final rows = await (database.select(
      database.file,
    )..where((row) => row.synced.equals(false))).get();
    final directory = await getApplicationSupportDirectory();
    final fileDirectory = io.Directory(
      '${directory.path}/${LocalFileService.path}',
    );

    for (final row in rows) {
      final filePath = '${fileDirectory.path}/${row.id}';
      final localFile = XFile(filePath);
      if (!await io.File(filePath).exists()) {
        throw StateError('Offline file data is missing for file ${row.id}');
      }

      var serverId = row.serverId;
      final personId = await _personServerId(row.person);
      if (serverId == null) {
        serverId = await service.postFile(
          UIFile(localFile, row.name, row.id, row.description),
          personId,
        );
        if (serverId == null) {
          throw StateError('Server did not return an ID for file ${row.id}');
        }
        await (database.file.update()..where((file) => file.id.equals(row.id)))
            .write(FileCompanion(serverId: Value(serverId)));
      }

      await service.postFileData(serverId, localFile, personId);
      _ensureSession();
      await (database.file.update()..where((file) => file.id.equals(row.id)))
          .write(
            FileCompanion(
              synced: const Value(true),
              syncTime: Value(DateTime.now().toUtc()),
              serverId: Value(serverId),
            ),
          );
    }
  }

  Future<void> _syncFileLinks() async {
    final service = ApiFileService(account);
    final metricLinks = await (database.select(
      database.metricFiles,
    )..where((row) => row.synced.equals(false))).get();
    for (final link in metricLinks) {
      final metric = await (database.select(
        database.metric,
      )..where((row) => row.id.equals(link.metric))).getSingle();
      await service.linkMetric(
        await _fileServerId(link.file),
        await _metricServerId(link.metric),
        await _personServerId(metric.person),
      );
      _ensureSession();
      await (database.metricFiles.update()
            ..where((row) => row.id.equals(link.id)))
          .write(
            MetricFilesCompanion(
              synced: const Value(true),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }

    final eventLinks = await (database.select(
      database.eventFiles,
    )..where((row) => row.synced.equals(false))).get();
    for (final link in eventLinks) {
      final event = await (database.select(
        database.event,
      )..where((row) => row.id.equals(link.event))).getSingle();
      await service.linkEvent(
        await _fileServerId(link.file),
        await _eventServerId(link.event),
        await _personServerId(event.person),
      );
      _ensureSession();
      await (database.eventFiles.update()
            ..where((row) => row.id.equals(link.id)))
          .write(
            EventFilesCompanion(
              synced: const Value(true),
              syncTime: Value(DateTime.now().toUtc()),
            ),
          );
    }
  }

  Future<void> _syncDeletions() async {
    final metricService = ApiMetricService(account);
    final eventService = ApiEventService(account);
    final userService = ApiUserService(account);
    final fileService = ApiFileService(account);
    final pending = await (database.select(
      database.pendingDeletion,
    )..orderBy([(row) => OrderingTerm.asc(row.created)])).get();

    for (final deletion in pending) {
      switch (deletion.entity) {
        case 'metric':
          final api = await metricService.getService();
          await metricService.call(
            () => api.apiMetricsIdDelete(id: deletion.serverId),
          );
        case 'event':
          final api = await eventService.getService();
          await eventService.call(
            () => api.apiEventsIdDelete(id: deletion.serverId),
          );
        case 'group':
          await metricService.deleteMetricsGroup(deletion.serverId);
        case 'metricType':
          await metricService.deleteMetricsType(deletion.serverId);
        case 'eventType':
          await eventService.deleteEventsType(deletion.serverId);
        case 'person':
          await userService.deletePerson(deletion.serverId);
        case 'metricFile':
          final metricId = deletion.relatedId;
          if (metricId == null) {
            throw StateError('Metric file deletion has no related metric ID');
          }
          await fileService.unlinkMetric(
            deletion.serverId,
            metricId,
            await _metricPersonServerId(metricId),
          );
        case 'eventFile':
          final eventId = deletion.relatedId;
          if (eventId == null) {
            throw StateError('Event file deletion has no related event ID');
          }
          await fileService.unlinkEvent(
            deletion.serverId,
            eventId,
            await _eventPersonServerId(eventId),
          );
        default:
          throw StateError('Unknown pending deletion: ${deletion.entity}');
      }

      _ensureSession();
      await (database.delete(
        database.pendingDeletion,
      )..where((row) => row.id.equals(deletion.id))).go();
    }
  }

  Future<void> _markPersonSynced(int id) async {
    await (database.person.update()..where((row) => row.id.equals(id))).write(
      PersonCompanion(
        synced: const Value(true),
        syncTime: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<int> _groupServerId(int id) async {
    final row = await (database.select(
      database.group,
    )..where((group) => group.id.equals(id))).getSingleOrNull();
    return row?.serverId ?? id;
  }

  Future<int> _unitServerId(int id) async {
    final row = await (database.select(
      database.unit,
    )..where((unit) => unit.id.equals(id))).getSingleOrNull();
    return row?.serverId ?? id;
  }

  Future<int> _metricTypeServerId(int id) async {
    final row = await (database.select(
      database.metricType,
    )..where((type) => type.id.equals(id))).getSingleOrNull();
    return row?.serverId ?? id;
  }

  Future<int> _eventTypeServerId(int id) async {
    final row = await (database.select(
      database.eventType,
    )..where((type) => type.id.equals(id))).getSingleOrNull();
    return row?.serverId ?? id;
  }

  Future<int?> _personServerId(int id) async {
    if (id == 0) return null;
    final row = await (database.select(
      database.person,
    )..where((person) => person.id.equals(id))).getSingleOrNull();
    final serverId = row?.serverId;
    if (serverId == null) {
      throw StateError('Person $id must sync before its records');
    }
    return serverId;
  }

  void _ensureSession() {
    if (account.getToken()?.refreshToken.isNotEmpty != true) {
      throw StateError('Authentication ended during offline synchronization');
    }
  }

  Future<int> _metricServerId(int id) async {
    final row = await (database.select(
      database.metric,
    )..where((metric) => metric.id.equals(id))).getSingleOrNull();
    final serverId = row?.serverId;
    if (serverId == null) {
      throw StateError('Metric $id must sync before its file links');
    }
    return serverId;
  }

  Future<int?> _metricPersonServerId(int serverId) async {
    final row = await (database.select(
      database.metric,
    )..where((metric) => metric.serverId.equals(serverId))).getSingleOrNull();
    return row == null ? null : _personServerId(row.person);
  }

  Future<int> _eventServerId(int id) async {
    final row = await (database.select(
      database.event,
    )..where((event) => event.id.equals(id))).getSingleOrNull();
    final serverId = row?.serverId;
    if (serverId == null) {
      throw StateError('Event $id must sync before its file links');
    }
    return serverId;
  }

  Future<int?> _eventPersonServerId(int serverId) async {
    final row = await (database.select(
      database.event,
    )..where((event) => event.serverId.equals(serverId))).getSingleOrNull();
    return row == null ? null : _personServerId(row.person);
  }

  Future<int> _fileServerId(int id) async {
    final row = await (database.select(
      database.file,
    )..where((file) => file.id.equals(id))).getSingleOrNull();
    final serverId = row?.serverId;
    if (serverId == null) {
      throw StateError('File $id must sync before its links');
    }
    return serverId;
  }
}
