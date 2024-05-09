import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:helse/services/account.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> sync() async {
    // TODO use a background task

    // Get the last run
    var run = await account.get(Account.fitRun);
    var runDate = run == null ? null : DateTime.parse(run);

    var start = runDate ?? DateTime.now().add(const Duration(days: -60));

    var now = DateTime.now();
    if (start.compareTo(now) >= 0) return;

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

    while (start.compareTo(now) < 0) {
      var end = start.add(const Duration(days: 1));

      // fetch health data from the last 24 hours
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(startTime: start, endTime: end, types: types);

      // convert to import data
      ImportData converted = _convert(healthData);

      // import to the server
      if (converted.metrics?.isNotEmpty == true || converted.events?.isNotEmpty == true) {
        DI.helper.importData(converted);
      }

      start = end;
      await account.set(Account.fitRun, start.toString());
    }
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
}
