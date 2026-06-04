// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'helseapi.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Helseapi extends Helseapi {
  _$Helseapi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Helseapi;

  @override
  Future<Response<ConnectionResponse>> _apiAuthPost({
    required Connection? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Get a connection token',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["AuthLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ConnectionResponse, ConnectionResponse>($request);
  }

  @override
  Future<Response<ConnectionResponse>> _apiRefreshGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["AuthLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/refresh');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<ConnectionResponse, ConnectionResponse>($request);
  }

  @override
  Future<Response<Status>> _apiStatusGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Check if the server install is ready',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["AuthLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/status');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Status, Status>($request);
  }

  @override
  Future<Response<UserId>> _apiPersonPost({
    required PersonCreation? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PersonLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<UserId, UserId>($request);
  }

  @override
  Future<Response<List<Person>>> _apiPersonGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PersonLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<Person>, Person>($request);
  }

  @override
  Future<Response<dynamic>> _apiPersonPut({
    required UpdatePerson? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PersonLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiPersonUserIdDelete({
    required int? userId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PersonLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person/${userId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Person>>> _apiPersonCaregiverGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PersonLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person/caregiver');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<Person>, Person>($request);
  }

  @override
  Future<Response<UserSettings>> _apiPersonSettingsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person/settings');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<UserSettings, UserSettings>($request);
  }

  @override
  Future<Response<dynamic>> _apiPersonSettingsPost({
    required UserSettings? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person/settings');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiPersonRightsPersonIdPost({
    required int? personId,
    required List<Right>? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PersonLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/person/rights/${personId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Person>>> _apiPatientsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PatientsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/patients');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<Person>, Person>($request);
  }

  @override
  Future<Response<dynamic>> _apiPatientsPut({
    required UpdatePatient? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PatientsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/patients');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Event>>> _apiPatientsAgendaGet({
    required DateTime? start,
    required DateTime? end,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PatientsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/patients/agenda');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start': start,
      'end': end,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<dynamic>> _apiPatientsShareGet({
    required int? patient,
    required int? caregiver,
    required bool? edit,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["PatientsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/patients/share');
    final Map<String, dynamic> $params = <String, dynamic>{
      'patient': patient,
      'caregiver': caregiver,
      'edit': edit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<PatientsSettings>> _apiPatientsSettingsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/patients/settings');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<PatientsSettings, PatientsSettings>($request);
  }

  @override
  Future<Response<dynamic>> _apiPatientsSettingsPost({
    required PatientsSettings? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/patients/settings');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Metric>>> _apiMetricsSummaryGet({
    required int? tile,
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/summary');
    final Map<String, dynamic> $params = <String, dynamic>{
      'tile': tile,
      'type': type,
      'start': start,
      'end': end,
      'personId': personId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Metric>, Metric>($request);
  }

  @override
  Future<Response<List<Metric>>> _apiMetricsGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
      'start': start,
      'end': end,
      'personId': personId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Metric>, Metric>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsPost({
    int? personId,
    required CreateMetric? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics');
    final Map<String, dynamic> $params = <String, dynamic>{
      'personId': personId,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsPut({
    required UpdateMetric? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsIdDelete({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypePost({
    required MetricType? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypePut({
    required MetricType? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<MetricType>>> _apiMetricsTypeGet({
    bool? all,
    int? group,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type');
    final Map<String, dynamic> $params = <String, dynamic>{
      'all': all,
      'group': group,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<MetricType>, MetricType>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypeIdDelete({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypeGroupsPost({
    required MetricGroup? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type/groups');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypeGroupsPut({
    required MetricGroup? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type/groups');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<MetricGroup>>> _apiMetricsTypeGroupsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type/groups');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<MetricGroup>, MetricGroup>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypeGroupsIdDelete({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["MetricsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/metrics/type/groups/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<EventSummary>>> _apiEventsSummaryGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events/summary');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
      'start': start,
      'end': end,
      'personId': personId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<EventSummary>, EventSummary>($request);
  }

  @override
  Future<Response<List<Event>>> _apiEventsGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
      'start': start,
      'end': end,
      'personId': personId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsPost({
    int? personId,
    required CreateEvent? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'personId': personId,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsPut({
    int? personId,
    required UpdateEvent? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'personId': personId,
    };
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsIdDelete({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsTypePost({
    required EventType? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events/type');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsTypePut({
    required EventType? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events/type');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<EventType>>> _apiEventsTypeGet({
    bool? all,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events/type');
    final Map<String, dynamic> $params = <String, dynamic>{'all': all};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<EventType>, EventType>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsTypeIdDelete({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["EventsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/events/type/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiTreatmentPost({
    required CreateTreatment? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["TreatmentLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/treatment');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Event>>> _apiTreatmentGet({
    required DateTime? start,
    required DateTime? end,
    int? personId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["TreatmentLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/treatment');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start': start,
      'end': end,
      'personId': personId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<List<EventType>>> _apiTreatmentTypeGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["TreatmentLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/treatment/type');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<EventType>, EventType>($request);
  }

  @override
  Future<Response<dynamic>> _apiAdminSettingsOauthPost({
    required Oauth? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/oauth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Oauth>> _apiAdminSettingsOauthGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/oauth');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Oauth, Oauth>($request);
  }

  @override
  Future<Response<dynamic>> _apiAdminSettingsProxyPost({
    required Proxy? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/proxy');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Proxy>> _apiAdminSettingsProxyGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/proxy');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Proxy, Proxy>($request);
  }

  @override
  Future<Response<dynamic>> _apiAdminSettingsSmtpPost({
    required Smtp? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/smtp');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Smtp>> _apiAdminSettingsSmtpGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/smtp');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Smtp, Smtp>($request);
  }

  @override
  Future<Response<Gotify>> _apiAdminSettingsGotifyGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/gotify');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Gotify, Gotify>($request);
  }

  @override
  Future<Response<dynamic>> _apiAdminSettingsGotifyPost({
    required Gotify? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["SettingsLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/gotify');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<JobResult>>> _apiAdminSettingsJobsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/settings/jobs');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<JobResult>, JobResult>($request);
  }

  @override
  Future<Response<UserStats>> _apiAdminStatsUsersGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["AdminLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/stats/users');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<UserStats, UserStats>($request);
  }

  @override
  Future<Response<EventStats>> _apiAdminStatsEventsGet({
    required DateTime? start,
    required DateTime? end,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["AdminLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/stats/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start': start,
      'end': end,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<EventStats, EventStats>($request);
  }

  @override
  Future<Response<EventStats>> _apiAdminStatsMetricsGet({
    required DateTime? start,
    required DateTime? end,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["AdminLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/admin/stats/metrics');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start': start,
      'end': end,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<EventStats, EventStats>($request);
  }

  @override
  Future<Response<List<FileType>>> _apiImportTypesGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/import/types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<FileType>, FileType>($request);
  }

  @override
  Future<Response<JobId>> _apiImportTypePost({
    required int? type,
    int? patient,
    required dynamic file,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/import/${type}');
    final Map<String, dynamic> $params = <String, dynamic>{'patient': patient};
    final List<PartValue> $parts = <PartValue>[
      PartValue<dynamic>('file', file),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<JobId, JobId>($request);
  }

  @override
  Future<Response<List<JobResultInfo>>> _apiImportJobsAllGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/import/jobs/all');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<JobResultInfo>, JobResultInfo>($request);
  }

  @override
  Future<Response<List<JobResultInfo>>> _apiImportJobsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/import/jobs');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<JobResultInfo>, JobResultInfo>($request);
  }

  @override
  Future<Response<JobResult>> _apiImportIdGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/import/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<JobResult, JobResult>($request);
  }

  @override
  Future<Response<ImportsResult>> _apiImportPost({
    int? patient,
    required ImportData? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["ImportLogic"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/import');
    final Map<String, dynamic> $params = <String, dynamic>{'patient': patient};
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ImportsResult, ImportsResult>($request);
  }
}
