// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
      user: json['user'] as String?,
      password: json['password'] as String?,
      redirect: json['redirect'] as String?,
    );

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'redirect': instance.redirect,
    };

CreateEvent _$CreateEventFromJson(Map<String, dynamic> json) => CreateEvent(
      type: (json['type'] as num?)?.toInt(),
      description: json['description'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      stop:
          json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$CreateEventToJson(CreateEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'tag': instance.tag,
    };

CreateMetric _$CreateMetricFromJson(Map<String, dynamic> json) => CreateMetric(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      $value: json['value'] as String?,
      tag: json['tag'] as String?,
      type: (json['type'] as num?)?.toInt(),
      source: fileTypesNullableFromJson(json['source']),
    );

Map<String, dynamic> _$CreateMetricToJson(CreateMetric instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'value': instance.$value,
      'tag': instance.tag,
      'type': instance.type,
      'source': fileTypesNullableToJson(instance.source),
    };

CreateTreatment _$CreateTreatmentFromJson(Map<String, dynamic> json) =>
    CreateTreatment(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => CreateEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      personId: (json['personId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateTreatmentToJson(CreateTreatment instance) =>
    <String, dynamic>{
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'personId': instance.personId,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      type: (json['type'] as num?)?.toInt(),
      description: json['description'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      stop:
          json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
      tag: json['tag'] as String?,
      user: (json['user'] as num?)?.toInt(),
      file: (json['file'] as num?)?.toInt(),
      treatment: (json['treatment'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      person: (json['person'] as num?)?.toInt(),
      valid: json['valid'] as bool?,
      address: (json['address'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'tag': instance.tag,
      'user': instance.user,
      'file': instance.file,
      'treatment': instance.treatment,
      'id': instance.id,
      'person': instance.person,
      'valid': instance.valid,
      'address': instance.address,
    };

EventType _$EventTypeFromJson(Map<String, dynamic> json) => EventType(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      standAlone: json['standAlone'] as bool?,
      userEditable: json['userEditable'] as bool?,
      visible: json['visible'] as bool?,
    );

Map<String, dynamic> _$EventTypeToJson(EventType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'standAlone': instance.standAlone,
      'userEditable': instance.userEditable,
      'visible': instance.visible,
    };

FileType _$FileTypeFromJson(Map<String, dynamic> json) => FileType(
      type: (json['type'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$FileTypeToJson(FileType instance) => <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
    };

ImportData _$ImportDataFromJson(Map<String, dynamic> json) => ImportData(
      metrics: (json['metrics'] as List<dynamic>?)
              ?.map((e) => CreateMetric.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => CreateEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ImportDataToJson(ImportData instance) =>
    <String, dynamic>{
      'metrics': instance.metrics?.map((e) => e.toJson()).toList(),
      'events': instance.events?.map((e) => e.toJson()).toList(),
    };

Metric _$MetricFromJson(Map<String, dynamic> json) => Metric(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      $value: json['value'] as String?,
      tag: json['tag'] as String?,
      type: (json['type'] as num?)?.toInt(),
      source: fileTypesNullableFromJson(json['source']),
      id: (json['id'] as num?)?.toInt(),
      person: (json['person'] as num?)?.toInt(),
      user: (json['user'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetricToJson(Metric instance) => <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'value': instance.$value,
      'tag': instance.tag,
      'type': instance.type,
      'source': fileTypesNullableToJson(instance.source),
      'id': instance.id,
      'person': instance.person,
      'user': instance.user,
    };

MetricType _$MetricTypeFromJson(Map<String, dynamic> json) => MetricType(
      name: json['name'] as String?,
      unit: json['unit'] as String?,
      summaryType: metricSummaryNullableFromJson(json['summaryType']),
      description: json['description'] as String?,
      type: metricDataTypeNullableFromJson(json['type']),
      id: (json['id'] as num?)?.toInt(),
      userEditable: json['userEditable'] as bool?,
      visible: json['visible'] as bool?,
    );

Map<String, dynamic> _$MetricTypeToJson(MetricType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'unit': instance.unit,
      'summaryType': metricSummaryNullableToJson(instance.summaryType),
      'description': instance.description,
      'type': metricDataTypeNullableToJson(instance.type),
      'id': instance.id,
      'userEditable': instance.userEditable,
      'visible': instance.visible,
    };

Oauth _$OauthFromJson(Map<String, dynamic> json) => Oauth(
      enabled: json['enabled'] as bool?,
      autoRegister: json['autoRegister'] as bool?,
      autoLogin: json['autoLogin'] as bool?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      url: json['url'] as String?,
      tokenurl: json['tokenurl'] as String?,
    );

Map<String, dynamic> _$OauthToJson(Oauth instance) => <String, dynamic>{
      'enabled': instance.enabled,
      'autoRegister': instance.autoRegister,
      'autoLogin': instance.autoLogin,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'url': instance.url,
      'tokenurl': instance.tokenurl,
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
      id: (json['id'] as num?)?.toInt(),
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

Proxy _$ProxyFromJson(Map<String, dynamic> json) => Proxy(
      proxyAuth: json['proxyAuth'] as bool?,
      autoRegister: json['autoRegister'] as bool?,
      header: json['header'] as String?,
    );

Map<String, dynamic> _$ProxyToJson(Proxy instance) => <String, dynamic>{
      'proxyAuth': instance.proxyAuth,
      'autoRegister': instance.autoRegister,
      'header': instance.header,
    };

Right _$RightFromJson(Map<String, dynamic> json) => Right(
      personId: (json['personId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
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
      externalAuth: json['externalAuth'] as bool?,
      error: json['error'] as String?,
      oauth: json['oauth'] as String?,
      oauthId: json['oauthId'] as String?,
      autoLogin: json['autoLogin'] as bool?,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'init': instance.init,
      'externalAuth': instance.externalAuth,
      'error': instance.error,
      'oauth': instance.oauth,
      'oauthId': instance.oauthId,
      'autoLogin': instance.autoLogin,
    };

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

Treatement _$TreatementFromJson(Map<String, dynamic> json) => Treatement(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      type: treatmentTypeNullableFromJson(json['type']),
    );

Map<String, dynamic> _$TreatementToJson(Treatement instance) =>
    <String, dynamic>{
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'type': treatmentTypeNullableToJson(instance.type),
    };
