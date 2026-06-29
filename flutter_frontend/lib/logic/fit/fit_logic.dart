import 'dart:developer';
import 'dart:math' as math show min, max;

import 'package:health/health.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/fit_constants.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/logic/fit/task_bloc.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/swagger/generated_code/helseapi.swagger.dart';

class HealthConnectLogic {
  final List<Execution> _executions = [];
  final SettingsLogic settingsLogic;
  final ImportService importService;

  HealthConnectLogic(this.settingsLogic, this.importService);

  Future<void> requestPermissions() async {
    var health = Health();
    await health.configure();
    var existingTypes = FitConstants.types
        .where((e) => health.isDataTypeAvailable(e))
        .toList();

    try {
      await health.requestAuthorization(
        existingTypes,
        permissions: existingTypes.map((e) => HealthDataAccess.READ).toList(),
      );
    } catch (error) {
      Notify.show(error.toString(), kind: NotificationKind.error);
    }

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    await Permission.activityRecognition.request();
  }

  Future<void> requestHistoryPermissions() async {
    var health = Health();
    await health.configure();
    bool history = false;
    bool available = await health.isHealthDataHistoryAvailable();
    bool authorized = await health.isHealthDataHistoryAuthorized();
    if (available) {
      if (!authorized) {
        history = await health.requestHealthDataHistoryAuthorization();
      } else {
        history = authorized;
      }
    }

    settingsLogic.setHasHistory(history);
  }

  Future<void> requestBackgroundPermission() async {
    var health = Health();
    await health.configure();
    bool background = false;
    bool backgroundAvailable = await health.isHealthDataInBackgroundAvailable();
    bool isBackground = await health.isHealthDataInBackgroundAuthorized();
    if (backgroundAvailable) {
      if (!isBackground) {
        background = await health.requestHealthDataInBackgroundAuthorization();
      } else {
        background = isBackground;
      }
    }

    settingsLogic.setBackgroundAccess(background);
  }

  Future<String> sync() async {
    var run = settingsLogic.getLastRun();
    var history = settingsLogic.getHasHistory() ?? false;
    var settings = settingsLogic.getHealth();
    if (!settings.syncHealth) {
      return "Not enabled";
    }

    var now = DateTime.now();
    // each sync we have to get the last 5 days because the apps can add metrics in the pasts
    var start = run == null
        ? now.add(
            (history)
                ? const Duration(days: -30 * 12 * 10)
                : const Duration(days: -35),
          )
        : now.add(Duration(days: -5));

    var firstRun = run == null;
    log("Syncing from $start");

    // don't sync if in the future
    if (start.compareTo(now) >= 0) return "";

    var health = Health();
    await health.configure();
    var existingTypes = FitConstants.types
        .where(
          (e) =>
              settings.records[e.name]?.sync == true &&
              health.isDataTypeAvailable(e),
        )
        .toList();

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      startTime: start,
      endTime: now,
      types: existingTypes,
    );

    // convert to import data
    ImportData converted = FitHelper.convert(healthData);

    log(
      "Sending ${converted.metrics?.length} metrics and ${converted.events?.length} events since $start",
    );

    // import to the server
    ImportsResult? result;
    if (converted.metrics?.isNotEmpty == true ||
        converted.events?.isNotEmpty == true) {
      result = await importInChunks(converted);
    }

    settingsLogic.setFitRun(now.toString());
    var metrics = result?.metrics.imported ?? 0;
    var events = result?.events.imported ?? 0;

    var text =
        "Sync sucessful with $metrics metrics and $events events since $start";
    log(text);
    if (firstRun || metrics > 0 || events > 0) {
      firstRun = false;
      settingsLogic.setFitStatus(text);
    }

    _executions.add(
      Execution(DateTime.now(), SubmissionStatus.success, status: text),
    );

    return text;
  }

  List<Execution> executions() {
    return _executions;
  }

  Future<String?> checkRun() async {
    var lastrun = settingsLogic.getLastRun();
    if (lastrun != null) {
      var date = DateTime.parse(lastrun);

      if (_executions.isEmpty || date.isAfter(_executions.last.date)) {
        var status = settingsLogic.getLastStatus();
        _executions.add(
          Execution(date, SubmissionStatus.success, status: status),
        );
      }
    }

    return null;
  }

  bool isEnabled() {
    final settings = settingsLogic.getHealth();
    return settings.syncHealth;
  }

  Future<ImportsResult?> importInChunks(
    ImportData data, {
    int chunkSize = 1000,
  }) async {
    int importedMetrics = 0;
    int importedEvents = 0;

    final metrics = data.metrics ?? [];
    final events = data.events ?? [];

    final maxLength = math.max(metrics.length, events.length);

    for (var start = 0; start < maxLength; start += chunkSize) {
      final metricChunk = start < metrics.length
          ? metrics.sublist(start, math.min(start + chunkSize, metrics.length))
          : <CreateMetric>[];

      final eventChunk = start < events.length
          ? events.sublist(start, math.min(start + chunkSize, events.length))
          : <CreateEvent>[];

      final result = await importService.importData(
        ImportData(metrics: metricChunk, events: eventChunk),
      );

      importedMetrics += result?.metrics.imported ?? 0;
      importedEvents += result?.events.imported ?? 0;
    }

    return ImportsResult(
      metrics: ImportResult(imported: importedMetrics, skipped: 0, failed: 0),
      events: ImportResult(imported: importedEvents, skipped: 0, failed: 0),
    );
  }
}
