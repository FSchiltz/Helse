import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum UserType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const UserType(this.value);
}
