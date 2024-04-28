import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

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
  user(1),
  @JsonValue(2)
  admin(2),
  @JsonValue(3)
  caregiver(3);

  final int? value;

  const UserType(this.value);
}
