import 'package:health/health.dart';

class FitConstants {
  static final List<HealthDataType> types = [
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

  static final List<HealthDataType> unsupported = [
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
}
