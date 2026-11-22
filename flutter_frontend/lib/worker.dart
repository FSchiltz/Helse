import 'package:flutter/foundation.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/logic/event.dart';
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
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
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
      appLogger.d("Background sync started");
      await Dependencies.init();
      if (await Dependencies.logics.authentication.isOffline()) {
        Dependencies.blocs.server.setOffline(userInitiated: true);
      }

      if (Dependencies.logics.health.isEnabled()) {
        var settings = Dependencies.logics.settings.getHealth();
        if (settings.background) {
          appLogger.d("Background sync enabled");
          final result = await Dependencies.logics.health.sync();
          if (result.state == SubmissionStatus.success) {
            Notify.showSystem(
              result.status ?? '',
              kind: NotificationKind.info,
              channel: "Health sync",
            );
          }
        }
      }
    } catch (ex) {
      appLogger.e("Background sync failed", error: ex);

      Notify.showSystem(
        ex.toString(),
        kind: NotificationKind.error,
        channel: "Health sync",
      );
      Dependencies.logics.settings.setFitStatus("Error: $ex");
      return false;
    }

    return true;
  }
}
