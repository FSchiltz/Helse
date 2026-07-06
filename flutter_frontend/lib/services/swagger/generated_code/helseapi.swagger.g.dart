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

ConnectionResponse _$ConnectionResponseFromJson(Map<String, dynamic> json) =>
    ConnectionResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      roles: userTypeListFromJson(json['roles'] as List?),
    );

Map<String, dynamic> _$ConnectionResponseToJson(ConnectionResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'roles': userTypeListToJson(instance.roles),
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
  type: (json['type'] as num).toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String?,
);

Map<String, dynamic> _$CreateEventToJson(CreateEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'stop': instance.stop.toIso8601String(),
      'tag': instance.tag,
      'notificationTime': instance.notificationTime?.toIso8601String(),
      'source': importTypesNullableToJson(instance.source),
      'sourceId': instance.sourceId,
    };

CreateEventType _$CreateEventTypeFromJson(Map<String, dynamic> json) =>
    CreateEventType(
      name: json['name'] as String,
      description: json['description'] as String?,
      standAlone: json['standAlone'] as bool?,
      visible: json['visible'] as bool?,
      timeDifference: json['timeDifference'] as String?,
      groupId: (json['groupId'] as num).toInt(),
    );

Map<String, dynamic> _$CreateEventTypeToJson(CreateEventType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'standAlone': instance.standAlone,
      'visible': instance.visible,
      'timeDifference': instance.timeDifference,
      'groupId': instance.groupId,
    };

