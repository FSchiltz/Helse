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

CreateEvent _$CreateEventFromJson(Map<String, dynamic> json) => CreateEvent(
      type: json['type'] as int?,
      description: json['description'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      stop:
          json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
    );

Map<String, dynamic> _$CreateEventToJson(CreateEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
    };

CreateMetric _$CreateMetricFromJson(Map<String, dynamic> json) => CreateMetric(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      value: json['value'] as String?,
      tag: json['tag'] as String?,
      type: json['type'] as int?,
    );

Map<String, dynamic> _$CreateMetricToJson(CreateMetric instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
      'type': instance.type,
    };

CreateTreatment _$CreateTreatmentFromJson(Map<String, dynamic> json) =>
    CreateTreatment(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => CreateEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      personId: json['personId'] as int?,
    );

Map<String, dynamic> _$CreateTreatmentToJson(CreateTreatment instance) =>
    <String, dynamic>{
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'personId': instance.personId,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      type: json['type'] as int?,
      description: json['description'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      stop:
          json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
      user: json['user'] as int?,
      file: json['file'] as int?,
      treatment: json['treatment'] as int?,
      id: json['id'] as int?,
      person: json['person'] as int?,
      valid: json['valid'] as bool?,
      address: json['address'] as int?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'user': instance.user,
      'file': instance.file,
      'treatment': instance.treatment,
      'id': instance.id,
      'person': instance.person,
      'valid': instance.valid,
      'address': instance.address,
    };

EventType _$EventTypeFromJson(Map<String, dynamic> json) => EventType(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      standAlone: json['standAlone'] as bool?,
    );

Map<String, dynamic> _$EventTypeToJson(EventType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'standAlone': instance.standAlone,
    };

FileType _$FileTypeFromJson(Map<String, dynamic> json) => FileType(
      type: json['type'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$FileTypeToJson(FileType instance) => <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
    };

Metric _$MetricFromJson(Map<String, dynamic> json) => Metric(
      id: json['id'] as int?,
      person: json['person'] as int?,
      user: json['user'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      value: json['value'] as String?,
      tag: json['tag'] as String?,
      type: json['type'] as int?,
    );

Map<String, dynamic> _$MetricToJson(Metric instance) => <String, dynamic>{
      'id': instance.id,
      'person': instance.person,
      'user': instance.user,
      'date': instance.date?.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
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
      type: userTypeNullableFromJson(json['type']),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      rights: (json['rights'] as List<dynamic>?)
              ?.map((e) => Right.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      id: json['id'] as int?,
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'identifier': instance.identifier,
      'birth': instance.birth?.toIso8601String(),
      'userName': instance.userName,
      'password': instance.password,
      'type': userTypeNullableToJson(instance.type),
      'email': instance.email,
      'phone': instance.phone,
      'rights': instance.rights?.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };

PersonCreation _$PersonCreationFromJson(Map<String, dynamic> json) =>
    PersonCreation(
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      identifier: json['identifier'] as String?,
      birth: json['birth'] == null
          ? null
          : DateTime.parse(json['birth'] as String),
      userName: json['userName'] as String?,
      password: json['password'] as String?,
      type: userTypeNullableFromJson(json['type']),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      rights: (json['rights'] as List<dynamic>?)
              ?.map((e) => Right.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PersonCreationToJson(PersonCreation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'identifier': instance.identifier,
      'birth': instance.birth?.toIso8601String(),
      'userName': instance.userName,
      'password': instance.password,
      'type': userTypeNullableToJson(instance.type),
      'email': instance.email,
      'phone': instance.phone,
      'rights': instance.rights?.map((e) => e.toJson()).toList(),
    };

Right _$RightFromJson(Map<String, dynamic> json) => Right(
      personId: json['personId'] as int?,
      userId: json['userId'] as int?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      stop:
          json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
      type: rightTypeNullableFromJson(json['type']),
    );

Map<String, dynamic> _$RightToJson(Right instance) => <String, dynamic>{
      'personId': instance.personId,
      'userId': instance.userId,
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'type': rightTypeNullableToJson(instance.type),
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      init: json['init'] as bool?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'init': instance.init,
      'error': instance.error,
    };

Treatement _$TreatementFromJson(Map<String, dynamic> json) => Treatement(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TreatementToJson(Treatement instance) =>
    <String, dynamic>{
      'events': instance.events?.map((e) => e.toJson()).toList(),
    };
