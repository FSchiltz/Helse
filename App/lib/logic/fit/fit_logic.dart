import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/account.dart';
import 'package:helse/ui/theme/notification.dart';

import '../../services/swagger/generated_code/swagger.swagger.dart';
import '../d_i.dart';

enum MetricTypes {
  none(0),
  heart(1),
  oxygen(2),
  wheight(3),
  height(4),
  temperature(5),
  steps(6),
  calories(7),
  distance(8);

  final int? value;

  const MetricTypes(this.value);
}

class FitLogic {
  Account account;
  FitLogic(this.account);

  Future<String?> sync() async {
    // TODO use a background task

    // Get the last run
    var run = await SettingsLogic.getLastRun();

    var now = DateTime.now();
    var start = run == null ? now.add(const Duration(days: -35)) : DateTime.parse(run);

    int events = 0;
    int metrics = 0;

    var firstRun = run == null;

    // don't sync of in the future
    if (start.compareTo(now) >= 0) return null;

    var difference = now.difference(start);
    // Don't sync if less than 5 sec since last
    if (difference <= const Duration(seconds: 5)) return null;

    // get the data
    var types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.WEIGHT,
      HealthDataType.STEPS,
    ];

    bool requested = await Health().requestAuthorization(types);
    if (!requested) {
      throw Exception('Missing permissions');
    }

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(startTime: start, endTime: now, types: types);

    // convert to import data
    ImportData converted = _convert(healthData);

    // import to the server
    // TODO add a loop here if too much events
    if (converted.metrics?.isNotEmpty == true || converted.events?.isNotEmpty == true) {
      DI.helper.importData(converted);
    }
    events += converted.events?.length ?? 0;
    metrics += converted.metrics?.length ?? 0;

    await account.set(Account.fitRun, now.toString());

    var text = "Sync sucessful with $metrics metrics and $events events of interval $difference";
    if (firstRun || metrics > 0 || events > 0) {
      firstRun = false;
      Notify.show(text);
    }

    return text;
  }

  static Future<bool> isEnabled() async {
    DI.health.configure(useHealthConnectIfAvailable: true);

    return isSupported();
  }

  static bool isSupported() {
    return !kIsWeb && Platform.isAndroid;
  }

  ImportData _convert(List<HealthDataPoint> healthData) {
    List<CreateMetric> metrics = [];

    for (var point in healthData) {
      int? type;
      switch (point.type) {
        case HealthDataType.BLOOD_OXYGEN:
          type = MetricTypes.oxygen.value;
        case HealthDataType.WEIGHT:
          type = MetricTypes.wheight.value;
        case HealthDataType.STEPS:
          type = MetricTypes.steps.value;
        case HealthDataType.HEART_RATE:
          type = MetricTypes.heart.value;
        default:
          break;
      }

      if (type != null) {
        var metric = CreateMetric(
          date: point.dateFrom.toUtc(),
          $value: _convertValue(point.value),
          source: FileTypes.googlehealthconnect,
          tag: '${point.typeString}:${point.dateFrom}',
          type: type,
        );
        metrics.add(metric);
      }
    }
    return ImportData(metrics: metrics);
  }

  String? _convertValue(HealthValue value) {
    switch (value) {
      case NumericHealthValue numeric:
        return numeric.numericValue.toString();
      case NutritionHealthValue nutrition:
        return nutrition.calories.toString();
      case WorkoutHealthValue workout:
        return workout.totalDistance.toString();
    }
    return value.toString();
  }

  DateTime _min(DateTime add, DateTime now) {
    if (add.compareTo(now) >= 0) return now;

    return add;
  }
}
