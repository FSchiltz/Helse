import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum UserType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(1)
  user(1),
  @JsonValue(2)
  admin(2),
  @JsonValue(3)
  caregiver(3);

  final int? value;

  const UserType(this.value);
}
