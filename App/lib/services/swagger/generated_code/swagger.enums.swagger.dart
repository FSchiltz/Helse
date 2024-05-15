import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum FileTypes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(1)
  redmiwatch(1),
  @JsonValue(2)
  googlehealthconnect(2);

  final int? value;

  const FileTypes(this.value);
}

enum MetricDataType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  text(0),
  @JsonValue(1)
  number(1);

  final int? value;

  const MetricDataType(this.value);
}

enum MetricSummary {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  latest(0),
  @JsonValue(1)
  sum(1),
  @JsonValue(2)
  mean(2);

  final int? value;

  const MetricSummary(this.value);
}

enum RightType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(1)
  view(1),
  @JsonValue(2)
  edit(2);

  final int? value;

  const RightType(this.value);
}

enum TreatmentType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  care(0);

  final int? value;

  const TreatmentType(this.value);
}

enum UserType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  patient(0),
  @JsonValue(1)
  admin(1),
  @JsonValue(2)
  caregiver(2),
  @JsonValue(4)
  user(4),
  @JsonValue(6)
  carewithself(6),
  @JsonValue(7)
  superuser(7);

  final int? value;

  const UserType(this.value);
}
