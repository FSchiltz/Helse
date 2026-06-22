import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:helse/helpers/string_helper.dart';
import 'package:helse/logic/fit/event_types.dart';
import 'package:helse/logic/fit/metric_types.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class FitHelper {
  static bool isSupported() {
    return !kIsWeb && Platform.isAndroid;
  }

  static ImportData convert(List<HealthDataPoint> healthData) {
    List<CreateMetric> metrics = [];
    List<CreateEvent> events = [];

    for (var point in healthData) {
      int? metricType;
      int? eventType;
      String? description;
      switch (point.type) {
        case HealthDataType.BLOOD_OXYGEN:
          metricType = MetricTypes.oxygen.value;

        case HealthDataType.WEIGHT:
          metricType = MetricTypes.weight.value;

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
          description = point.typeString.split('_').skip(1).toCamel();

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

      // the uuid is not unique because some events have subevents
      if (metricType != null) {
        var metric = CreateMetric(
          date: point.dateFrom.toUtc(),
          value: _convertValue(point.value) ?? '',
          source: FileTypes.googlehealthconnect,
          tag: point.recordingMethod.name,
          type: metricType,
          sourceId: '${point.uuid}_${point.dateFrom}',
        );
        metrics.add(metric);
      }

      if (eventType != null) {
        var event = CreateEvent(
          start: point.dateFrom.toUtc(),
          stop: point.dateTo.toUtc(),
          description: description ?? point.typeString.split('_').toCamel(),
          source: FileTypes.googlehealthconnect,
          sourceId: '${point.uuid}_${point.type.name}_${point.dateFrom}',
          tag: point.recordingMethod.name,
          type: eventType,
        );
        events.add(event);
      }
    }
    return ImportData(metrics: metrics, events: events);
  }

  static String? _convertValue(HealthValue value) {
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
}
