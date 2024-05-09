import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:helse/services/account.dart';
import 'package:permission_handler/permission_handler.dart';

import '../d_i.dart';

class FitLogic {
  static int fitValue = 2;

  Account account;
  FitLogic(this.account);

  Future<void> sync() async {
    // TODO use a background task

    // Get the last run
    var run = await account.get(Account.fitRun);
    var runDate = run == null ? null : DateTime.parse(run);

    var start = runDate ?? DateTime(2007);

    var now = DateTime.now();
    if (start.compareTo(now) >= 0) return;

    // get the data
    bool requested = await Health().requestAuthorization(dataTypeKeysAndroid);
    if (!requested) {
      throw Exception('Missing permissions');
    }

    while (start.compareTo(now) < 0) {
      var end = start.add(const Duration(days: 30));

      // fetch health data from the last 24 hours
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(startTime: start, endTime: end, types: dataTypeKeysAndroid);

      // convert to import data

      // import to the server
      //DI.helper.import(healthData, fitValue);

      start = end;
      await account.set(Account.fitRun, start.toString());
    }

    await Future.delayed(const Duration(seconds: 2), () {});
  }

  static Future<bool> isEnabled() async {
    // ask the permission if needed
    await Permission.activityRecognition.request();
    // configure the health plugin before use.
    DI.health.configure(useHealthConnectIfAvailable: true);

    return isSupported();
  }

  static bool isSupported() {
    return !kIsWeb && Platform.isAndroid;
  }
}
