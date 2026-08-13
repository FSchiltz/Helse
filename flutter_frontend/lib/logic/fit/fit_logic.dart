import 'dart:developer';
import 'package:health/health.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/fit_constants.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/logic/task_bloc.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/swagger/generated_code/helseapi.swagger.dart';

class HealthConnectLogic {
  final SettingsLogic settingsLogic;

  HealthConnectLogic(this.settingsLogic);

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

  Future<Execution> sync() async {
    var run = settingsLogic.getLastRun();
    var history = settingsLogic.getHasHistory() ?? false;
    var settings = settingsLogic.getHealth();
    if (!settings.syncHealth) {
      return Execution.skipped(status: "Not enabled");
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
    if (start.compareTo(now) >= 0) return Execution.skipped();

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
    final result = await Dependencies.services.import.importData(converted);
    if (result != null) {
      Dependencies.logics.import.add(result.id);
    }

    settingsLogic.setFitRun(now.toString());

    if (firstRun) {
      firstRun = false;
    }

    return Execution(DateTime.now(), SubmissionStatus.initial);
  }

  bool isEnabled() {
    final settings = settingsLogic.getHealth();
    return settings.syncHealth;
  }
}
