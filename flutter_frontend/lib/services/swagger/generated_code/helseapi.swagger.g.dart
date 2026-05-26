// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helseapi.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
  user: json['user'] as String,
  password: json['password'] as String,
  issuer: json['issuer'] as String?,
  redirect: json['redirect'] as String?,
);

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'issuer': instance.issuer,
      'redirect': instance.redirect,
    };

CountByDate _$CountByDateFromJson(Map<String, dynamic> json) => CountByDate(
  date: DateTime.parse(json['date'] as String),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$CountByDateToJson(CountByDate instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'count': instance.count,
    };

CountRecord _$CountRecordFromJson(Map<String, dynamic> json) => CountRecord(
  id: json['id'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$CountRecordToJson(CountRecord instance) =>
    <String, dynamic>{'id': instance.id, 'count': instance.count};

CreateEvent _$CreateEventFromJson(Map<String, dynamic> json) => CreateEvent(
  type: (json['type'] as num?)?.toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
);

Map<String, dynamic> _$CreateEventToJson(CreateEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'stop': instance.stop.toIso8601String(),
      'tag': instance.tag,
      'notificationTime': instance.notificationTime?.toIso8601String(),
    };

CreateMetric _$CreateMetricFromJson(Map<String, dynamic> json) => CreateMetric(
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num?)?.toInt(),
  source: fileTypesNullableFromJson(json['source']),
);

Map<String, dynamic> _$CreateMetricToJson(CreateMetric instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
      'type': instance.type,
      'source': fileTypesNullableToJson(instance.source),
    };

CreateTreatment _$CreateTreatmentFromJson(Map<String, dynamic> json) =>
    CreateTreatment(
      events:
          (json['events'] as List<dynamic>?)
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
  user: (json['user'] as num?)?.toInt(),
  file: (json['file'] as num?)?.toInt(),
  treatment: (json['treatment'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  person: (json['person'] as num?)?.toInt(),
  valid: json['valid'] as bool?,
  address: (json['address'] as num?)?.toInt(),
  type: (json['type'] as num?)?.toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'user': instance.user,
  'file': instance.file,
  'treatment': instance.treatment,
  'id': instance.id,
  'person': instance.person,
  'valid': instance.valid,
  'address': instance.address,
  'type': instance.type,
  'description': instance.description,
  'start': instance.start.toIso8601String(),
  'stop': instance.stop.toIso8601String(),
  'tag': instance.tag,
  'notificationTime': instance.notificationTime?.toIso8601String(),
};

EventStats _$EventStatsFromJson(Map<String, dynamic> json) => EventStats(
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => CountByDate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  eventCounts:
      (json['eventCounts'] as List<dynamic>?)
          ?.map((e) => CountRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$EventStatsToJson(EventStats instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
      'eventCounts': instance.eventCounts.map((e) => e.toJson()).toList(),
    };

EventSummary _$EventSummaryFromJson(Map<String, dynamic> json) =>
    EventSummary(data: json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$EventSummaryToJson(EventSummary instance) =>
    <String, dynamic>{'data': instance.data};

EventType _$EventTypeFromJson(Map<String, dynamic> json) => EventType(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
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
  type: (json['type'] as num).toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$FileTypeToJson(FileType instance) => <String, dynamic>{
  'type': instance.type,
  'name': instance.name,
};

Gotify _$GotifyFromJson(Map<String, dynamic> json) => Gotify(
  enabled: json['enabled'] as bool?,
  url: json['url'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$GotifyToJson(Gotify instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'url': instance.url,
  'token': instance.token,
};

ImportData _$ImportDataFromJson(Map<String, dynamic> json) => ImportData(
  metrics:
      (json['metrics'] as List<dynamic>?)
          ?.map((e) => CreateMetric.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  events:
      (json['events'] as List<dynamic>?)
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
  id: (json['id'] as num).toInt(),
  person: (json['person'] as num).toInt(),
  user: (json['user'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num?)?.toInt(),
  source: fileTypesNullableFromJson(json['source']),
);

Map<String, dynamic> _$MetricToJson(Metric instance) => <String, dynamic>{
  'id': instance.id,
  'person': instance.person,
  'user': instance.user,
  'date': instance.date.toIso8601String(),
  'value': instance.value,
  'tag': instance.tag,
  'type': instance.type,
  'source': fileTypesNullableToJson(instance.source),
};

MetricGroup _$MetricGroupFromJson(Map<String, dynamic> json) => MetricGroup(
  name: json['name'] as String,
  description: json['description'] as String,
  showOnDashboard: json['showOnDashboard'] as bool?,
  showTitle: json['showTitle'] as bool?,
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$MetricGroupToJson(MetricGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'showOnDashboard': instance.showOnDashboard,
      'showTitle': instance.showTitle,
      'id': instance.id,
    };

MetricType _$MetricTypeFromJson(Map<String, dynamic> json) => MetricType(
  name: json['name'] as String,
  unit: json['unit'] as String?,
  summaryType: metricSummaryNullableFromJson(json['summaryType']),
  description: json['description'] as String?,
  type: metricDataTypeNullableFromJson(json['type']),
  id: (json['id'] as num?)?.toInt(),
  userEditable: json['userEditable'] as bool?,
  visible: json['visible'] as bool?,
  showOnDashboard: json['showOnDashboard'] as bool?,
  groupId: (json['groupId'] as num?)?.toInt(),
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
      'showOnDashboard': instance.showOnDashboard,
      'groupId': instance.groupId,
    };

Oauth _$OauthFromJson(Map<String, dynamic> json) => Oauth(
  enabled: json['enabled'] as bool?,
  providers:
      (json['providers'] as List<dynamic>?)
          ?.map((e) => OauthProvider.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$OauthToJson(Oauth instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'providers': instance.providers?.map((e) => e.toJson()).toList(),
};

OauthConnection _$OauthConnectionFromJson(Map<String, dynamic> json) =>
    OauthConnection(
      name: json['name'] as String,
      url: json['url'] as String,
      clientId: json['clientId'] as String,
      autoLogin: json['autoLogin'] as bool,
    );

Map<String, dynamic> _$OauthConnectionToJson(OauthConnection instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'clientId': instance.clientId,
      'autoLogin': instance.autoLogin,
    };

OauthProvider _$OauthProviderFromJson(Map<String, dynamic> json) =>
    OauthProvider(
      name: json['name'] as String,
      autoRegister: json['autoRegister'] as bool?,
      autoLogin: json['autoLogin'] as bool?,
      clientId: json['clientId'] as String,
      clientSecret: json['clientSecret'] as String,
      url: json['url'] as String,
      tokenurl: json['tokenurl'] as String,
      claimsUrl: json['claimsUrl'] as String,
    );

Map<String, dynamic> _$OauthProviderToJson(OauthProvider instance) =>
    <String, dynamic>{
      'name': instance.name,
      'autoRegister': instance.autoRegister,
      'autoLogin': instance.autoLogin,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'url': instance.url,
      'tokenurl': instance.tokenurl,
      'claimsUrl': instance.claimsUrl,
    };

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  id: (json['id'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  rights:
      (json['rights'] as List<dynamic>?)
          ?.map((e) => Right.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  types: userTypeListFromJson(json['types'] as List?),
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  identifier: json['identifier'] as String?,
  birth: json['birth'] == null ? null : DateTime.parse(json['birth'] as String),
  profilePicture: json['profilePicture'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'rights': instance.rights?.map((e) => e.toJson()).toList(),
  'types': userTypeListToJson(instance.types),
  'created': instance.created?.toIso8601String(),
  'name': instance.name,
  'surname': instance.surname,
  'identifier': instance.identifier,
  'birth': instance.birth?.toIso8601String(),
  'profilePicture': instance.profilePicture,
  'email': instance.email,
  'phone': instance.phone,
};

PersonCreation _$PersonCreationFromJson(Map<String, dynamic> json) =>
    PersonCreation(
      userName: json['userName'] as String?,
      password: json['password'] as String?,
      types: userTypeListFromJson(json['types'] as List?),
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      identifier: json['identifier'] as String?,
      birth: json['birth'] == null
          ? null
          : DateTime.parse(json['birth'] as String),
      profilePicture: json['profilePicture'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$PersonCreationToJson(PersonCreation instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'types': userTypeListToJson(instance.types),
      'name': instance.name,
      'surname': instance.surname,
      'identifier': instance.identifier,
      'birth': instance.birth?.toIso8601String(),
      'profilePicture': instance.profilePicture,
      'email': instance.email,
      'phone': instance.phone,
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
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
  type: rightTypeNullableFromJson(json['type']),
);

Map<String, dynamic> _$RightToJson(Right instance) => <String, dynamic>{
  'personId': instance.personId,
  'userId': instance.userId,
  'start': instance.start?.toIso8601String(),
  'stop': instance.stop?.toIso8601String(),
  'type': rightTypeNullableToJson(instance.type),
};

Smtp _$SmtpFromJson(Map<String, dynamic> json) => Smtp(
  enabled: json['enabled'] as bool?,
  smtpHost: json['smtpHost'] as String?,
  smtpPort: (json['smtpPort'] as num?)?.toInt(),
  enableSsl: json['enableSsl'] as bool?,
  fromEmail: json['fromEmail'] as String?,
  userName: json['userName'] as String?,
  password: json['password'] as String?,
);

Map<String, dynamic> _$SmtpToJson(Smtp instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'smtpHost': instance.smtpHost,
  'smtpPort': instance.smtpPort,
  'enableSsl': instance.enableSsl,
  'fromEmail': instance.fromEmail,
  'userName': instance.userName,
  'password': instance.password,
};

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
  init: json['init'] as bool,
  externalAuth: json['externalAuth'] as bool,
  error: json['error'] as String?,
  oauths:
      (json['oauths'] as List<dynamic>?)
          ?.map((e) => OauthConnection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
  'init': instance.init,
  'externalAuth': instance.externalAuth,
  'error': instance.error,
  'oauths': instance.oauths.map((e) => e.toJson()).toList(),
};

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

Treatment _$TreatmentFromJson(Map<String, dynamic> json) => Treatment(
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  type: treatmentTypeNullableFromJson(json['type']),
);

Map<String, dynamic> _$TreatmentToJson(Treatment instance) => <String, dynamic>{
  'events': instance.events?.map((e) => e.toJson()).toList(),
  'type': treatmentTypeNullableToJson(instance.type),
};

UpdateEvent _$UpdateEventFromJson(Map<String, dynamic> json) => UpdateEvent(
  id: (json['id'] as num?)?.toInt(),
  type: (json['type'] as num?)?.toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
);

Map<String, dynamic> _$UpdateEventToJson(UpdateEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'stop': instance.stop.toIso8601String(),
      'tag': instance.tag,
      'notificationTime': instance.notificationTime?.toIso8601String(),
    };

UpdateMetric _$UpdateMetricFromJson(Map<String, dynamic> json) => UpdateMetric(
  id: (json['id'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num?)?.toInt(),
  source: fileTypesNullableFromJson(json['source']),
);

Map<String, dynamic> _$UpdateMetricToJson(UpdateMetric instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
      'type': instance.type,
      'source': fileTypesNullableToJson(instance.source),
    };

UpdatePatient _$UpdatePatientFromJson(Map<String, dynamic> json) =>
    UpdatePatient(
      id: (json['id'] as num?)?.toInt(),
      birth: json['birth'] == null
          ? null
          : DateTime.parse(json['birth'] as String),
      profilePicture: json['profilePicture'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      identifier: json['identifier'] as String?,
    );

Map<String, dynamic> _$UpdatePatientToJson(UpdatePatient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'birth': instance.birth?.toIso8601String(),
      'profilePicture': instance.profilePicture,
      'name': instance.name,
      'surname': instance.surname,
      'identifier': instance.identifier,
    };

UpdatePerson _$UpdatePersonFromJson(Map<String, dynamic> json) => UpdatePerson(
  id: (json['id'] as num?)?.toInt(),
  types: userTypeListFromJson(json['types'] as List?),
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  identifier: json['identifier'] as String?,
  birth: json['birth'] == null ? null : DateTime.parse(json['birth'] as String),
  profilePicture: json['profilePicture'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$UpdatePersonToJson(UpdatePerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'types': userTypeListToJson(instance.types),
      'name': instance.name,
      'surname': instance.surname,
      'identifier': instance.identifier,
      'birth': instance.birth?.toIso8601String(),
      'profilePicture': instance.profilePicture,
      'email': instance.email,
      'phone': instance.phone,
    };

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
  userCount:
      (json['userCount'] as List<dynamic>?)
          ?.map((e) => CountRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
  'userCount': instance.userCount.map((e) => e.toJson()).toList(),
};

ApiImportTypePost$RequestBody _$ApiImportTypePost$RequestBodyFromJson(
  Map<String, dynamic> json,
) => ApiImportTypePost$RequestBody(file: json['file'] as String);

Map<String, dynamic> _$ApiImportTypePost$RequestBodyToJson(
  ApiImportTypePost$RequestBody instance,
) => <String, dynamic>{'file': instance.file};