CreateFile _$CreateFileFromJson(Map<String, dynamic> json) => CreateFile(
  dataType: json['dataType'] as String,
  type: fileTypeNullableFromJson(json['type']),
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
  name: json['name'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CreateFileToJson(CreateFile instance) =>
    <String, dynamic>{
      'dataType': instance.dataType,
      'type': fileTypeNullableToJson(instance.type),
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
    };

CreateGroup _$CreateGroupFromJson(Map<String, dynamic> json) => CreateGroup(
  name: json['name'] as String,
  description: json['description'] as String,
  showOnDashboard: json['showOnDashboard'] as bool?,
  showTitle: json['showTitle'] as bool?,
);

Map<String, dynamic> _$CreateGroupToJson(CreateGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'showOnDashboard': instance.showOnDashboard,
      'showTitle': instance.showTitle,
    };

CreateMetric _$CreateMetricFromJson(Map<String, dynamic> json) => CreateMetric(
  unit: (json['unit'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num).toInt(),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String,
);

Map<String, dynamic> _$CreateMetricToJson(CreateMetric instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
      'type': instance.type,
      'source': importTypesNullableToJson(instance.source),
      'sourceId': instance.sourceId,
    };

CreateMetricType _$CreateMetricTypeFromJson(Map<String, dynamic> json) =>
    CreateMetricType(
      unit: (json['unit'] as num).toInt(),
      name: json['name'] as String,
      summaryType: metricSummaryNullableFromJson(json['summaryType']),
      description: json['description'] as String?,
      type: metricDataTypeNullableFromJson(json['type']),
      visible: json['visible'] as bool?,
      showOnDashboard: json['showOnDashboard'] as bool?,
      groupId: (json['groupId'] as num).toInt(),
      valueCount: (json['valueCount'] as num?)?.toInt(),
      timeDifference: json['timeDifference'] as String?,
    );

Map<String, dynamic> _$CreateMetricTypeToJson(CreateMetricType instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'name': instance.name,
      'summaryType': metricSummaryNullableToJson(instance.summaryType),
      'description': instance.description,
      'type': metricDataTypeNullableToJson(instance.type),
      'visible': instance.visible,
      'showOnDashboard': instance.showOnDashboard,
      'groupId': instance.groupId,
      'valueCount': instance.valueCount,
      'timeDifference': instance.timeDifference,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  user: (json['user'] as num?)?.toInt(),
  treatment: (json['treatment'] as num?)?.toInt(),
  id: (json['id'] as num).toInt(),
  person: (json['person'] as num?)?.toInt(),
  valid: json['valid'] as bool?,
  address: (json['address'] as num?)?.toInt(),
  type: (json['type'] as num).toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String?,
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'user': instance.user,
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
  'source': importTypesNullableToJson(instance.source),
  'sourceId': instance.sourceId,
};

EventCreationStats _$EventCreationStatsFromJson(Map<String, dynamic> json) =>
    EventCreationStats(
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

Map<String, dynamic> _$EventCreationStatsToJson(EventCreationStats instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
      'eventCounts': instance.eventCounts.map((e) => e.toJson()).toList(),
    };

EventSettings _$EventSettingsFromJson(Map<String, dynamic> json) =>
    EventSettings(
      displaySettings:
          (json['displaySettings'] as List<dynamic>?)
              ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      displayValueSettings:
          (json['displayValueSettings'] as List<dynamic>?)
              ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$EventSettingsToJson(
  EventSettings instance,
) => <String, dynamic>{
  'displaySettings': instance.displaySettings.map((e) => e.toJson()).toList(),
  'displayValueSettings': instance.displayValueSettings
      .map((e) => e.toJson())
      .toList(),
};

EventStats _$EventStatsFromJson(Map<String, dynamic> json) => EventStats(
  summaries:
      (json['summaries'] as List<dynamic>?)
          ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  durations:
      (json['durations'] as List<dynamic>?)
          ?.map((e) => Interval.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$EventStatsToJson(EventStats instance) =>
    <String, dynamic>{
      'summaries': instance.summaries.map((e) => e.toJson()).toList(),
      'durations': instance.durations.map((e) => e.toJson()).toList(),
      'events': instance.events.map((e) => e.toJson()).toList(),
    };

EventSummary _$EventSummaryFromJson(Map<String, dynamic> json) =>
    EventSummary(data: json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$EventSummaryToJson(EventSummary instance) =>
    <String, dynamic>{'data': instance.data};

EventType _$EventTypeFromJson(Map<String, dynamic> json) => EventType(
  id: (json['id'] as num).toInt(),
  userEditable: json['userEditable'] as bool,
  name: json['name'] as String,
  description: json['description'] as String?,
  standAlone: json['standAlone'] as bool?,
  visible: json['visible'] as bool?,
  timeDifference: json['timeDifference'] as String?,
  groupId: (json['groupId'] as num).toInt(),
);

Map<String, dynamic> _$EventTypeToJson(EventType instance) => <String, dynamic>{
  'id': instance.id,
  'userEditable': instance.userEditable,
  'name': instance.name,
  'description': instance.description,
  'standAlone': instance.standAlone,
  'visible': instance.visible,
  'timeDifference': instance.timeDifference,
  'groupId': instance.groupId,
};

File _$FileFromJson(Map<String, dynamic> json) => File(
  id: (json['id'] as num?)?.toInt(),
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
  type: fileTypeNullableFromJson(json['type']),
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
  name: json['name'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
  'id': instance.id,
  'created': instance.created?.toIso8601String(),
  'type': fileTypeNullableToJson(instance.type),
  'start': instance.start?.toIso8601String(),
  'stop': instance.stop?.toIso8601String(),
  'name': instance.name,
  'description': instance.description,
};

FileData _$FileDataFromJson(Map<String, dynamic> json) =>
    FileData(type: json['type'] as String, data: json['data'] as String);

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
  'type': instance.type,
  'data': instance.data,
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

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  showOnDashboard: json['showOnDashboard'] as bool?,
  showTitle: json['showTitle'] as bool?,
);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'showOnDashboard': instance.showOnDashboard,
  'showTitle': instance.showTitle,
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

ImportResult _$ImportResultFromJson(Map<String, dynamic> json) => ImportResult(
  imported: (json['imported'] as num).toInt(),
  skipped: (json['skipped'] as num).toInt(),
  failed: (json['failed'] as num).toInt(),
);

Map<String, dynamic> _$ImportResultToJson(ImportResult instance) =>
    <String, dynamic>{
      'imported': instance.imported,
      'skipped': instance.skipped,
      'failed': instance.failed,
    };

ImportsResult _$ImportsResultFromJson(Map<String, dynamic> json) =>
    ImportsResult(
      metrics: ImportResult.fromJson(json['metrics'] as Map<String, dynamic>),
      events: ImportResult.fromJson(json['events'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImportsResultToJson(ImportsResult instance) =>
    <String, dynamic>{
      'metrics': instance.metrics.toJson(),
      'events': instance.events.toJson(),
    };

ImportType _$ImportTypeFromJson(Map<String, dynamic> json) => ImportType(
  type: (json['type'] as num).toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$ImportTypeToJson(ImportType instance) =>
    <String, dynamic>{'type': instance.type, 'name': instance.name};

Interval _$IntervalFromJson(Map<String, dynamic> json) => Interval(
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
);

Map<String, dynamic> _$IntervalToJson(Interval instance) => <String, dynamic>{
  'start': instance.start.toIso8601String(),
  'stop': instance.stop.toIso8601String(),
};

JobId _$JobIdFromJson(Map<String, dynamic> json) =>
    JobId(id: json['id'] as String);

Map<String, dynamic> _$JobIdToJson(JobId instance) => <String, dynamic>{
  'id': instance.id,
};

JobResult _$JobResultFromJson(Map<String, dynamic> json) => JobResult(
  description: json['description'] as String,
  userId: (json['userId'] as num).toInt(),
  progress: (json['progress'] as num?)?.toDouble(),
  status: jobStatusNullableFromJson(json['status']),
  error: json['error'] as String?,
  start: DateTime.parse(json['start'] as String),
  enque: DateTime.parse(json['enque'] as String),
  stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
  result: json['result'] as String?,
);

Map<String, dynamic> _$JobResultToJson(JobResult instance) => <String, dynamic>{
  'description': instance.description,
  'userId': instance.userId,
  'progress': instance.progress,
  'status': jobStatusNullableToJson(instance.status),
  'error': instance.error,
  'start': instance.start.toIso8601String(),
  'enque': instance.enque.toIso8601String(),
  'stop': instance.stop?.toIso8601String(),
  'result': instance.result,
};

JobResultInfo _$JobResultInfoFromJson(Map<String, dynamic> json) =>
    JobResultInfo(
      id: json['id'] as String,
      result: JobResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobResultInfoToJson(JobResultInfo instance) =>
    <String, dynamic>{'id': instance.id, 'result': instance.result.toJson()};

Metric _$MetricFromJson(Map<String, dynamic> json) => Metric(
  id: (json['id'] as num).toInt(),
  person: (json['person'] as num).toInt(),
  user: (json['user'] as num?)?.toInt(),
  unit: json['unit'],
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num).toInt(),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String,
);

Map<String, dynamic> _$MetricToJson(Metric instance) => <String, dynamic>{
  'id': instance.id,
  'person': instance.person,
  'user': instance.user,
  'unit': instance.unit,
  'date': instance.date.toIso8601String(),
  'value': instance.value,
  'tag': instance.tag,
  'type': instance.type,
  'source': importTypesNullableToJson(instance.source),
  'sourceId': instance.sourceId,
};

MetricCreationStats _$MetricCreationStatsFromJson(Map<String, dynamic> json) =>
    MetricCreationStats(
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

Map<String, dynamic> _$MetricCreationStatsToJson(
  MetricCreationStats instance,
) => <String, dynamic>{
  'events': instance.events.map((e) => e.toJson()).toList(),
  'eventCounts': instance.eventCounts.map((e) => e.toJson()).toList(),
};

MetricGroupSettings _$MetricGroupSettingsFromJson(Map<String, dynamic> json) =>
    MetricGroupSettings(
      displaySettings:
          (json['displaySettings'] as List<dynamic>?)
              ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MetricGroupSettingsToJson(
  MetricGroupSettings instance,
) => <String, dynamic>{
  'displaySettings': instance.displaySettings.map((e) => e.toJson()).toList(),
};

MetricSettings _$MetricSettingsFromJson(Map<String, dynamic> json) =>
    MetricSettings(
      displaySettings:
          (json['displaySettings'] as List<dynamic>?)
              ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      groups: json['groups'],
    );

Map<String, dynamic> _$MetricSettingsToJson(
  MetricSettings instance,
) => <String, dynamic>{
  'displaySettings': instance.displaySettings.map((e) => e.toJson()).toList(),
  'groups': instance.groups,
};

MetricType _$MetricTypeFromJson(Map<String, dynamic> json) => MetricType(
  id: (json['id'] as num).toInt(),
  unit: Unit.fromJson(json['unit'] as Map<String, dynamic>),
  userEditable: json['userEditable'] as bool,
  name: json['name'] as String,
  summaryType: metricSummaryNullableFromJson(json['summaryType']),
  description: json['description'] as String?,
  type: metricDataTypeNullableFromJson(json['type']),
  visible: json['visible'] as bool?,
  showOnDashboard: json['showOnDashboard'] as bool?,
  groupId: (json['groupId'] as num).toInt(),
  valueCount: (json['valueCount'] as num?)?.toInt(),
  timeDifference: json['timeDifference'] as String?,
);

Map<String, dynamic> _$MetricTypeToJson(MetricType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit.toJson(),
      'userEditable': instance.userEditable,
      'name': instance.name,
      'summaryType': metricSummaryNullableToJson(instance.summaryType),
      'description': instance.description,
      'type': metricDataTypeNullableToJson(instance.type),
      'visible': instance.visible,
      'showOnDashboard': instance.showOnDashboard,
      'groupId': instance.groupId,
      'valueCount': instance.valueCount,
      'timeDifference': instance.timeDifference,
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

OrderedItem _$OrderedItemFromJson(Map<String, dynamic> json) => OrderedItem(
  visible: json['visible'] as bool?,
  showOnDashboard: json['showOnDashboard'] as bool?,
  order: (json['order'] as num?)?.toInt(),
  name: json['name'] as String,
  id: (json['id'] as num).toInt(),
  key: json['key'] as String?,
  graph: graphKindNullableFromJson(json['graph']),
  detailGraph: graphKindNullableFromJson(json['detailGraph']),
  parent: (json['parent'] as num?)?.toInt(),
  color: (json['color'] as num?)?.toInt(),
);

Map<String, dynamic> _$OrderedItemToJson(OrderedItem instance) =>
    <String, dynamic>{
      'visible': instance.visible,
      'showOnDashboard': instance.showOnDashboard,
      'order': instance.order,
      'name': instance.name,
      'id': instance.id,
      'key': instance.key,
      'graph': graphKindNullableToJson(instance.graph),
      'detailGraph': graphKindNullableToJson(instance.detailGraph),
      'parent': instance.parent,
      'color': instance.color,
    };

PaginatedOfFile _$PaginatedOfFileFromJson(Map<String, dynamic> json) =>
    PaginatedOfFile(
      count: (json['count'] as num?)?.toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => File.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PaginatedOfFileToJson(PaginatedOfFile instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

PatchEvent _$PatchEventFromJson(Map<String, dynamic> json) => PatchEvent(
  updateDescription: json['updateDescription'] as bool?,
  updateStop: json['updateStop'] as bool?,
  updateStart: json['updateStart'] as bool?,
  updateTag: json['updateTag'] as bool?,
  ids:
      (json['ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  type: (json['type'] as num).toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String?,
);

Map<String, dynamic> _$PatchEventToJson(PatchEvent instance) =>
    <String, dynamic>{
      'updateDescription': instance.updateDescription,
      'updateStop': instance.updateStop,
      'updateStart': instance.updateStart,
      'updateTag': instance.updateTag,
      'ids': instance.ids,
      'type': instance.type,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'stop': instance.stop.toIso8601String(),
      'tag': instance.tag,
      'notificationTime': instance.notificationTime?.toIso8601String(),
      'source': importTypesNullableToJson(instance.source),
      'sourceId': instance.sourceId,
    };

PatchMetric _$PatchMetricFromJson(Map<String, dynamic> json) => PatchMetric(
  updateValue: json['updateValue'] as bool?,
  updateDate: json['updateDate'] as bool?,
  updateTag: json['updateTag'] as bool?,
  ids:
      (json['ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  unit: (json['unit'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num).toInt(),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String,
);

Map<String, dynamic> _$PatchMetricToJson(PatchMetric instance) =>
    <String, dynamic>{
      'updateValue': instance.updateValue,
      'updateDate': instance.updateDate,
      'updateTag': instance.updateTag,
      'ids': instance.ids,
      'unit': instance.unit,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
      'type': instance.type,
      'source': importTypesNullableToJson(instance.source),
      'sourceId': instance.sourceId,
    };

PatientSettings _$PatientSettingsFromJson(
  Map<String, dynamic> json,
) => PatientSettings(
  patientId: (json['patientId'] as num?)?.toInt(),
  version: (json['version'] as num?)?.toInt(),
  datePreset: datePresetNullableFromJson(json['datePreset']),
  theme: interfaceThemeNullableFromJson(json['theme']),
  metrics:
      (json['metrics'] as List<dynamic>?)
          ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  metricGroups:
      (json['metricGroups'] as List<dynamic>?)
          ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  eventSettings: json['eventSettings'] == null
      ? null
      : EventSettings.fromJson(json['eventSettings'] as Map<String, dynamic>),
  metricSettings: json['metricSettings'] == null
      ? null
      : MetricSettings.fromJson(json['metricSettings'] as Map<String, dynamic>),
  groups: json['groups'] == null
      ? null
      : MetricGroupSettings.fromJson(json['groups'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PatientSettingsToJson(PatientSettings instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'version': instance.version,
      'datePreset': datePresetNullableToJson(instance.datePreset),
      'theme': interfaceThemeNullableToJson(instance.theme),
      'metrics': instance.metrics?.map((e) => e.toJson()).toList(),
      'metricGroups': instance.metricGroups?.map((e) => e.toJson()).toList(),
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'eventSettings': instance.eventSettings?.toJson(),
      'metricSettings': instance.metricSettings?.toJson(),
      'groups': instance.groups?.toJson(),
    };

PatientsSettings _$PatientsSettingsFromJson(Map<String, dynamic> json) =>
    PatientsSettings(
      version: (json['version'] as num?)?.toInt(),
      $default: json['default'] == null
          ? null
          : PatientSettings.fromJson(json['default'] as Map<String, dynamic>),
      patients:
          (json['patients'] as List<dynamic>?)
              ?.map((e) => PatientSettings.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PatientsSettingsToJson(PatientsSettings instance) =>
    <String, dynamic>{
      'version': instance.version,
      'default': instance.$default?.toJson(),
      'patients': instance.patients?.map((e) => e.toJson()).toList(),
    };

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  id: (json['id'] as num).toInt(),
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

SearchEvent _$SearchEventFromJson(Map<String, dynamic> json) => SearchEvent(
  type: (json['type'] as num).toInt(),
  value: json['value'] as String?,
  from: json['from'] == null ? null : DateTime.parse(json['from'] as String),
  to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
  source: importTypesNullableFromJson(json['source']),
  filterSource: json['filterSource'] as bool?,
);

Map<String, dynamic> _$SearchEventToJson(SearchEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'source': importTypesNullableToJson(instance.source),
      'filterSource': instance.filterSource,
    };

SearchMetric _$SearchMetricFromJson(Map<String, dynamic> json) => SearchMetric(
  type: (json['type'] as num).toInt(),
  value: json['value'] as String?,
  from: json['from'] == null ? null : DateTime.parse(json['from'] as String),
  to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
  minValue: (json['minValue'] as num?)?.toInt(),
  maxValue: (json['maxValue'] as num?)?.toInt(),
  source: importTypesNullableFromJson(json['source']),
  isTrue: json['isTrue'] as bool?,
  filterSource: json['filterSource'] as bool?,
);

Map<String, dynamic> _$SearchMetricToJson(SearchMetric instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'source': importTypesNullableToJson(instance.source),
      'isTrue': instance.isTrue,
      'filterSource': instance.filterSource,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  sessionId: json['sessionId'] as String,
  ip: json['ip'] as String?,
  location: json['location'] as String?,
  userAgent: json['userAgent'] as String?,
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'ip': instance.ip,
  'location': instance.location,
  'userAgent': instance.userAgent,
  'start': instance.start?.toIso8601String(),
  'stop': instance.stop?.toIso8601String(),
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

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
  type: unitTypeFromJson(json['type']),
  id: (json['id'] as num).toInt(),
  code: json['code'] as String,
  description: json['description'] as String?,
  baseUnit: json['baseUnit'],
);

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
  'type': unitTypeToJson(instance.type),
  'id': instance.id,
  'code': instance.code,
  'description': instance.description,
  'baseUnit': instance.baseUnit,
};

UpdateEvent _$UpdateEventFromJson(Map<String, dynamic> json) => UpdateEvent(
  id: (json['id'] as num?)?.toInt(),
  type: (json['type'] as num).toInt(),
  description: json['description'] as String?,
  start: DateTime.parse(json['start'] as String),
  stop: DateTime.parse(json['stop'] as String),
  tag: json['tag'] as String?,
  notificationTime: json['notificationTime'] == null
      ? null
      : DateTime.parse(json['notificationTime'] as String),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String?,
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
      'source': importTypesNullableToJson(instance.source),
      'sourceId': instance.sourceId,
    };

UpdateEventType _$UpdateEventTypeFromJson(Map<String, dynamic> json) =>
    UpdateEventType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      standAlone: json['standAlone'] as bool?,
      visible: json['visible'] as bool?,
      timeDifference: json['timeDifference'] as String?,
      groupId: (json['groupId'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateEventTypeToJson(UpdateEventType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'standAlone': instance.standAlone,
      'visible': instance.visible,
      'timeDifference': instance.timeDifference,
      'groupId': instance.groupId,
    };

UpdateFile _$UpdateFileFromJson(Map<String, dynamic> json) => UpdateFile(
  id: (json['id'] as num?)?.toInt(),
  dataType: json['dataType'] as String,
  type: fileTypeNullableFromJson(json['type']),
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
  name: json['name'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$UpdateFileToJson(UpdateFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataType': instance.dataType,
      'type': fileTypeNullableToJson(instance.type),
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
    };

UpdateGroup _$UpdateGroupFromJson(Map<String, dynamic> json) => UpdateGroup(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  showOnDashboard: json['showOnDashboard'] as bool?,
  showTitle: json['showTitle'] as bool?,
);

Map<String, dynamic> _$UpdateGroupToJson(UpdateGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'showOnDashboard': instance.showOnDashboard,
      'showTitle': instance.showTitle,
    };

UpdateMetric _$UpdateMetricFromJson(Map<String, dynamic> json) => UpdateMetric(
  id: (json['id'] as num?)?.toInt(),
  unit: (json['unit'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  value: json['value'] as String,
  tag: json['tag'] as String?,
  type: (json['type'] as num).toInt(),
  source: importTypesNullableFromJson(json['source']),
  sourceId: json['sourceId'] as String,
);

Map<String, dynamic> _$UpdateMetricToJson(UpdateMetric instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'tag': instance.tag,
      'type': instance.type,
      'source': importTypesNullableToJson(instance.source),
      'sourceId': instance.sourceId,
    };

UpdateMetricType _$UpdateMetricTypeFromJson(Map<String, dynamic> json) =>
    UpdateMetricType(
      id: (json['id'] as num).toInt(),
      unit: (json['unit'] as num).toInt(),
      name: json['name'] as String,
      summaryType: metricSummaryNullableFromJson(json['summaryType']),
      description: json['description'] as String?,
      type: metricDataTypeNullableFromJson(json['type']),
      visible: json['visible'] as bool?,
      showOnDashboard: json['showOnDashboard'] as bool?,
      groupId: (json['groupId'] as num).toInt(),
      valueCount: (json['valueCount'] as num?)?.toInt(),
      timeDifference: json['timeDifference'] as String?,
    );

Map<String, dynamic> _$UpdateMetricTypeToJson(UpdateMetricType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit,
      'name': instance.name,
      'summaryType': metricSummaryNullableToJson(instance.summaryType),
      'description': instance.description,
      'type': metricDataTypeNullableToJson(instance.type),
      'visible': instance.visible,
      'showOnDashboard': instance.showOnDashboard,
      'groupId': instance.groupId,
      'valueCount': instance.valueCount,
      'timeDifference': instance.timeDifference,
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

UserCreationStats _$UserCreationStatsFromJson(Map<String, dynamic> json) =>
    UserCreationStats(
      userCount:
          (json['userCount'] as List<dynamic>?)
              ?.map((e) => CountRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserCreationStatsToJson(UserCreationStats instance) =>
    <String, dynamic>{
      'userCount': instance.userCount.map((e) => e.toJson()).toList(),
    };

UserId _$UserIdFromJson(Map<String, dynamic> json) => UserId(
  person: (json['person'] as num).toInt(),
  user: (json['user'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserIdToJson(UserId instance) => <String, dynamic>{
  'person': instance.person,
  'user': instance.user,
};

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
  version: (json['version'] as num?)?.toInt(),
  datePreset: datePresetNullableFromJson(json['datePreset']),
  theme: interfaceThemeNullableFromJson(json['theme']),
  metrics:
      (json['metrics'] as List<dynamic>?)
          ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  metricGroups:
      (json['metricGroups'] as List<dynamic>?)
          ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => OrderedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  eventSettings: json['eventSettings'] == null
      ? null
      : EventSettings.fromJson(json['eventSettings'] as Map<String, dynamic>),
  metricSettings: json['metricSettings'] == null
      ? null
      : MetricSettings.fromJson(json['metricSettings'] as Map<String, dynamic>),
  groups: json['groups'] == null
      ? null
      : MetricGroupSettings.fromJson(json['groups'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'version': instance.version,
      'datePreset': datePresetNullableToJson(instance.datePreset),
      'theme': interfaceThemeNullableToJson(instance.theme),
      'metrics': instance.metrics?.map((e) => e.toJson()).toList(),
      'metricGroups': instance.metricGroups?.map((e) => e.toJson()).toList(),
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'eventSettings': instance.eventSettings?.toJson(),
      'metricSettings': instance.metricSettings?.toJson(),
      'groups': instance.groups?.toJson(),
    };

ApiFilesDataIdPost$RequestBody _$ApiFilesDataIdPost$RequestBodyFromJson(
  Map<String, dynamic> json,
) => ApiFilesDataIdPost$RequestBody(file: json['file'] as String);

Map<String, dynamic> _$ApiFilesDataIdPost$RequestBodyToJson(
  ApiFilesDataIdPost$RequestBody instance,
) => <String, dynamic>{'file': instance.file};

ApiImportTypePost$RequestBody _$ApiImportTypePost$RequestBodyFromJson(
  Map<String, dynamic> json,
) => ApiImportTypePost$RequestBody(file: json['file'] as String);

Map<String, dynamic> _$ApiImportTypePost$RequestBodyToJson(
  ApiImportTypePost$RequestBody instance,
) => <String, dynamic>{'file': instance.file};
