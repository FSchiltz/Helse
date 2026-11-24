import 'dart:io' as io;

import 'package:collection/collection.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/metric_validation.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/local/database/database.dart' as local;
import 'package:helse/services/local/local_event_service.dart';
import 'package:helse/services/local/local_file_service.dart';
import 'package:helse/services/local/local_metric_service.dart';
import 'package:helse/services/local/offline_sync_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/events_add.dart';
import 'package:helse/ui/blocs/metrics/metric_add.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:path_provider/path_provider.dart';

class LocalChangeRepairDialog extends StatefulWidget {
  const LocalChangeRepairDialog({super.key});

  @override
  State<LocalChangeRepairDialog> createState() =>
      _LocalChangeRepairDialogState();
}

class _LocalChangeRepairDialogState extends State<LocalChangeRepairDialog> {
  late Future<_RepairData> _repairData;
  final Map<int, int?> _metricTypeIds = {};
  final Map<int, int?> _eventTypeIds = {};

  @override
  void initState() {
    super.initState();
    _repairData = _loadRepairData();
  }

  Future<_RepairData> _loadRepairData() async {
    final account = Dependencies.logics.authentication.account;
    final metricService = LocalMetricService(account);
    final eventService = LocalEventService(account);
    final fileService = LocalFileService(account);
    final database = metricService.database;
    final metricTypes = await metricService.metricsType(true, null) ?? [];
    final eventTypes = await eventService.eventsType(true) ?? [];
    final validMetricTypes = metricTypes
        .where(
          (type) =>
              type.type != null &&
              type.type != MetricDataType.swaggerGeneratedUnknown,
        )
        .toList();

    final metricRows = await (database.select(
      database.metric,
    )..where((row) => row.synced.equals(false))).get();
    final metrics = <_MetricRepair>[];
    for (final row in metricRows) {
      final type = metricTypes
          .where((candidate) => candidate.id == row.type)
          .firstOrNull;
      final issue = validateMetricValue(
        row.value,
        type?.type,
        valueCount: type?.valueCount,
      );
      if (type != null &&
          type.type != MetricDataType.swaggerGeneratedUnknown &&
          issue == null) {
        continue;
      }

      final selectedType =
          validMetricTypes
              .where((candidate) => candidate.id == row.type)
              .firstOrNull ??
          validMetricTypes.firstOrNull;
      _metricTypeIds[row.id] = selectedType?.id;
      metrics.add(
        _MetricRepair(
          row,
          type == null ||
              type.type == null ||
              type.type == MetricDataType.swaggerGeneratedUnknown,
        ),
      );
    }

    final eventRows = await (database.select(
      database.event,
    )..where((row) => row.synced.equals(false))).get();
    final events = <_EventRepair>[];
    for (final row in eventRows) {
      final type = eventTypes
          .where((candidate) => candidate.id == row.type)
          .firstOrNull;
      final invalidDates = row.end.isBefore(row.start);
      final invalidType = type == null;
      if (!invalidDates && !invalidType) continue;

      final selectedType =
          eventTypes
              .where((candidate) => candidate.id == row.type)
              .firstOrNull ??
          eventTypes.firstOrNull;
      _eventTypeIds[row.id] = selectedType?.id;
      events.add(_EventRepair(row, invalidDates, invalidType));
    }

    final files = <local.FileData>[];
    final fileRows = await (database.select(
      database.file,
    )..where((row) => row.synced.equals(false))).get();
    for (final row in fileRows) {
      if (row.content != null) continue;
      if (!kIsWeb) {
        final directory = await getApplicationSupportDirectory();
        final path = '${directory.path}/${LocalFileService.path}/${row.id}';
        if (await io.File(path).exists()) continue;
      }
      files.add(row);
    }

    return _RepairData(
      metrics: metrics,
      metricTypes: validMetricTypes,
      events: events,
      eventTypes: eventTypes,
      files: files,
      fileService: fileService,
    );
  }

