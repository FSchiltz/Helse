import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:helse/services/account.dart';
import 'package:helse/ui/common/notification.dart';

import '../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../di/dependencies.dart';

enum MetricTypes {
  none(0),
  heart(1),
  oxygen(2),
  wheight(3),
  height(4),
  temperature(5),
  steps(6),
  calories(7),
  distance(8),
  pain(10),
  mood(11),
  medication(12),
  tests(13),
  sex(14),
  stool(15),
  spotting(16),
  headDiameter(17),
  diaper(18);

  final int? value;

  const MetricTypes(this.value);
}

enum EventTypes {
  none(0),
  sleep(1),
  care(2),
  workout(3),
  bath(4),
  feeding(5);

  final int? value;

  const EventTypes(this.value);
}

class FitLogic {
  Account account;
  FitLogic(this.account);

  // get the data
  final List<HealthDataType> _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.HEIGHT,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.SKIN_TEMPERATURE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_UNKNOWN,
  ];

  final List<HealthDataType> _other = [
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WALKING_HEART_RATE,
    HealthDataType.SLEEP_WRIST_TEMPERATURE,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.DISTANCE_SWIMMING,
    HealthDataType.DISTANCE_CYCLING,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.SLEEP_AWAKE_IN_BED,
  ];

  Future<void> requestPermissions() async {
    var health = Health();
    await health.configure();
    var exisitingTypes = _types
        .where((e) => health.isDataTypeAvailable(e))
        .toList();
    if (await health.hasPermissions(exisitingTypes) != true) {
      bool requested = await health.requestAuthorization(
        exisitingTypes,
        permissions: exisitingTypes.map((e) => HealthDataAccess.READ).toList(),
      );

      if (!requested) {
        throw StateError('Missing permissions');
      }
    }

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

    await Dependencies.logics.settings.setHasHistory(history);
  }

  Future<String?> sync() async {
    // TODO use a background task

    var run = await Dependencies.logics.settings.getLastRun();
    var history = await Dependencies.logics.settings.getHasHistory() ?? false;

    var now = DateTime.now();
    var start = run == null
        ? now.add(
            (history)
                ? const Duration(days: -30 * 12 * 5)
                : const Duration(days: -35),
          )
        : DateTime.parse(run);

    int events = 0;
    int metrics = 0;

    var firstRun = run == null;

    // don't sync of in the future
    if (start.compareTo(now) >= 0) return null;

    var health = Health();
    await health.configure();
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      startTime: start,
      endTime: now,
      types: _types,
    );

    // convert to import data
    ImportData converted = _convert(healthData);

    // import to the server
    // TODO add a loop here if too much events
    if (converted.metrics?.isNotEmpty == true ||
        converted.events?.isNotEmpty == true) {
      await Dependencies.services.import.importData(converted);
    }
    events += converted.events?.length ?? 0;
    metrics += converted.metrics?.length ?? 0;

    await account.set(Account.fitRun, now.toString());

    var text =
        "Sync sucessful with $metrics metrics and $events events since $start";
    if (firstRun || metrics > 0 || events > 0) {
      firstRun = false;
      Notify.show(text);
    }

    return text;
  }

  static Future<bool> isEnabled() async {
    Dependencies.health.configure();

    return isSupported();
  }

  static bool isSupported() {
    return !kIsWeb && Platform.isAndroid;
  }

  ImportData _convert(List<HealthDataPoint> healthData) {
    List<CreateMetric> metrics = [];
    List<CreateEvent> events = [];

    for (var point in healthData) {
      int? metricType;
      int? eventType;
      switch (point.type) {
        case HealthDataType.BLOOD_OXYGEN:
          metricType = MetricTypes.oxygen.value;

        case HealthDataType.WEIGHT:
          metricType = MetricTypes.wheight.value;

        case HealthDataType.STEPS:
          metricType = MetricTypes.steps.value;

        case HealthDataType.RESTING_HEART_RATE:
        case HealthDataType.WALKING_HEART_RATE:
        case HealthDataType.HEART_RATE:
          metricType = MetricTypes.heart.value;

        case HealthDataType.HEIGHT:
          metricType = MetricTypes.height.value;

        case HealthDataType.BODY_TEMPERATURE:
        case HealthDataType.SLEEP_WRIST_TEMPERATURE:
        case HealthDataType.SKIN_TEMPERATURE:
          metricType = MetricTypes.temperature.value;

        case HealthDataType.TOTAL_CALORIES_BURNED:
        case HealthDataType.ACTIVE_ENERGY_BURNED:
        case HealthDataType.BASAL_ENERGY_BURNED:
          metricType = MetricTypes.calories.value;

        case HealthDataType.DISTANCE_WALKING_RUNNING:
        case HealthDataType.DISTANCE_SWIMMING:
        case HealthDataType.DISTANCE_CYCLING:
          metricType = MetricTypes.distance.value;

        case HealthDataType.SLEEP_ASLEEP:
        case HealthDataType.SLEEP_AWAKE_IN_BED:
        case HealthDataType.SLEEP_AWAKE:
        case HealthDataType.SLEEP_DEEP:
        case HealthDataType.SLEEP_IN_BED:
        case HealthDataType.SLEEP_LIGHT:
        case HealthDataType.SLEEP_OUT_OF_BED:
        case HealthDataType.SLEEP_REM:
        case HealthDataType.SLEEP_SESSION:
        case HealthDataType.SLEEP_UNKNOWN:
          eventType = EventTypes.sleep.value;

        default:
          throw Error();
      }

      if (metricType != null) {
        var metric = CreateMetric(
          date: point.dateFrom.toUtc(),
          value: _convertValue(point.value) ?? '',
          source: FileTypes.googlehealthconnect,
          tag: point.typeString,
          type: metricType,
        );
        metrics.add(metric);
      }

      if (eventType != null) {
        var event = CreateEvent(
          start: point.dateFrom.toUtc(),
          stop: point.dateTo.toUtc(),
          description: _convertValue(point.value) ?? '',
          source: FileTypes.googlehealthconnect,
          tag: point.typeString,
          type: eventType,
        );
        events.add(event);
      }
    }
    return ImportData(metrics: metrics, events: events);
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
