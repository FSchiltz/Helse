import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/task_bloc.dart';
import 'package:helse/services/account.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final List<Execution> _executions = [];
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
    HealthDataType.WORKOUT,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.BASAL_ENERGY_BURNED,
  ];

  final List<HealthDataType> _other = [
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WALKING_HEART_RATE,
    HealthDataType.SLEEP_WRIST_TEMPERATURE,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.SLEEP_AWAKE_IN_BED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.DISTANCE_SWIMMING,
    HealthDataType.DISTANCE_CYCLING,
    HealthDataType.WORKOUT,
    HealthDataType.DISTANCE_DELTA,
  ];

  Future<void> requestPermissions() async {
    var health = Health();
    await health.configure();
    var existingTypes = _types
        .where((e) => health.isDataTypeAvailable(e))
        .toList();

    try {
      await health.requestAuthorization(
        existingTypes,
        permissions: existingTypes.map((e) => HealthDataAccess.READ).toList(),
      );
    } catch (error) {
      Notify.showError(error.toString());
    }

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    await Permission.activityRecognition.request();

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

  Future<void> sync() async {
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
      await account.set(Account.fitStatus, text);
    }
  }

  Future<bool> isEnabled() async {
    Dependencies.health.configure();

    return isSupported();
  }

  bool isSupported() {
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
        case HealthDataType.DISTANCE_DELTA:
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

        case HealthDataType.WORKOUT:
          eventType = EventTypes.workout.value;
            
        case HealthDataType.ATRIAL_FIBRILLATION_BURDEN:
        case HealthDataType.APPLE_STAND_HOUR:
        case HealthDataType.APPLE_MOVE_TIME:
        case HealthDataType.APPLE_STAND_TIME:
        case HealthDataType.AUDIOGRAM:
        case HealthDataType.BLOOD_GLUCOSE:
        case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
        case HealthDataType.BODY_FAT_PERCENTAGE:
        case HealthDataType.LEAN_BODY_MASS:
        case HealthDataType.BODY_MASS_INDEX:
        case HealthDataType.BODY_WATER_MASS:
        case HealthDataType.DIETARY_CARBS_CONSUMED:
        case HealthDataType.DIETARY_CAFFEINE:
        case HealthDataType.DIETARY_ENERGY_CONSUMED:
        case HealthDataType.DIETARY_FATS_CONSUMED:
        case HealthDataType.DIETARY_PROTEIN_CONSUMED:
        case HealthDataType.DIETARY_FIBER:
        case HealthDataType.DIETARY_SUGAR:
        case HealthDataType.DIETARY_FAT_MONOUNSATURATED:
        case HealthDataType.DIETARY_FAT_POLYUNSATURATED:
        case HealthDataType.DIETARY_FAT_SATURATED:
        case HealthDataType.DIETARY_CHOLESTEROL:
        case HealthDataType.DIETARY_VITAMIN_A:
        case HealthDataType.DIETARY_THIAMIN:
        case HealthDataType.DIETARY_RIBOFLAVIN:
        case HealthDataType.DIETARY_NIACIN:
        case HealthDataType.DIETARY_PANTOTHENIC_ACID:
        case HealthDataType.DIETARY_VITAMIN_B6:
        case HealthDataType.DIETARY_BIOTIN:
        case HealthDataType.DIETARY_VITAMIN_B12:
        case HealthDataType.DIETARY_VITAMIN_C:
        case HealthDataType.DIETARY_VITAMIN_D:
        case HealthDataType.DIETARY_VITAMIN_E:
        case HealthDataType.DIETARY_VITAMIN_K:
        case HealthDataType.DIETARY_FOLATE:
        case HealthDataType.DIETARY_CALCIUM:
        case HealthDataType.DIETARY_CHLORIDE:
        case HealthDataType.DIETARY_IRON:
        case HealthDataType.DIETARY_MAGNESIUM:
        case HealthDataType.DIETARY_PHOSPHORUS:
        case HealthDataType.DIETARY_POTASSIUM:
        case HealthDataType.DIETARY_SODIUM:
        case HealthDataType.DIETARY_ZINC:
        case HealthDataType.DIETARY_CHROMIUM:
        case HealthDataType.DIETARY_COPPER:
        case HealthDataType.DIETARY_IODINE:
        case HealthDataType.DIETARY_MANGANESE:
        case HealthDataType.DIETARY_MOLYBDENUM:
        case HealthDataType.DIETARY_SELENIUM:
        case HealthDataType.FORCED_EXPIRATORY_VOLUME:
        case HealthDataType.HEART_RATE_VARIABILITY_SDNN:
        case HealthDataType.HEART_RATE_VARIABILITY_RMSSD:
        case HealthDataType.INSULIN_DELIVERY:
        case HealthDataType.RESPIRATORY_RATE:
        case HealthDataType.PERIPHERAL_PERFUSION_INDEX:
        case HealthDataType.WAIST_CIRCUMFERENCE:
        case HealthDataType.FLIGHTS_CLIMBED:
        case HealthDataType.WALKING_SPEED:
        case HealthDataType.SPEED:
        case HealthDataType.MINDFULNESS:
        case HealthDataType.WATER:
        case HealthDataType.EXERCISE_TIME:
        case HealthDataType.WORKOUT_ROUTE:
        case HealthDataType.HEADACHE_NOT_PRESENT:
        case HealthDataType.HEADACHE_MILD:
        case HealthDataType.HEADACHE_MODERATE:
        case HealthDataType.HEADACHE_SEVERE:
        case HealthDataType.HEADACHE_UNSPECIFIED:
        case HealthDataType.NUTRITION:
        case HealthDataType.UV_INDEX:
        case HealthDataType.GENDER:
        case HealthDataType.BIRTH_DATE:
        case HealthDataType.BLOOD_TYPE:
        case HealthDataType.MENSTRUATION_FLOW:
        case HealthDataType.WATER_TEMPERATURE:
        case HealthDataType.UNDERWATER_DEPTH:
        case HealthDataType.HIGH_HEART_RATE_EVENT:
        case HealthDataType.LOW_HEART_RATE_EVENT:
        case HealthDataType.IRREGULAR_HEART_RATE_EVENT:
        case HealthDataType.ELECTRODERMAL_ACTIVITY:
        case HealthDataType.ELECTROCARDIOGRAM:
        case HealthDataType.ACTIVITY_INTENSITY:
        // do nothing for now
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
          description: point.typeString,
          source: FileTypes.googlehealthconnect,
          tag: _convertValue(point.value) ?? '',
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
        return '${workout.totalDistance}-${workout.totalEnergyBurned}-${workout.totalSteps}';
    }
    return value.toString();
  }

  List<Execution> executions() {
    return _executions;
  }

  Future<String?> checkRun() async {
    var lastrun = await account.get(Account.fitRun);
    if (lastrun != null) {
      var date = DateTime.parse(lastrun);

      if (date.isAfter(_executions.last.date)) {
        var status = await account.get(Account.fitStatus);
        _executions.add(
          Execution(date, SubmissionStatus.success, status: status),
        );
      }
    }

    return null;
  }
}
