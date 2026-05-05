// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'helseapi.metadata.swagger.dart';

part 'helseapi.swagger.chopper.dart';
part 'helseapi.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Helseapi extends ChopperService {
  static Helseapi create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Helseapi(client);
    }

    final newClient = ChopperClient(
      services: [_$Helseapi()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$Helseapi(newClient);
  }

  ///
  Future<chopper.Response<TokenResponse>> apiAuthPost({
    required Connection? body,
  }) {
    generatedMapping.putIfAbsent(
      TokenResponse,
      () => TokenResponse.fromJsonFactory,
    );

    return _apiAuthPost(body: body);
  }

  ///
  @POST(path: '/api/auth', optionalBody: true)
  Future<chopper.Response<TokenResponse>> _apiAuthPost({
    @Body() required Connection? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<Status>> apiStatusGet() {
    generatedMapping.putIfAbsent(Status, () => Status.fromJsonFactory);

    return _apiStatusGet();
  }

  ///
  @GET(path: '/api/status')
  Future<chopper.Response<Status>> _apiStatusGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiPersonPost({required PersonCreation? body}) {
    return _apiPersonPost(body: body);
  }

  ///
  @POST(path: '/api/person', optionalBody: true)
  Future<chopper.Response> _apiPersonPost({
    @Body() required PersonCreation? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<Person>>> apiPersonGet() {
    generatedMapping.putIfAbsent(Person, () => Person.fromJsonFactory);

    return _apiPersonGet();
  }

  ///
  @GET(path: '/api/person')
  Future<chopper.Response<List<Person>>> _apiPersonGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<Person>>> apiPersonCaregiverGet() {
    generatedMapping.putIfAbsent(Person, () => Person.fromJsonFactory);

    return _apiPersonCaregiverGet();
  }

  ///
  @GET(path: '/api/person/caregiver')
  Future<chopper.Response<List<Person>>> _apiPersonCaregiverGet({
    @chopper.Tag()
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
  });

  ///
  ///@param personId
  ///@param role
  Future<chopper.Response> apiPersonRolePost({
    required int? personId,
    required int? role,
  }) {
    return _apiPersonRolePost(personId: personId, role: role);
  }

  ///
  ///@param personId
  ///@param role
  @POST(path: '/api/person/role', optionalBody: true)
  Future<chopper.Response> _apiPersonRolePost({
    @Query('personId') required int? personId,
    @Query('role') required int? role,
    @chopper.Tag()
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
  });

  ///
  ///@param personId
  Future<chopper.Response> apiPersonRightsPersonIdPost({
    required int? personId,
    required List<Right>? body,
  }) {
    return _apiPersonRightsPersonIdPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/person/rights/{personId}', optionalBody: true)
  Future<chopper.Response> _apiPersonRightsPersonIdPost({
    @Path('personId') required int? personId,
    @Body() required List<Right>? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<Person>>> apiPatientsGet() {
    generatedMapping.putIfAbsent(Person, () => Person.fromJsonFactory);

    return _apiPatientsGet();
  }

  ///
  @GET(path: '/api/patients')
  Future<chopper.Response<List<Person>>> _apiPatientsGet({
    @chopper.Tag()
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
  });

  ///
  ///@param start
  ///@param end
  Future<chopper.Response<List<Event>>> apiPatientsAgendaGet({
    required DateTime? start,
    required DateTime? end,
  }) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiPatientsAgendaGet(start: start, end: end);
  }

  ///
  ///@param start
  ///@param end
  @GET(path: '/api/patients/agenda')
  Future<chopper.Response<List<Event>>> _apiPatientsAgendaGet({
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @chopper.Tag()
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
  });

  ///
  ///@param patient
  ///@param caregiver
  ///@param edit
  Future<chopper.Response> apiPatientsShareGet({
    required int? patient,
    required int? caregiver,
    required bool? edit,
  }) {
    return _apiPatientsShareGet(
      patient: patient,
      caregiver: caregiver,
      edit: edit,
    );
  }

  ///
  ///@param patient
  ///@param caregiver
  ///@param edit
  @GET(path: '/api/patients/share')
  Future<chopper.Response> _apiPatientsShareGet({
    @Query('patient') required int? patient,
    @Query('caregiver') required int? caregiver,
    @Query('edit') required bool? edit,
    @chopper.Tag()
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
  });

  ///
  ///@param tile
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Metric>>> apiMetricsSummaryGet({
    required int? tile,
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Metric, () => Metric.fromJsonFactory);

    return _apiMetricsSummaryGet(
      tile: tile,
      type: type,
      start: start,
      end: end,
      personId: personId,
    );
  }

  ///
  ///@param tile
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @GET(path: '/api/metrics/summary')
  Future<chopper.Response<List<Metric>>> _apiMetricsSummaryGet({
    @Query('tile') required int? tile,
    @Query('type') required int? type,
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
    @chopper.Tag()
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
  });

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Metric>>> apiMetricsGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Metric, () => Metric.fromJsonFactory);

    return _apiMetricsGet(
      type: type,
      start: start,
      end: end,
      personId: personId,
    );
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @GET(path: '/api/metrics')
  Future<chopper.Response<List<Metric>>> _apiMetricsGet({
    @Query('type') required int? type,
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
    @chopper.Tag()
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
  });

  ///
  ///@param personId
  Future<chopper.Response> apiMetricsPost({
    int? personId,
    required CreateMetric? body,
  }) {
    return _apiMetricsPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/metrics', optionalBody: true)
  Future<chopper.Response> _apiMetricsPost({
    @Query('personId') int? personId,
    @Body() required CreateMetric? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiMetricsPut({required UpdateMetric? body}) {
    return _apiMetricsPut(body: body);
  }

  ///
  @PUT(path: '/api/metrics', optionalBody: true)
  Future<chopper.Response> _apiMetricsPut({
    @Body() required UpdateMetric? body,
    @chopper.Tag()
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
  });

  ///
  ///@param id
  Future<chopper.Response> apiMetricsIdDelete({required int? id}) {
    return _apiMetricsIdDelete(id: id);
  }

  ///
  ///@param id
  @DELETE(path: '/api/metrics/{id}')
  Future<chopper.Response> _apiMetricsIdDelete({
    @Path('id') required int? id,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiMetricsTypePost({required MetricType? body}) {
    return _apiMetricsTypePost(body: body);
  }

  ///
  @POST(path: '/api/metrics/type', optionalBody: true)
  Future<chopper.Response> _apiMetricsTypePost({
    @Body() required MetricType? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiMetricsTypePut({required MetricType? body}) {
    return _apiMetricsTypePut(body: body);
  }

  ///
  @PUT(path: '/api/metrics/type', optionalBody: true)
  Future<chopper.Response> _apiMetricsTypePut({
    @Body() required MetricType? body,
    @chopper.Tag()
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
  });

  ///
  ///@param all
  Future<chopper.Response<List<MetricType>>> apiMetricsTypeGet({bool? all}) {
    generatedMapping.putIfAbsent(MetricType, () => MetricType.fromJsonFactory);

    return _apiMetricsTypeGet(all: all);
  }

  ///
  ///@param all
  @GET(path: '/api/metrics/type')
  Future<chopper.Response<List<MetricType>>> _apiMetricsTypeGet({
    @Query('all') bool? all,
    @chopper.Tag()
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
  });

  ///
  ///@param id
  Future<chopper.Response> apiMetricsTypeIdDelete({required int? id}) {
    return _apiMetricsTypeIdDelete(id: id);
  }

  ///
  ///@param id
  @DELETE(path: '/api/metrics/type/{id}')
  Future<chopper.Response> _apiMetricsTypeIdDelete({
    @Path('id') required int? id,
    @chopper.Tag()
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
  });

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<EventSummary>>> apiEventsSummaryGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(
      EventSummary,
      () => EventSummary.fromJsonFactory,
    );

    return _apiEventsSummaryGet(
      type: type,
      start: start,
      end: end,
      personId: personId,
    );
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @GET(path: '/api/events/summary')
  Future<chopper.Response<List<EventSummary>>> _apiEventsSummaryGet({
    @Query('type') required int? type,
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
    @chopper.Tag()
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
  });

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Event>>> apiEventsGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiEventsGet(
      type: type,
      start: start,
      end: end,
      personId: personId,
    );
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @GET(path: '/api/events')
  Future<chopper.Response<List<Event>>> _apiEventsGet({
    @Query('type') required int? type,
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
    @chopper.Tag()
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
  });

  ///
  ///@param personId
  Future<chopper.Response> apiEventsPost({
    int? personId,
    required CreateEvent? body,
  }) {
    return _apiEventsPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/events', optionalBody: true)
  Future<chopper.Response> _apiEventsPost({
    @Query('personId') int? personId,
    @Body() required CreateEvent? body,
    @chopper.Tag()
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
  });

  ///
  ///@param personId
  Future<chopper.Response> apiEventsPut({
    int? personId,
    required UpdateEvent? body,
  }) {
    return _apiEventsPut(personId: personId, body: body);
  }

  ///
  ///@param personId
  @PUT(path: '/api/events', optionalBody: true)
  Future<chopper.Response> _apiEventsPut({
    @Query('personId') int? personId,
    @Body() required UpdateEvent? body,
    @chopper.Tag()
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
  });

  ///
  ///@param id
  Future<chopper.Response> apiEventsIdDelete({required int? id}) {
    return _apiEventsIdDelete(id: id);
  }

  ///
  ///@param id
  @DELETE(path: '/api/events/{id}')
  Future<chopper.Response> _apiEventsIdDelete({
    @Path('id') required int? id,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiEventsTypePost({required EventType? body}) {
    return _apiEventsTypePost(body: body);
  }

  ///
  @POST(path: '/api/events/type', optionalBody: true)
  Future<chopper.Response> _apiEventsTypePost({
    @Body() required EventType? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiEventsTypePut({required EventType? body}) {
    return _apiEventsTypePut(body: body);
  }

  ///
  @PUT(path: '/api/events/type', optionalBody: true)
  Future<chopper.Response> _apiEventsTypePut({
    @Body() required EventType? body,
    @chopper.Tag()
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
  });

  ///
  ///@param all
  Future<chopper.Response<List<EventType>>> apiEventsTypeGet({bool? all}) {
    generatedMapping.putIfAbsent(EventType, () => EventType.fromJsonFactory);

    return _apiEventsTypeGet(all: all);
  }

  ///
  ///@param all
  @GET(path: '/api/events/type')
  Future<chopper.Response<List<EventType>>> _apiEventsTypeGet({
    @Query('all') bool? all,
    @chopper.Tag()
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
  });

  ///
  ///@param id
  Future<chopper.Response> apiEventsTypeIdDelete({required int? id}) {
    return _apiEventsTypeIdDelete(id: id);
  }

  ///
  ///@param id
  @DELETE(path: '/api/events/type/{id}')
  Future<chopper.Response> _apiEventsTypeIdDelete({
    @Path('id') required int? id,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiTreatmentPost({required CreateTreatment? body}) {
    return _apiTreatmentPost(body: body);
  }

  ///
  @POST(path: '/api/treatment', optionalBody: true)
  Future<chopper.Response> _apiTreatmentPost({
    @Body() required CreateTreatment? body,
    @chopper.Tag()
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
  });

  ///
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Treatement>>> apiTreatmentGet({
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Treatement, () => Treatement.fromJsonFactory);

    return _apiTreatmentGet(start: start, end: end, personId: personId);
  }

  ///
  ///@param start
  ///@param end
  ///@param personId
  @GET(path: '/api/treatment')
  Future<chopper.Response<List<Treatement>>> _apiTreatmentGet({
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<EventType>>> apiTreatmentTypeGet() {
    generatedMapping.putIfAbsent(EventType, () => EventType.fromJsonFactory);

    return _apiTreatmentTypeGet();
  }

  ///
  @GET(path: '/api/treatment/type')
  Future<chopper.Response<List<EventType>>> _apiTreatmentTypeGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiAdminSettingsOauthPost({required Oauth? body}) {
    return _apiAdminSettingsOauthPost(body: body);
  }

  ///
  @POST(path: '/api/admin/settings/oauth', optionalBody: true)
  Future<chopper.Response> _apiAdminSettingsOauthPost({
    @Body() required Oauth? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<Oauth>> apiAdminSettingsOauthGet() {
    generatedMapping.putIfAbsent(Oauth, () => Oauth.fromJsonFactory);

    return _apiAdminSettingsOauthGet();
  }

  ///
  @GET(path: '/api/admin/settings/oauth')
  Future<chopper.Response<Oauth>> _apiAdminSettingsOauthGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiAdminSettingsProxyPost({required Proxy? body}) {
    return _apiAdminSettingsProxyPost(body: body);
  }

  ///
  @POST(path: '/api/admin/settings/proxy', optionalBody: true)
  Future<chopper.Response> _apiAdminSettingsProxyPost({
    @Body() required Proxy? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<Proxy>> apiAdminSettingsProxyGet() {
    generatedMapping.putIfAbsent(Proxy, () => Proxy.fromJsonFactory);

    return _apiAdminSettingsProxyGet();
  }

  ///
  @GET(path: '/api/admin/settings/proxy')
  Future<chopper.Response<Proxy>> _apiAdminSettingsProxyGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<FileType>>> apiImportTypesGet() {
    generatedMapping.putIfAbsent(FileType, () => FileType.fromJsonFactory);

    return _apiImportTypesGet();
  }

  ///
  @GET(path: '/api/import/types')
  Future<chopper.Response<List<FileType>>> _apiImportTypesGet({
    @chopper.Tag()
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
  });

  ///
  ///@param type
  Future<chopper.Response> apiImportTypePost({
    required int? type,
    required ImportFile? body,
  }) {
    return _apiImportTypePost(type: type, body: body);
  }

  ///
  ///@param type
  @POST(path: '/api/import/{type}', optionalBody: true)
  Future<chopper.Response> _apiImportTypePost({
    @Path('type') required int? type,
    @Body() required ImportFile? body,
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response> apiImportPost({required ImportData? body}) {
    return _apiImportPost(body: body);
  }

  ///
  @POST(path: '/api/import', optionalBody: true)
  Future<chopper.Response> _apiImportPost({
    @Body() required ImportData? body,
    @chopper.Tag()
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
  });
}

@JsonSerializable(explicitToJson: true)
class Connection {
  const Connection({required this.user, required this.password, this.redirect});

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);

  static const toJsonFactory = _$ConnectionToJson;
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);

  @JsonKey(name: 'user')
  final String user;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'redirect')
  final String? redirect;
  static const fromJsonFactory = _$ConnectionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Connection &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.redirect, redirect) ||
                const DeepCollectionEquality().equals(
                  other.redirect,
                  redirect,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(redirect) ^
      runtimeType.hashCode;
}

extension $ConnectionExtension on Connection {
  Connection copyWith({String? user, String? password, String? redirect}) {
    return Connection(
      user: user ?? this.user,
      password: password ?? this.password,
      redirect: redirect ?? this.redirect,
    );
  }

  Connection copyWithWrapped({
    Wrapped<String>? user,
    Wrapped<String>? password,
    Wrapped<String?>? redirect,
  }) {
    return Connection(
      user: (user != null ? user.value : this.user),
      password: (password != null ? password.value : this.password),
      redirect: (redirect != null ? redirect.value : this.redirect),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateEvent {
  const CreateEvent({
    this.type,
    this.description,
    this.start,
    this.stop,
    this.tag,
  });

  factory CreateEvent.fromJson(Map<String, dynamic> json) =>
      _$CreateEventFromJson(json);

  static const toJsonFactory = _$CreateEventToJson;
  Map<String, dynamic> toJson() => _$CreateEventToJson(this);

  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'tag')
  final String? tag;
  static const fromJsonFactory = _$CreateEventFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateEvent &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(tag) ^
      runtimeType.hashCode;
}

extension $CreateEventExtension on CreateEvent {
  CreateEvent copyWith({
    int? type,
    String? description,
    DateTime? start,
    DateTime? stop,
    String? tag,
  }) {
    return CreateEvent(
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
    );
  }

  CreateEvent copyWithWrapped({
    Wrapped<int?>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String?>? tag,
  }) {
    return CreateEvent(
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      tag: (tag != null ? tag.value : this.tag),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateMetric {
  const CreateMetric({
    this.date,
    required this.value,
    this.tag,
    this.type,
    this.source,
  });

  factory CreateMetric.fromJson(Map<String, dynamic> json) =>
      _$CreateMetricFromJson(json);

  static const toJsonFactory = _$CreateMetricToJson;
  Map<String, dynamic> toJson() => _$CreateMetricToJson(this);

  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'source')
  final int? source;
  static const fromJsonFactory = _$CreateMetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateMetric &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      runtimeType.hashCode;
}

extension $CreateMetricExtension on CreateMetric {
  CreateMetric copyWith({
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    int? source,
  }) {
    return CreateMetric(
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
    );
  }

  CreateMetric copyWithWrapped({
    Wrapped<DateTime?>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int?>? type,
    Wrapped<int?>? source,
  }) {
    return CreateMetric(
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateTreatment {
  const CreateTreatment({this.events, this.personId});

  factory CreateTreatment.fromJson(Map<String, dynamic> json) =>
      _$CreateTreatmentFromJson(json);

  static const toJsonFactory = _$CreateTreatmentToJson;
  Map<String, dynamic> toJson() => _$CreateTreatmentToJson(this);

  @JsonKey(name: 'events', defaultValue: <CreateEvent>[])
  final List<CreateEvent>? events;
  @JsonKey(name: 'personId')
  final int? personId;
  static const fromJsonFactory = _$CreateTreatmentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateTreatment &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)) &&
            (identical(other.personId, personId) ||
                const DeepCollectionEquality().equals(
                  other.personId,
                  personId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(events) ^
      const DeepCollectionEquality().hash(personId) ^
      runtimeType.hashCode;
}

extension $CreateTreatmentExtension on CreateTreatment {
  CreateTreatment copyWith({List<CreateEvent>? events, int? personId}) {
    return CreateTreatment(
      events: events ?? this.events,
      personId: personId ?? this.personId,
    );
  }

  CreateTreatment copyWithWrapped({
    Wrapped<List<CreateEvent>?>? events,
    Wrapped<int?>? personId,
  }) {
    return CreateTreatment(
      events: (events != null ? events.value : this.events),
      personId: (personId != null ? personId.value : this.personId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Event {
  const Event({
    this.user,
    this.file,
    this.treatment,
    this.id,
    this.person,
    this.valid,
    this.address,
    this.type,
    this.description,
    this.start,
    this.stop,
    this.tag,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  static const toJsonFactory = _$EventToJson;
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @JsonKey(name: 'user')
  final int? user;
  @JsonKey(name: 'file')
  final int? file;
  @JsonKey(name: 'treatment')
  final int? treatment;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'person')
  final int? person;
  @JsonKey(name: 'valid')
  final bool? valid;
  @JsonKey(name: 'address')
  final int? address;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'tag')
  final String? tag;
  static const fromJsonFactory = _$EventFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Event &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)) &&
            (identical(other.treatment, treatment) ||
                const DeepCollectionEquality().equals(
                  other.treatment,
                  treatment,
                )) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.person, person) ||
                const DeepCollectionEquality().equals(other.person, person)) &&
            (identical(other.valid, valid) ||
                const DeepCollectionEquality().equals(other.valid, valid)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality().equals(
                  other.address,
                  address,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(file) ^
      const DeepCollectionEquality().hash(treatment) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(person) ^
      const DeepCollectionEquality().hash(valid) ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(tag) ^
      runtimeType.hashCode;
}

extension $EventExtension on Event {
  Event copyWith({
    int? user,
    int? file,
    int? treatment,
    int? id,
    int? person,
    bool? valid,
    int? address,
    int? type,
    String? description,
    DateTime? start,
    DateTime? stop,
    String? tag,
  }) {
    return Event(
      user: user ?? this.user,
      file: file ?? this.file,
      treatment: treatment ?? this.treatment,
      id: id ?? this.id,
      person: person ?? this.person,
      valid: valid ?? this.valid,
      address: address ?? this.address,
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
    );
  }

  Event copyWithWrapped({
    Wrapped<int?>? user,
    Wrapped<int?>? file,
    Wrapped<int?>? treatment,
    Wrapped<int?>? id,
    Wrapped<int?>? person,
    Wrapped<bool?>? valid,
    Wrapped<int?>? address,
    Wrapped<int?>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String?>? tag,
  }) {
    return Event(
      user: (user != null ? user.value : this.user),
      file: (file != null ? file.value : this.file),
      treatment: (treatment != null ? treatment.value : this.treatment),
      id: (id != null ? id.value : this.id),
      person: (person != null ? person.value : this.person),
      valid: (valid != null ? valid.value : this.valid),
      address: (address != null ? address.value : this.address),
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      tag: (tag != null ? tag.value : this.tag),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class EventSummary {
  const EventSummary({required this.data});

  factory EventSummary.fromJson(Map<String, dynamic> json) =>
      _$EventSummaryFromJson(json);

  static const toJsonFactory = _$EventSummaryToJson;
  Map<String, dynamic> toJson() => _$EventSummaryToJson(this);

  @JsonKey(name: 'data')
  final Map<String, dynamic> data;
  static const fromJsonFactory = _$EventSummaryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventSummary &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $EventSummaryExtension on EventSummary {
  EventSummary copyWith({Map<String, dynamic>? data}) {
    return EventSummary(data: data ?? this.data);
  }

  EventSummary copyWithWrapped({Wrapped<Map<String, dynamic>>? data}) {
    return EventSummary(data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class EventType {
  const EventType({
    this.id,
    required this.name,
    this.description,
    this.standAlone,
    this.userEditable,
    this.visible,
  });

  factory EventType.fromJson(Map<String, dynamic> json) =>
      _$EventTypeFromJson(json);

  static const toJsonFactory = _$EventTypeToJson;
  Map<String, dynamic> toJson() => _$EventTypeToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'standAlone')
  final bool? standAlone;
  @JsonKey(name: 'userEditable')
  final bool? userEditable;
  @JsonKey(name: 'visible')
  final bool? visible;
  static const fromJsonFactory = _$EventTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventType &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.standAlone, standAlone) ||
                const DeepCollectionEquality().equals(
                  other.standAlone,
                  standAlone,
                )) &&
            (identical(other.userEditable, userEditable) ||
                const DeepCollectionEquality().equals(
                  other.userEditable,
                  userEditable,
                )) &&
            (identical(other.visible, visible) ||
                const DeepCollectionEquality().equals(other.visible, visible)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(standAlone) ^
      const DeepCollectionEquality().hash(userEditable) ^
      const DeepCollectionEquality().hash(visible) ^
      runtimeType.hashCode;
}

extension $EventTypeExtension on EventType {
  EventType copyWith({
    int? id,
    String? name,
    String? description,
    bool? standAlone,
    bool? userEditable,
    bool? visible,
  }) {
    return EventType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      standAlone: standAlone ?? this.standAlone,
      userEditable: userEditable ?? this.userEditable,
      visible: visible ?? this.visible,
    );
  }

  EventType copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<bool?>? standAlone,
    Wrapped<bool?>? userEditable,
    Wrapped<bool?>? visible,
  }) {
    return EventType(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      standAlone: (standAlone != null ? standAlone.value : this.standAlone),
      userEditable: (userEditable != null
          ? userEditable.value
          : this.userEditable),
      visible: (visible != null ? visible.value : this.visible),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class FileType {
  const FileType({required this.type, this.name});

  factory FileType.fromJson(Map<String, dynamic> json) =>
      _$FileTypeFromJson(json);

  static const toJsonFactory = _$FileTypeToJson;
  Map<String, dynamic> toJson() => _$FileTypeToJson(this);

  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'name')
  final String? name;
  static const fromJsonFactory = _$FileTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FileType &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $FileTypeExtension on FileType {
  FileType copyWith({int? type, String? name}) {
    return FileType(type: type ?? this.type, name: name ?? this.name);
  }

  FileType copyWithWrapped({Wrapped<int>? type, Wrapped<String?>? name}) {
    return FileType(
      type: (type != null ? type.value : this.type),
      name: (name != null ? name.value : this.name),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ImportData {
  const ImportData({this.metrics, this.events});

  factory ImportData.fromJson(Map<String, dynamic> json) =>
      _$ImportDataFromJson(json);

  static const toJsonFactory = _$ImportDataToJson;
  Map<String, dynamic> toJson() => _$ImportDataToJson(this);

  @JsonKey(name: 'metrics', defaultValue: <CreateMetric>[])
  final List<CreateMetric>? metrics;
  @JsonKey(name: 'events', defaultValue: <CreateEvent>[])
  final List<CreateEvent>? events;
  static const fromJsonFactory = _$ImportDataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ImportData &&
            (identical(other.metrics, metrics) ||
                const DeepCollectionEquality().equals(
                  other.metrics,
                  metrics,
                )) &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(metrics) ^
      const DeepCollectionEquality().hash(events) ^
      runtimeType.hashCode;
}

extension $ImportDataExtension on ImportData {
  ImportData copyWith({
    List<CreateMetric>? metrics,
    List<CreateEvent>? events,
  }) {
    return ImportData(
      metrics: metrics ?? this.metrics,
      events: events ?? this.events,
    );
  }

  ImportData copyWithWrapped({
    Wrapped<List<CreateMetric>?>? metrics,
    Wrapped<List<CreateEvent>?>? events,
  }) {
    return ImportData(
      metrics: (metrics != null ? metrics.value : this.metrics),
      events: (events != null ? events.value : this.events),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ImportFile {
  const ImportFile({required this.content});

  factory ImportFile.fromJson(Map<String, dynamic> json) =>
      _$ImportFileFromJson(json);

  static const toJsonFactory = _$ImportFileToJson;
  Map<String, dynamic> toJson() => _$ImportFileToJson(this);

  @JsonKey(name: 'content')
  final String content;
  static const fromJsonFactory = _$ImportFileFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ImportFile &&
            (identical(other.content, content) ||
                const DeepCollectionEquality().equals(other.content, content)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(content) ^ runtimeType.hashCode;
}

extension $ImportFileExtension on ImportFile {
  ImportFile copyWith({String? content}) {
    return ImportFile(content: content ?? this.content);
  }

  ImportFile copyWithWrapped({Wrapped<String>? content}) {
    return ImportFile(
      content: (content != null ? content.value : this.content),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Metric {
  const Metric({
    this.id,
    this.person,
    this.user,
    this.date,
    required this.value,
    this.tag,
    this.type,
    this.source,
  });

  factory Metric.fromJson(Map<String, dynamic> json) => _$MetricFromJson(json);

  static const toJsonFactory = _$MetricToJson;
  Map<String, dynamic> toJson() => _$MetricToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'person')
  final int? person;
  @JsonKey(name: 'user')
  final int? user;
  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'source')
  final int? source;
  static const fromJsonFactory = _$MetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Metric &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.person, person) ||
                const DeepCollectionEquality().equals(other.person, person)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(person) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      runtimeType.hashCode;
}

extension $MetricExtension on Metric {
  Metric copyWith({
    int? id,
    int? person,
    int? user,
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    int? source,
  }) {
    return Metric(
      id: id ?? this.id,
      person: person ?? this.person,
      user: user ?? this.user,
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
    );
  }

  Metric copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? person,
    Wrapped<int?>? user,
    Wrapped<DateTime?>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int?>? type,
    Wrapped<int?>? source,
  }) {
    return Metric(
      id: (id != null ? id.value : this.id),
      person: (person != null ? person.value : this.person),
      user: (user != null ? user.value : this.user),
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MetricType {
  const MetricType({
    required this.name,
    this.unit,
    this.summaryType,
    this.description,
    this.type,
    this.id,
    this.userEditable,
    this.visible,
  });

  factory MetricType.fromJson(Map<String, dynamic> json) =>
      _$MetricTypeFromJson(json);

  static const toJsonFactory = _$MetricTypeToJson;
  Map<String, dynamic> toJson() => _$MetricTypeToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'unit')
  final String? unit;
  @JsonKey(name: 'summaryType')
  final int? summaryType;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'userEditable')
  final bool? userEditable;
  @JsonKey(name: 'visible')
  final bool? visible;
  static const fromJsonFactory = _$MetricTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MetricType &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.summaryType, summaryType) ||
                const DeepCollectionEquality().equals(
                  other.summaryType,
                  summaryType,
                )) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userEditable, userEditable) ||
                const DeepCollectionEquality().equals(
                  other.userEditable,
                  userEditable,
                )) &&
            (identical(other.visible, visible) ||
                const DeepCollectionEquality().equals(other.visible, visible)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(summaryType) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userEditable) ^
      const DeepCollectionEquality().hash(visible) ^
      runtimeType.hashCode;
}

extension $MetricTypeExtension on MetricType {
  MetricType copyWith({
    String? name,
    String? unit,
    int? summaryType,
    String? description,
    int? type,
    int? id,
    bool? userEditable,
    bool? visible,
  }) {
    return MetricType(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      summaryType: summaryType ?? this.summaryType,
      description: description ?? this.description,
      type: type ?? this.type,
      id: id ?? this.id,
      userEditable: userEditable ?? this.userEditable,
      visible: visible ?? this.visible,
    );
  }

  MetricType copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? unit,
    Wrapped<int?>? summaryType,
    Wrapped<String?>? description,
    Wrapped<int?>? type,
    Wrapped<int?>? id,
    Wrapped<bool?>? userEditable,
    Wrapped<bool?>? visible,
  }) {
    return MetricType(
      name: (name != null ? name.value : this.name),
      unit: (unit != null ? unit.value : this.unit),
      summaryType: (summaryType != null ? summaryType.value : this.summaryType),
      description: (description != null ? description.value : this.description),
      type: (type != null ? type.value : this.type),
      id: (id != null ? id.value : this.id),
      userEditable: (userEditable != null
          ? userEditable.value
          : this.userEditable),
      visible: (visible != null ? visible.value : this.visible),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Oauth {
  const Oauth({
    this.enabled,
    this.autoRegister,
    this.autoLogin,
    this.clientId,
    this.clientSecret,
    this.url,
    this.tokenurl,
  });

  factory Oauth.fromJson(Map<String, dynamic> json) => _$OauthFromJson(json);

  static const toJsonFactory = _$OauthToJson;
  Map<String, dynamic> toJson() => _$OauthToJson(this);

  @JsonKey(name: 'enabled')
  final bool? enabled;
  @JsonKey(name: 'autoRegister')
  final bool? autoRegister;
  @JsonKey(name: 'autoLogin')
  final bool? autoLogin;
  @JsonKey(name: 'clientId')
  final String? clientId;
  @JsonKey(name: 'clientSecret')
  final String? clientSecret;
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'tokenurl')
  final String? tokenurl;
  static const fromJsonFactory = _$OauthFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Oauth &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.autoRegister, autoRegister) ||
                const DeepCollectionEquality().equals(
                  other.autoRegister,
                  autoRegister,
                )) &&
            (identical(other.autoLogin, autoLogin) ||
                const DeepCollectionEquality().equals(
                  other.autoLogin,
                  autoLogin,
                )) &&
            (identical(other.clientId, clientId) ||
                const DeepCollectionEquality().equals(
                  other.clientId,
                  clientId,
                )) &&
            (identical(other.clientSecret, clientSecret) ||
                const DeepCollectionEquality().equals(
                  other.clientSecret,
                  clientSecret,
                )) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.tokenurl, tokenurl) ||
                const DeepCollectionEquality().equals(
                  other.tokenurl,
                  tokenurl,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(autoRegister) ^
      const DeepCollectionEquality().hash(autoLogin) ^
      const DeepCollectionEquality().hash(clientId) ^
      const DeepCollectionEquality().hash(clientSecret) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(tokenurl) ^
      runtimeType.hashCode;
}

extension $OauthExtension on Oauth {
  Oauth copyWith({
    bool? enabled,
    bool? autoRegister,
    bool? autoLogin,
    String? clientId,
    String? clientSecret,
    String? url,
    String? tokenurl,
  }) {
    return Oauth(
      enabled: enabled ?? this.enabled,
      autoRegister: autoRegister ?? this.autoRegister,
      autoLogin: autoLogin ?? this.autoLogin,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      url: url ?? this.url,
      tokenurl: tokenurl ?? this.tokenurl,
    );
  }

  Oauth copyWithWrapped({
    Wrapped<bool?>? enabled,
    Wrapped<bool?>? autoRegister,
    Wrapped<bool?>? autoLogin,
    Wrapped<String?>? clientId,
    Wrapped<String?>? clientSecret,
    Wrapped<String?>? url,
    Wrapped<String?>? tokenurl,
  }) {
    return Oauth(
      enabled: (enabled != null ? enabled.value : this.enabled),
      autoRegister: (autoRegister != null
          ? autoRegister.value
          : this.autoRegister),
      autoLogin: (autoLogin != null ? autoLogin.value : this.autoLogin),
      clientId: (clientId != null ? clientId.value : this.clientId),
      clientSecret: (clientSecret != null
          ? clientSecret.value
          : this.clientSecret),
      url: (url != null ? url.value : this.url),
      tokenurl: (tokenurl != null ? tokenurl.value : this.tokenurl),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Person {
  const Person({
    this.id,
    this.name,
    this.surname,
    this.identifier,
    this.birth,
    this.userName,
    this.password,
    this.type,
    this.email,
    this.phone,
    this.rights,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  static const toJsonFactory = _$PersonToJson;
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'surname')
  final String? surname;
  @JsonKey(name: 'identifier')
  final String? identifier;
  @JsonKey(name: 'birth')
  final DateTime? birth;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'rights', defaultValue: <Right>[])
  final List<Right>? rights;
  static const fromJsonFactory = _$PersonFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Person &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.surname, surname) ||
                const DeepCollectionEquality().equals(
                  other.surname,
                  surname,
                )) &&
            (identical(other.identifier, identifier) ||
                const DeepCollectionEquality().equals(
                  other.identifier,
                  identifier,
                )) &&
            (identical(other.birth, birth) ||
                const DeepCollectionEquality().equals(other.birth, birth)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality().equals(
                  other.userName,
                  userName,
                )) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.rights, rights) ||
                const DeepCollectionEquality().equals(other.rights, rights)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(surname) ^
      const DeepCollectionEquality().hash(identifier) ^
      const DeepCollectionEquality().hash(birth) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(rights) ^
      runtimeType.hashCode;
}

extension $PersonExtension on Person {
  Person copyWith({
    int? id,
    String? name,
    String? surname,
    String? identifier,
    DateTime? birth,
    String? userName,
    String? password,
    int? type,
    String? email,
    String? phone,
    List<Right>? rights,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      identifier: identifier ?? this.identifier,
      birth: birth ?? this.birth,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      type: type ?? this.type,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      rights: rights ?? this.rights,
    );
  }

  Person copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? surname,
    Wrapped<String?>? identifier,
    Wrapped<DateTime?>? birth,
    Wrapped<String?>? userName,
    Wrapped<String?>? password,
    Wrapped<int?>? type,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
    Wrapped<List<Right>?>? rights,
  }) {
    return Person(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      surname: (surname != null ? surname.value : this.surname),
      identifier: (identifier != null ? identifier.value : this.identifier),
      birth: (birth != null ? birth.value : this.birth),
      userName: (userName != null ? userName.value : this.userName),
      password: (password != null ? password.value : this.password),
      type: (type != null ? type.value : this.type),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
      rights: (rights != null ? rights.value : this.rights),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PersonCreation {
  const PersonCreation({
    this.name,
    this.surname,
    this.identifier,
    this.birth,
    this.userName,
    this.password,
    this.type,
    this.email,
    this.phone,
    this.rights,
  });

  factory PersonCreation.fromJson(Map<String, dynamic> json) =>
      _$PersonCreationFromJson(json);

  static const toJsonFactory = _$PersonCreationToJson;
  Map<String, dynamic> toJson() => _$PersonCreationToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'surname')
  final String? surname;
  @JsonKey(name: 'identifier')
  final String? identifier;
  @JsonKey(name: 'birth')
  final DateTime? birth;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'rights', defaultValue: <Right>[])
  final List<Right>? rights;
  static const fromJsonFactory = _$PersonCreationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PersonCreation &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.surname, surname) ||
                const DeepCollectionEquality().equals(
                  other.surname,
                  surname,
                )) &&
            (identical(other.identifier, identifier) ||
                const DeepCollectionEquality().equals(
                  other.identifier,
                  identifier,
                )) &&
            (identical(other.birth, birth) ||
                const DeepCollectionEquality().equals(other.birth, birth)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality().equals(
                  other.userName,
                  userName,
                )) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.rights, rights) ||
                const DeepCollectionEquality().equals(other.rights, rights)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(surname) ^
      const DeepCollectionEquality().hash(identifier) ^
      const DeepCollectionEquality().hash(birth) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(rights) ^
      runtimeType.hashCode;
}

extension $PersonCreationExtension on PersonCreation {
  PersonCreation copyWith({
    String? name,
    String? surname,
    String? identifier,
    DateTime? birth,
    String? userName,
    String? password,
    int? type,
    String? email,
    String? phone,
    List<Right>? rights,
  }) {
    return PersonCreation(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      identifier: identifier ?? this.identifier,
      birth: birth ?? this.birth,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      type: type ?? this.type,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      rights: rights ?? this.rights,
    );
  }

  PersonCreation copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? surname,
    Wrapped<String?>? identifier,
    Wrapped<DateTime?>? birth,
    Wrapped<String?>? userName,
    Wrapped<String?>? password,
    Wrapped<int?>? type,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
    Wrapped<List<Right>?>? rights,
  }) {
    return PersonCreation(
      name: (name != null ? name.value : this.name),
      surname: (surname != null ? surname.value : this.surname),
      identifier: (identifier != null ? identifier.value : this.identifier),
      birth: (birth != null ? birth.value : this.birth),
      userName: (userName != null ? userName.value : this.userName),
      password: (password != null ? password.value : this.password),
      type: (type != null ? type.value : this.type),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
      rights: (rights != null ? rights.value : this.rights),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Proxy {
  const Proxy({this.proxyAuth, this.autoRegister, this.header});

  factory Proxy.fromJson(Map<String, dynamic> json) => _$ProxyFromJson(json);

  static const toJsonFactory = _$ProxyToJson;
  Map<String, dynamic> toJson() => _$ProxyToJson(this);

  @JsonKey(name: 'proxyAuth')
  final bool? proxyAuth;
  @JsonKey(name: 'autoRegister')
  final bool? autoRegister;
  @JsonKey(name: 'header')
  final String? header;
  static const fromJsonFactory = _$ProxyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Proxy &&
            (identical(other.proxyAuth, proxyAuth) ||
                const DeepCollectionEquality().equals(
                  other.proxyAuth,
                  proxyAuth,
                )) &&
            (identical(other.autoRegister, autoRegister) ||
                const DeepCollectionEquality().equals(
                  other.autoRegister,
                  autoRegister,
                )) &&
            (identical(other.header, header) ||
                const DeepCollectionEquality().equals(other.header, header)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(proxyAuth) ^
      const DeepCollectionEquality().hash(autoRegister) ^
      const DeepCollectionEquality().hash(header) ^
      runtimeType.hashCode;
}

extension $ProxyExtension on Proxy {
  Proxy copyWith({bool? proxyAuth, bool? autoRegister, String? header}) {
    return Proxy(
      proxyAuth: proxyAuth ?? this.proxyAuth,
      autoRegister: autoRegister ?? this.autoRegister,
      header: header ?? this.header,
    );
  }

  Proxy copyWithWrapped({
    Wrapped<bool?>? proxyAuth,
    Wrapped<bool?>? autoRegister,
    Wrapped<String?>? header,
  }) {
    return Proxy(
      proxyAuth: (proxyAuth != null ? proxyAuth.value : this.proxyAuth),
      autoRegister: (autoRegister != null
          ? autoRegister.value
          : this.autoRegister),
      header: (header != null ? header.value : this.header),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Right {
  const Right({this.personId, this.userId, this.start, this.stop, this.type});

  factory Right.fromJson(Map<String, dynamic> json) => _$RightFromJson(json);

  static const toJsonFactory = _$RightToJson;
  Map<String, dynamic> toJson() => _$RightToJson(this);

  @JsonKey(name: 'personId')
  final int? personId;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'type')
  final int? type;
  static const fromJsonFactory = _$RightFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Right &&
            (identical(other.personId, personId) ||
                const DeepCollectionEquality().equals(
                  other.personId,
                  personId,
                )) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(personId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(type) ^
      runtimeType.hashCode;
}

extension $RightExtension on Right {
  Right copyWith({
    int? personId,
    int? userId,
    DateTime? start,
    DateTime? stop,
    int? type,
  }) {
    return Right(
      personId: personId ?? this.personId,
      userId: userId ?? this.userId,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      type: type ?? this.type,
    );
  }

  Right copyWithWrapped({
    Wrapped<int?>? personId,
    Wrapped<int?>? userId,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<int?>? type,
  }) {
    return Right(
      personId: (personId != null ? personId.value : this.personId),
      userId: (userId != null ? userId.value : this.userId),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      type: (type != null ? type.value : this.type),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Status {
  const Status({
    required this.init,
    required this.externalAuth,
    this.error,
    this.oauth,
    this.oauthId,
    required this.autoLogin,
  });

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  static const toJsonFactory = _$StatusToJson;
  Map<String, dynamic> toJson() => _$StatusToJson(this);

  @JsonKey(name: 'init')
  final bool init;
  @JsonKey(name: 'externalAuth')
  final bool externalAuth;
  @JsonKey(name: 'error')
  final String? error;
  @JsonKey(name: 'oauth')
  final String? oauth;
  @JsonKey(name: 'oauthId')
  final String? oauthId;
  @JsonKey(name: 'autoLogin')
  final bool autoLogin;
  static const fromJsonFactory = _$StatusFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Status &&
            (identical(other.init, init) ||
                const DeepCollectionEquality().equals(other.init, init)) &&
            (identical(other.externalAuth, externalAuth) ||
                const DeepCollectionEquality().equals(
                  other.externalAuth,
                  externalAuth,
                )) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.oauth, oauth) ||
                const DeepCollectionEquality().equals(other.oauth, oauth)) &&
            (identical(other.oauthId, oauthId) ||
                const DeepCollectionEquality().equals(
                  other.oauthId,
                  oauthId,
                )) &&
            (identical(other.autoLogin, autoLogin) ||
                const DeepCollectionEquality().equals(
                  other.autoLogin,
                  autoLogin,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(init) ^
      const DeepCollectionEquality().hash(externalAuth) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(oauth) ^
      const DeepCollectionEquality().hash(oauthId) ^
      const DeepCollectionEquality().hash(autoLogin) ^
      runtimeType.hashCode;
}

extension $StatusExtension on Status {
  Status copyWith({
    bool? init,
    bool? externalAuth,
    String? error,
    String? oauth,
    String? oauthId,
    bool? autoLogin,
  }) {
    return Status(
      init: init ?? this.init,
      externalAuth: externalAuth ?? this.externalAuth,
      error: error ?? this.error,
      oauth: oauth ?? this.oauth,
      oauthId: oauthId ?? this.oauthId,
      autoLogin: autoLogin ?? this.autoLogin,
    );
  }

  Status copyWithWrapped({
    Wrapped<bool>? init,
    Wrapped<bool>? externalAuth,
    Wrapped<String?>? error,
    Wrapped<String?>? oauth,
    Wrapped<String?>? oauthId,
    Wrapped<bool>? autoLogin,
  }) {
    return Status(
      init: (init != null ? init.value : this.init),
      externalAuth: (externalAuth != null
          ? externalAuth.value
          : this.externalAuth),
      error: (error != null ? error.value : this.error),
      oauth: (oauth != null ? oauth.value : this.oauth),
      oauthId: (oauthId != null ? oauthId.value : this.oauthId),
      autoLogin: (autoLogin != null ? autoLogin.value : this.autoLogin),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TokenResponse {
  const TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  static const toJsonFactory = _$TokenResponseToJson;
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @JsonKey(name: 'accessToken')
  final String accessToken;
  @JsonKey(name: 'refreshToken')
  final String refreshToken;
  static const fromJsonFactory = _$TokenResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TokenResponse &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      runtimeType.hashCode;
}

extension $TokenResponseExtension on TokenResponse {
  TokenResponse copyWith({String? accessToken, String? refreshToken}) {
    return TokenResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  TokenResponse copyWithWrapped({
    Wrapped<String>? accessToken,
    Wrapped<String>? refreshToken,
  }) {
    return TokenResponse(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Treatement {
  const Treatement({this.events, this.type});

  factory Treatement.fromJson(Map<String, dynamic> json) =>
      _$TreatementFromJson(json);

  static const toJsonFactory = _$TreatementToJson;
  Map<String, dynamic> toJson() => _$TreatementToJson(this);

  @JsonKey(name: 'events', defaultValue: <Event>[])
  final List<Event>? events;
  @JsonKey(name: 'type')
  final int? type;
  static const fromJsonFactory = _$TreatementFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Treatement &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(events) ^
      const DeepCollectionEquality().hash(type) ^
      runtimeType.hashCode;
}

extension $TreatementExtension on Treatement {
  Treatement copyWith({List<Event>? events, int? type}) {
    return Treatement(events: events ?? this.events, type: type ?? this.type);
  }

  Treatement copyWithWrapped({
    Wrapped<List<Event>?>? events,
    Wrapped<int?>? type,
  }) {
    return Treatement(
      events: (events != null ? events.value : this.events),
      type: (type != null ? type.value : this.type),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateEvent {
  const UpdateEvent({
    this.id,
    this.type,
    this.description,
    this.start,
    this.stop,
    this.tag,
  });

  factory UpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventFromJson(json);

  static const toJsonFactory = _$UpdateEventToJson;
  Map<String, dynamic> toJson() => _$UpdateEventToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'tag')
  final String? tag;
  static const fromJsonFactory = _$UpdateEventFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateEvent &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(tag) ^
      runtimeType.hashCode;
}

extension $UpdateEventExtension on UpdateEvent {
  UpdateEvent copyWith({
    int? id,
    int? type,
    String? description,
    DateTime? start,
    DateTime? stop,
    String? tag,
  }) {
    return UpdateEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
    );
  }

  UpdateEvent copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String?>? tag,
  }) {
    return UpdateEvent(
      id: (id != null ? id.value : this.id),
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      tag: (tag != null ? tag.value : this.tag),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateMetric {
  const UpdateMetric({
    this.id,
    this.date,
    required this.value,
    this.tag,
    this.type,
    this.source,
  });

  factory UpdateMetric.fromJson(Map<String, dynamic> json) =>
      _$UpdateMetricFromJson(json);

  static const toJsonFactory = _$UpdateMetricToJson;
  Map<String, dynamic> toJson() => _$UpdateMetricToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'source')
  final int? source;
  static const fromJsonFactory = _$UpdateMetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateMetric &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      runtimeType.hashCode;
}

extension $UpdateMetricExtension on UpdateMetric {
  UpdateMetric copyWith({
    int? id,
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    int? source,
  }) {
    return UpdateMetric(
      id: id ?? this.id,
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
    );
  }

  UpdateMetric copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<DateTime?>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int?>? type,
    Wrapped<int?>? source,
  }) {
    return UpdateMetric(
      id: (id != null ? id.value : this.id),
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
    );
  }
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body:
            DateTime.parse((response.body as String).replaceAll('"', ''))
                as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
