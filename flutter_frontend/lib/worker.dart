import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case WorkHelper.jobName:
        return await WorkHelper.syncDataWithServer();
      default:
        // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

class WorkHelper {
  static const String jobName = "data_sync";
  static Future<void> init() async {
    if (!kIsWeb && Platform.isAndroid) {
      Workmanager().initialize(callbackDispatcher);
      var already = await Workmanager().isScheduledByUniqueName(jobName);
      if (!already) {
        Workmanager().registerPeriodicTask(
          jobName,
          jobName,
          frequency: Duration(minutes: 15),
          constraints: Constraints(
            networkType: NetworkType.unmetered,
            requiresBatteryNotLow: true,
          ),
        );
      }
    }
  }

  static Future<bool> syncDataWithServer() async {
    try {
      log("Background sync started");
      await Dependencies.init();
      if (Dependencies.logics.health.isEnabled()) {
        var settings = Dependencies.logics.settings.getHealth();
        if (settings.background) {
          log("Background sync enabled");
          await Dependencies.logics.health.sync();
        }
      }
    } catch (ex) {
      log("Background sync failed with $ex");

      Notify.showBackground(ex.toString(), kind: NotificationKind.error);
      Dependencies.logics.settings.setFitStatus("Error: $ex");
      return false;
    }

    return true;
  }
}