  void _reload() {
    setState(() {
      _repairData = _loadRepairData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.repairLocalChanges),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 300, minHeight: 300),
        child: FutureBuilder<_RepairData>(
          future: _repairData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text(locale.error(snapshot.error.toString()));
            }

            final data = snapshot.requireData;
            if (data.metrics.isEmpty &&
                data.events.isEmpty &&
                data.files.isEmpty) {
              return Text(locale.noLocalChangesToRepair);
            }

            return ListView(
              children: [
                if (data.metrics.isNotEmpty) ...[
                  Text(
                    locale.metrics,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final repair in data.metrics)
                    _metricTile(repair, data, locale),
                ],
                if (data.events.isNotEmpty) ...[
                  Text(
                    locale.events,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final repair in data.events)
                    _eventTile(repair, data, locale),
                ],
                if (data.files.isNotEmpty) ...[
                  Text(
                    locale.file,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final file in data.files)
                    ListTile(
                      title: Text('${file.name} (#${file.id})'),
                      subtitle: Text(locale.offlineFileDataMissing),
                      trailing: TextButton(
                        onPressed: () => _replaceFile(file, data.fileService),
                        child: Text(locale.replaceMissingFile),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
      actions: [
        SquareButton(locale.retrySync, () async {
          await OfflineSyncService(
            Dependencies.logics.authentication.account,
          ).syncPendingChanges();
          if (mounted) _reload();
        }),
        SquareButton(locale.cancel, () => Navigator.of(context).pop()),
      ],
    );
  }

  Widget _metricTile(
    _MetricRepair repair,
    _RepairData data,
    AppLocalizations locale,
  ) {
    final types = data.metricTypes;
    final selectedTypeId = _metricTypeIds[repair.row.id];
    final type = types.where((item) => item.id == selectedTypeId).firstOrNull;
    return Card(
      child: ListTile(
        title: Text('${locale.metrics} #${repair.row.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.invalid(repair.invalidType ? locale.type : locale.value),
            ),
            if (types.isNotEmpty)
              DropdownButton<int>(
                value: selectedTypeId,
                items: types
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
                onChanged: (id) => setState(() {
                  _metricTypeIds[repair.row.id] = id;
                }),
              ),
          ],
        ),
        trailing: IconButton(
          tooltip: locale.edit,
          onPressed: type == null ? null : () => _editMetric(repair.row, type),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _eventTile(
    _EventRepair repair,
    _RepairData data,
    AppLocalizations locale,
  ) {
    final types = data.eventTypes;
    final selectedTypeId = _eventTypeIds[repair.row.id];
    final type = types.where((item) => item.id == selectedTypeId).firstOrNull;

    return Card(
      child: ListTile(
        title: Text('${locale.events} #${repair.row.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.invalid(
                repair.invalidType
                    ? locale.type
                    : repair.invalidDates
                    ? locale.end
                    : locale.type,
              ),
            ),
            if (types.isNotEmpty)
              DropdownButton<int>(
                value: selectedTypeId,
                items: types
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
                onChanged: (id) => setState(() {
                  _eventTypeIds[repair.row.id] = id;
                }),
              ),
          ],
        ),
        trailing: IconButton(
          tooltip: locale.edit,
          onPressed: type == null ? null : () => _editEvent(repair.row, type),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Future<void> _editMetric(local.MetricData row, MetricType type) async {
    final source = ImportTypes.values.asNameMap()[row.source];
    await showDialog<void>(
      context: context,
      builder: (context) => MetricAdd(
        type,
        _reload,
        person: row.person == 0 ? null : row.person,
        localRepair: true,
        edit: Metric(
          id: row.id,
          person: row.person,
          date: row.date,
          value: row.value,
          type: row.type,
          tag: row.tag,
          source: source,
          sourceId: row.sourceId,
        ),
      ),
    );
  }

  Future<void> _editEvent(local.EventData row, EventType type) async {
    final source = ImportTypes.values.asNameMap()[row.source];
    await showDialog<void>(
      context: context,
      builder: (context) => EventAdd(
        type,
        _reload,
        person: row.person == 0 ? null : row.person,
        localRepair: true,
        edit: Event(
          id: row.id,
          person: row.person,
          type: row.type,
          description: row.description,
          start: row.start,
          stop: row.end,
          tag: row.tag,
          notificationTime: row.notificationTime,
          source: source,
          sourceId: row.sourceId,
        ),
      ),
    );
  }

  Future<void> _replaceFile(
    local.FileData row,
    LocalFileService service,
  ) async {
    final locale = Translation.of(context);
    try {
      final file = await openFile();
      if (file == null) return;
      await service.postFileData(
        row.id,
        file,
        row.person == 0 ? null : row.person,
      );
      if (mounted) _reload();
    } catch (error, stackTrace) {
      appLogger.e(
        '[OfflineRepair] Failed to replace missing file data',
        error: error,
        stackTrace: stackTrace,
      );
      Notify.show(
        locale.error(error.toString()),
        context: mounted ? context : null,
        kind: NotificationKind.error,
      );
    }
  }
}

class _RepairData {
  final List<_MetricRepair> metrics;
  final List<MetricType> metricTypes;
  final List<_EventRepair> events;
  final List<EventType> eventTypes;
  final List<local.FileData> files;
  final LocalFileService fileService;

  const _RepairData({
    required this.metrics,
    required this.metricTypes,
    required this.events,
    required this.eventTypes,
    required this.files,
    required this.fileService,
  });
}

class _MetricRepair {
  final local.MetricData row;
  final bool invalidType;

  const _MetricRepair(this.row, this.invalidType);
}

class _EventRepair {
  final local.EventData row;
  final bool invalidDates;
  final bool invalidType;

  const _EventRepair(this.row, this.invalidDates, this.invalidType);
}
