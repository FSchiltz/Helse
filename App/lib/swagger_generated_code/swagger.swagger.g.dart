// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
      user: json['user'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
    };

Metric _$MetricFromJson(Map<String, dynamic> json) => Metric(
      id: json['id'] as int?,
      personId: json['personId'] as int?,
      user: json['user'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      value: json['value'] as String?,
      unit: json['unit'] as String?,
      type: json['type'] as int?,
    );

Map<String, dynamic> _$MetricToJson(Metric instance) => <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'user': instance.user,
      'date': instance.date?.toIso8601String(),
      'value': instance.value,
      'unit': instance.unit,
      'type': instance.type,
    };

MetricType _$MetricTypeFromJson(Map<String, dynamic> json) => MetricType(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$MetricTypeToJson(MetricType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'unit': instance.unit,
    };

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      identifier: json['identifier'] as String?,
      birth: json['birth'] == null
          ? null
          : DateTime.parse(json['birth'] as String),
      userName: json['userName'] as String?,
      password: json['password'] as String?,
      type: userTypeFromJson(json['type']),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'identifier': instance.identifier,
      'birth': instance.birth?.toIso8601String(),
      'userName': instance.userName,
      'password': instance.password,
      'type': userTypeToJson(instance.type),
      'email': instance.email,
      'phone': instance.phone,
    };
