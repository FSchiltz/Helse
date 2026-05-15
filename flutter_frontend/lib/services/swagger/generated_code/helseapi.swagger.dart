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
import 'helseapi.enums.swagger.dart' as enums;
import 'helseapi.metadata.swagger.dart';
export 'helseapi.enums.swagger.dart';

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
  Future<chopper.Response> apiPersonPut({required UpdatePerson? body}) {
    return _apiPersonPut(body: body);
  }

  ///
  @PUT(path: '/api/person', optionalBody: true)
  Future<chopper.Response> _apiPersonPut({
    @Body() required UpdatePerson? body,
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
  ///@param userId
  Future<chopper.Response> apiPersonPersonIdDelete({required int? userId}) {
    return _apiPersonPersonIdDelete(userId: userId);
  }

  ///
  ///@param userId
  @DELETE(path: '/api/person/{personId}')
  Future<chopper.Response> _apiPersonPersonIdDelete({
    @Query('userId') required int? userId,
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
  Future<chopper.Response> apiPatientsPut({required UpdatePatient? body}) {
    return _apiPatientsPut(body: body);
  }

  ///
  @PUT(path: '/api/patients', optionalBody: true)
  Future<chopper.Response> _apiPatientsPut({
    @Body() required UpdatePatient? body,
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
  ///@param group
  Future<chopper.Response<List<MetricType>>> apiMetricsTypeGet({
    bool? all,
    int? group,
  }) {
    generatedMapping.putIfAbsent(MetricType, () => MetricType.fromJsonFactory);

    return _apiMetricsTypeGet(all: all, group: group);
  }

  ///
  ///@param all
  ///@param group
  @GET(path: '/api/metrics/type')
  Future<chopper.Response<List<MetricType>>> _apiMetricsTypeGet({
    @Query('all') bool? all,
    @Query('group') int? group,
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
  Future<chopper.Response> apiMetricsTypeGroupsPost({
    required MetricGroup? body,
  }) {
    return _apiMetricsTypeGroupsPost(body: body);
  }

  ///
  @POST(path: '/api/metrics/type/groups', optionalBody: true)
  Future<chopper.Response> _apiMetricsTypeGroupsPost({
    @Body() required MetricGroup? body,
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
  Future<chopper.Response> apiMetricsTypeGroupsPut({
    required MetricGroup? body,
  }) {
    return _apiMetricsTypeGroupsPut(body: body);
  }

  ///
  @PUT(path: '/api/metrics/type/groups', optionalBody: true)
  Future<chopper.Response> _apiMetricsTypeGroupsPut({
    @Body() required MetricGroup? body,
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
  Future<chopper.Response<List<MetricGroup>>> apiMetricsTypeGroupsGet() {
    generatedMapping.putIfAbsent(
      MetricGroup,
      () => MetricGroup.fromJsonFactory,
    );

    return _apiMetricsTypeGroupsGet();
  }

  ///
  @GET(path: '/api/metrics/type/groups')
  Future<chopper.Response<List<MetricGroup>>> _apiMetricsTypeGroupsGet({
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
  Future<chopper.Response> apiMetricsTypeGroupsIdDelete({required int? id}) {
    return _apiMetricsTypeGroupsIdDelete(id: id);
  }

  ///
  ///@param id
  @DELETE(path: '/api/metrics/type/groups/{id}')
  Future<chopper.Response> _apiMetricsTypeGroupsIdDelete({
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
  Future<chopper.Response<List<Treatment>>> apiTreatmentGet({
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Treatment, () => Treatment.fromJsonFactory);

    return _apiTreatmentGet(start: start, end: end, personId: personId);
  }

  ///
  ///@param start
  ///@param end
  ///@param personId
  @GET(path: '/api/treatment')
  Future<chopper.Response<List<Treatment>>> _apiTreatmentGet({
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
  Future<chopper.Response> apiAdminSettingsSmtpPost({required Smtp? body}) {
    return _apiAdminSettingsSmtpPost(body: body);
  }

  ///
  @POST(path: '/api/admin/settings/smtp', optionalBody: true)
  Future<chopper.Response> _apiAdminSettingsSmtpPost({
    @Body() required Smtp? body,
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
  Future<chopper.Response<Smtp>> apiAdminSettingsSmtpGet() {
    generatedMapping.putIfAbsent(Smtp, () => Smtp.fromJsonFactory);

    return _apiAdminSettingsSmtpGet();
  }

  ///
  @GET(path: '/api/admin/settings/smtp')
  Future<chopper.Response<Smtp>> _apiAdminSettingsSmtpGet({
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
  Future<chopper.Response<Gotify>> apiAdminSettingsGotifyGet() {
    generatedMapping.putIfAbsent(Gotify, () => Gotify.fromJsonFactory);

    return _apiAdminSettingsGotifyGet();
  }

  ///
  @GET(path: '/api/admin/settings/gotify')
  Future<chopper.Response<Gotify>> _apiAdminSettingsGotifyGet({
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
  Future<chopper.Response> apiAdminSettingsGotifyPost({required Gotify? body}) {
    return _apiAdminSettingsGotifyPost(body: body);
  }

  ///
  @POST(path: '/api/admin/settings/gotify', optionalBody: true)
  Future<chopper.Response> _apiAdminSettingsGotifyPost({
    @Body() required Gotify? body,
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
  Future<chopper.Response<UserStats>> apiAdminStatsUsersGet() {
    generatedMapping.putIfAbsent(UserStats, () => UserStats.fromJsonFactory);

    return _apiAdminStatsUsersGet();
  }

  ///
  @GET(path: '/api/admin/stats/users')
  Future<chopper.Response<UserStats>> _apiAdminStatsUsersGet({
    @chopper.Tag()
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
  });

  ///
  ///@param start
  ///@param end
  Future<chopper.Response<EventStats>> apiAdminStatsEventsGet({
    required DateTime? start,
    required DateTime? end,
  }) {
    generatedMapping.putIfAbsent(EventStats, () => EventStats.fromJsonFactory);

    return _apiAdminStatsEventsGet(start: start, end: end);
  }

  ///
  ///@param start
  ///@param end
  @GET(path: '/api/admin/stats/events')
  Future<chopper.Response<EventStats>> _apiAdminStatsEventsGet({
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
      tags: ["AdminLogic"],
      deprecated: false,
    ),
  });

  ///
  ///@param start
  ///@param end
  Future<chopper.Response<EventStats>> apiAdminStatsMetricsGet({
    required DateTime? start,
    required DateTime? end,
  }) {
    generatedMapping.putIfAbsent(EventStats, () => EventStats.fromJsonFactory);

    return _apiAdminStatsMetricsGet(start: start, end: end);
  }

  ///
  ///@param start
  ///@param end
  @GET(path: '/api/admin/stats/metrics')
  Future<chopper.Response<EventStats>> _apiAdminStatsMetricsGet({
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
      tags: ["AdminLogic"],
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
    required dynamic file,
  }) {
    return _apiImportTypePost(type: type, file: file);
  }

  ///
  ///@param type
  @POST(path: '/api/import/{type}', optionalBody: true)
  @Multipart()
  Future<chopper.Response> _apiImportTypePost({
    @Path('type') required int? type,
    @Part('file') required dynamic file,
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
  const Connection({
    required this.user,
    required this.password,
    this.issuer,
    this.redirect,
  });

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);

  static const toJsonFactory = _$ConnectionToJson;
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);

  @JsonKey(name: 'user')
  final String user;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'issuer')
  final String? issuer;
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
            (identical(other.issuer, issuer) ||
                const DeepCollectionEquality().equals(other.issuer, issuer)) &&
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
      const DeepCollectionEquality().hash(issuer) ^
      const DeepCollectionEquality().hash(redirect) ^
      runtimeType.hashCode;
}

extension $ConnectionExtension on Connection {
  Connection copyWith({
    String? user,
    String? password,
    String? issuer,
    String? redirect,
  }) {
    return Connection(
      user: user ?? this.user,
      password: password ?? this.password,
      issuer: issuer ?? this.issuer,
      redirect: redirect ?? this.redirect,
    );
  }

  Connection copyWithWrapped({
    Wrapped<String>? user,
    Wrapped<String>? password,
    Wrapped<String?>? issuer,
    Wrapped<String?>? redirect,
  }) {
    return Connection(
      user: (user != null ? user.value : this.user),
      password: (password != null ? password.value : this.password),
      issuer: (issuer != null ? issuer.value : this.issuer),
      redirect: (redirect != null ? redirect.value : this.redirect),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CountByDate {
  const CountByDate({required this.date, required this.count});

  factory CountByDate.fromJson(Map<String, dynamic> json) =>
      _$CountByDateFromJson(json);

  static const toJsonFactory = _$CountByDateToJson;
  Map<String, dynamic> toJson() => _$CountByDateToJson(this);

  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'count')
  final int count;
  static const fromJsonFactory = _$CountByDateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CountByDate &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.count, count) ||
                const DeepCollectionEquality().equals(other.count, count)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(count) ^
      runtimeType.hashCode;
}

extension $CountByDateExtension on CountByDate {
  CountByDate copyWith({DateTime? date, int? count}) {
    return CountByDate(date: date ?? this.date, count: count ?? this.count);
  }

  CountByDate copyWithWrapped({Wrapped<DateTime>? date, Wrapped<int>? count}) {
    return CountByDate(
      date: (date != null ? date.value : this.date),
      count: (count != null ? count.value : this.count),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CountRecord {
  const CountRecord({required this.id, required this.count});

  factory CountRecord.fromJson(Map<String, dynamic> json) =>
      _$CountRecordFromJson(json);

  static const toJsonFactory = _$CountRecordToJson;
  Map<String, dynamic> toJson() => _$CountRecordToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'count')
  final int count;
  static const fromJsonFactory = _$CountRecordFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CountRecord &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.count, count) ||
                const DeepCollectionEquality().equals(other.count, count)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(count) ^
      runtimeType.hashCode;
}

extension $CountRecordExtension on CountRecord {
  CountRecord copyWith({String? id, int? count}) {
    return CountRecord(id: id ?? this.id, count: count ?? this.count);
  }

  CountRecord copyWithWrapped({Wrapped<String>? id, Wrapped<int>? count}) {
    return CountRecord(
      id: (id != null ? id.value : this.id),
      count: (count != null ? count.value : this.count),
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
    this.notificationTime,
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
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
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
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.notificationTime, notificationTime) ||
                const DeepCollectionEquality().equals(
                  other.notificationTime,
                  notificationTime,
                )));
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
      const DeepCollectionEquality().hash(notificationTime) ^
      runtimeType.hashCode;
}

extension $CreateEventExtension on CreateEvent {
  CreateEvent copyWith({
    int? type,
    String? description,
    DateTime? start,
    DateTime? stop,
    String? tag,
    DateTime? notificationTime,
  }) {
    return CreateEvent(
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }

  CreateEvent copyWithWrapped({
    Wrapped<int?>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String?>? tag,
    Wrapped<DateTime?>? notificationTime,
  }) {
    return CreateEvent(
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      tag: (tag != null ? tag.value : this.tag),
      notificationTime: (notificationTime != null
          ? notificationTime.value
          : this.notificationTime),
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
  @JsonKey(
    name: 'source',
    toJson: fileTypesNullableToJson,
    fromJson: fileTypesNullableFromJson,
  )
  final enums.FileTypes? source;
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
    enums.FileTypes? source,
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
    Wrapped<enums.FileTypes?>? source,
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
    this.notificationTime,
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
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
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
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.notificationTime, notificationTime) ||
                const DeepCollectionEquality().equals(
                  other.notificationTime,
                  notificationTime,
                )));
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
      const DeepCollectionEquality().hash(notificationTime) ^
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
    DateTime? notificationTime,
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
      notificationTime: notificationTime ?? this.notificationTime,
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
    Wrapped<DateTime?>? notificationTime,
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
      notificationTime: (notificationTime != null
          ? notificationTime.value
          : this.notificationTime),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class EventStats {
  const EventStats({required this.events, required this.eventCounts});

  factory EventStats.fromJson(Map<String, dynamic> json) =>
      _$EventStatsFromJson(json);

  static const toJsonFactory = _$EventStatsToJson;
  Map<String, dynamic> toJson() => _$EventStatsToJson(this);

  @JsonKey(name: 'events', defaultValue: <CountByDate>[])
  final List<CountByDate> events;
  @JsonKey(name: 'eventCounts', defaultValue: <CountRecord>[])
  final List<CountRecord> eventCounts;
  static const fromJsonFactory = _$EventStatsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventStats &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)) &&
            (identical(other.eventCounts, eventCounts) ||
                const DeepCollectionEquality().equals(
                  other.eventCounts,
                  eventCounts,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(events) ^
      const DeepCollectionEquality().hash(eventCounts) ^
      runtimeType.hashCode;
}

extension $EventStatsExtension on EventStats {
  EventStats copyWith({
    List<CountByDate>? events,
    List<CountRecord>? eventCounts,
  }) {
    return EventStats(
      events: events ?? this.events,
      eventCounts: eventCounts ?? this.eventCounts,
    );
  }

  EventStats copyWithWrapped({
    Wrapped<List<CountByDate>>? events,
    Wrapped<List<CountRecord>>? eventCounts,
  }) {
    return EventStats(
      events: (events != null ? events.value : this.events),
      eventCounts: (eventCounts != null ? eventCounts.value : this.eventCounts),
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
class Gotify {
  const Gotify({this.enabled, this.url, this.token});

  factory Gotify.fromJson(Map<String, dynamic> json) => _$GotifyFromJson(json);

  static const toJsonFactory = _$GotifyToJson;
  Map<String, dynamic> toJson() => _$GotifyToJson(this);

  @JsonKey(name: 'enabled')
  final bool? enabled;
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'token')
  final String? token;
  static const fromJsonFactory = _$GotifyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Gotify &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(token) ^
      runtimeType.hashCode;
}

extension $GotifyExtension on Gotify {
  Gotify copyWith({bool? enabled, String? url, String? token}) {
    return Gotify(
      enabled: enabled ?? this.enabled,
      url: url ?? this.url,
      token: token ?? this.token,
    );
  }

  Gotify copyWithWrapped({
    Wrapped<bool?>? enabled,
    Wrapped<String?>? url,
    Wrapped<String?>? token,
  }) {
    return Gotify(
      enabled: (enabled != null ? enabled.value : this.enabled),
      url: (url != null ? url.value : this.url),
      token: (token != null ? token.value : this.token),
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
  @JsonKey(
    name: 'source',
    toJson: fileTypesNullableToJson,
    fromJson: fileTypesNullableFromJson,
  )
  final enums.FileTypes? source;
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
    enums.FileTypes? source,
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
    Wrapped<enums.FileTypes?>? source,
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
class MetricGroup {
  const MetricGroup({
    required this.name,
    required this.description,
    this.showOnDashboard,
    this.showTitle,
    this.id,
  });

  factory MetricGroup.fromJson(Map<String, dynamic> json) =>
      _$MetricGroupFromJson(json);

  static const toJsonFactory = _$MetricGroupToJson;
  Map<String, dynamic> toJson() => _$MetricGroupToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'showTitle')
  final bool? showTitle;
  @JsonKey(name: 'id')
  final int? id;
  static const fromJsonFactory = _$MetricGroupFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MetricGroup &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.showOnDashboard, showOnDashboard) ||
                const DeepCollectionEquality().equals(
                  other.showOnDashboard,
                  showOnDashboard,
                )) &&
            (identical(other.showTitle, showTitle) ||
                const DeepCollectionEquality().equals(
                  other.showTitle,
                  showTitle,
                )) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(showTitle) ^
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $MetricGroupExtension on MetricGroup {
  MetricGroup copyWith({
    String? name,
    String? description,
    bool? showOnDashboard,
    bool? showTitle,
    int? id,
  }) {
    return MetricGroup(
      name: name ?? this.name,
      description: description ?? this.description,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      showTitle: showTitle ?? this.showTitle,
      id: id ?? this.id,
    );
  }

  MetricGroup copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String>? description,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<bool?>? showTitle,
    Wrapped<int?>? id,
  }) {
    return MetricGroup(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      showTitle: (showTitle != null ? showTitle.value : this.showTitle),
      id: (id != null ? id.value : this.id),
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
    this.showOnDashboard,
    this.groupId,
  });

  factory MetricType.fromJson(Map<String, dynamic> json) =>
      _$MetricTypeFromJson(json);

  static const toJsonFactory = _$MetricTypeToJson;
  Map<String, dynamic> toJson() => _$MetricTypeToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'unit')
  final String? unit;
  @JsonKey(
    name: 'summaryType',
    toJson: metricSummaryNullableToJson,
    fromJson: metricSummaryNullableFromJson,
  )
  final enums.MetricSummary? summaryType;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(
    name: 'type',
    toJson: metricDataTypeNullableToJson,
    fromJson: metricDataTypeNullableFromJson,
  )
  final enums.MetricDataType? type;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'userEditable')
  final bool? userEditable;
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'groupId')
  final int? groupId;
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
                const DeepCollectionEquality().equals(
                  other.visible,
                  visible,
                )) &&
            (identical(other.showOnDashboard, showOnDashboard) ||
                const DeepCollectionEquality().equals(
                  other.showOnDashboard,
                  showOnDashboard,
                )) &&
            (identical(other.groupId, groupId) ||
                const DeepCollectionEquality().equals(other.groupId, groupId)));
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
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(groupId) ^
      runtimeType.hashCode;
}

extension $MetricTypeExtension on MetricType {
  MetricType copyWith({
    String? name,
    String? unit,
    enums.MetricSummary? summaryType,
    String? description,
    enums.MetricDataType? type,
    int? id,
    bool? userEditable,
    bool? visible,
    bool? showOnDashboard,
    int? groupId,
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
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      groupId: groupId ?? this.groupId,
    );
  }

  MetricType copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? unit,
    Wrapped<enums.MetricSummary?>? summaryType,
    Wrapped<String?>? description,
    Wrapped<enums.MetricDataType?>? type,
    Wrapped<int?>? id,
    Wrapped<bool?>? userEditable,
    Wrapped<bool?>? visible,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<int?>? groupId,
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
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      groupId: (groupId != null ? groupId.value : this.groupId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Oauth {
  const Oauth({this.enabled, this.providers});

  factory Oauth.fromJson(Map<String, dynamic> json) => _$OauthFromJson(json);

  static const toJsonFactory = _$OauthToJson;
  Map<String, dynamic> toJson() => _$OauthToJson(this);

  @JsonKey(name: 'enabled')
  final bool? enabled;
  @JsonKey(name: 'providers', defaultValue: <OauthProvider>[])
  final List<OauthProvider>? providers;
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
            (identical(other.providers, providers) ||
                const DeepCollectionEquality().equals(
                  other.providers,
                  providers,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(providers) ^
      runtimeType.hashCode;
}

extension $OauthExtension on Oauth {
  Oauth copyWith({bool? enabled, List<OauthProvider>? providers}) {
    return Oauth(
      enabled: enabled ?? this.enabled,
      providers: providers ?? this.providers,
    );
  }

  Oauth copyWithWrapped({
    Wrapped<bool?>? enabled,
    Wrapped<List<OauthProvider>?>? providers,
  }) {
    return Oauth(
      enabled: (enabled != null ? enabled.value : this.enabled),
      providers: (providers != null ? providers.value : this.providers),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OauthConnection {
  const OauthConnection({
    required this.name,
    required this.url,
    required this.clientId,
    required this.autoLogin,
  });

  factory OauthConnection.fromJson(Map<String, dynamic> json) =>
      _$OauthConnectionFromJson(json);

  static const toJsonFactory = _$OauthConnectionToJson;
  Map<String, dynamic> toJson() => _$OauthConnectionToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'clientId')
  final String clientId;
  @JsonKey(name: 'autoLogin')
  final bool autoLogin;
  static const fromJsonFactory = _$OauthConnectionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OauthConnection &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.clientId, clientId) ||
                const DeepCollectionEquality().equals(
                  other.clientId,
                  clientId,
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
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(clientId) ^
      const DeepCollectionEquality().hash(autoLogin) ^
      runtimeType.hashCode;
}

extension $OauthConnectionExtension on OauthConnection {
  OauthConnection copyWith({
    String? name,
    String? url,
    String? clientId,
    bool? autoLogin,
  }) {
    return OauthConnection(
      name: name ?? this.name,
      url: url ?? this.url,
      clientId: clientId ?? this.clientId,
      autoLogin: autoLogin ?? this.autoLogin,
    );
  }

  OauthConnection copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String>? url,
    Wrapped<String>? clientId,
    Wrapped<bool>? autoLogin,
  }) {
    return OauthConnection(
      name: (name != null ? name.value : this.name),
      url: (url != null ? url.value : this.url),
      clientId: (clientId != null ? clientId.value : this.clientId),
      autoLogin: (autoLogin != null ? autoLogin.value : this.autoLogin),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OauthProvider {
  const OauthProvider({
    required this.name,
    this.autoRegister,
    this.autoLogin,
    required this.clientId,
    required this.clientSecret,
    required this.url,
    required this.tokenurl,
    required this.claimsUrl,
  });

  factory OauthProvider.fromJson(Map<String, dynamic> json) =>
      _$OauthProviderFromJson(json);

  static const toJsonFactory = _$OauthProviderToJson;
  Map<String, dynamic> toJson() => _$OauthProviderToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'autoRegister')
  final bool? autoRegister;
  @JsonKey(name: 'autoLogin')
  final bool? autoLogin;
  @JsonKey(name: 'clientId')
  final String clientId;
  @JsonKey(name: 'clientSecret')
  final String clientSecret;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'tokenurl')
  final String tokenurl;
  @JsonKey(name: 'claimsUrl')
  final String claimsUrl;
  static const fromJsonFactory = _$OauthProviderFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OauthProvider &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
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
                )) &&
            (identical(other.claimsUrl, claimsUrl) ||
                const DeepCollectionEquality().equals(
                  other.claimsUrl,
                  claimsUrl,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(autoRegister) ^
      const DeepCollectionEquality().hash(autoLogin) ^
      const DeepCollectionEquality().hash(clientId) ^
      const DeepCollectionEquality().hash(clientSecret) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(tokenurl) ^
      const DeepCollectionEquality().hash(claimsUrl) ^
      runtimeType.hashCode;
}

extension $OauthProviderExtension on OauthProvider {
  OauthProvider copyWith({
    String? name,
    bool? autoRegister,
    bool? autoLogin,
    String? clientId,
    String? clientSecret,
    String? url,
    String? tokenurl,
    String? claimsUrl,
  }) {
    return OauthProvider(
      name: name ?? this.name,
      autoRegister: autoRegister ?? this.autoRegister,
      autoLogin: autoLogin ?? this.autoLogin,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      url: url ?? this.url,
      tokenurl: tokenurl ?? this.tokenurl,
      claimsUrl: claimsUrl ?? this.claimsUrl,
    );
  }

  OauthProvider copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<bool?>? autoRegister,
    Wrapped<bool?>? autoLogin,
    Wrapped<String>? clientId,
    Wrapped<String>? clientSecret,
    Wrapped<String>? url,
    Wrapped<String>? tokenurl,
    Wrapped<String>? claimsUrl,
  }) {
    return OauthProvider(
      name: (name != null ? name.value : this.name),
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
      claimsUrl: (claimsUrl != null ? claimsUrl.value : this.claimsUrl),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Person {
  const Person({
    this.id,
    this.userName,
    this.rights,
    this.types,
    this.created,
    this.name,
    this.surname,
    this.identifier,
    this.birth,
    this.profilePicture,
    this.email,
    this.phone,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  static const toJsonFactory = _$PersonToJson;
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'rights', defaultValue: <Right>[])
  final List<Right>? rights;
  @JsonKey(
    name: 'types',
    toJson: userTypeListToJson,
    fromJson: userTypeListFromJson,
  )
  final List<enums.UserType>? types;
  @JsonKey(name: 'created')
  final DateTime? created;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'surname')
  final String? surname;
  @JsonKey(name: 'identifier')
  final String? identifier;
  @JsonKey(name: 'birth')
  final DateTime? birth;
  @JsonKey(name: 'profilePicture')
  final String? profilePicture;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  static const fromJsonFactory = _$PersonFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Person &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality().equals(
                  other.userName,
                  userName,
                )) &&
            (identical(other.rights, rights) ||
                const DeepCollectionEquality().equals(other.rights, rights)) &&
            (identical(other.types, types) ||
                const DeepCollectionEquality().equals(other.types, types)) &&
            (identical(other.created, created) ||
                const DeepCollectionEquality().equals(
                  other.created,
                  created,
                )) &&
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
            (identical(other.profilePicture, profilePicture) ||
                const DeepCollectionEquality().equals(
                  other.profilePicture,
                  profilePicture,
                )) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(rights) ^
      const DeepCollectionEquality().hash(types) ^
      const DeepCollectionEquality().hash(created) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(surname) ^
      const DeepCollectionEquality().hash(identifier) ^
      const DeepCollectionEquality().hash(birth) ^
      const DeepCollectionEquality().hash(profilePicture) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      runtimeType.hashCode;
}

extension $PersonExtension on Person {
  Person copyWith({
    int? id,
    String? userName,
    List<Right>? rights,
    List<enums.UserType>? types,
    DateTime? created,
    String? name,
    String? surname,
    String? identifier,
    DateTime? birth,
    String? profilePicture,
    String? email,
    String? phone,
  }) {
    return Person(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      rights: rights ?? this.rights,
      types: types ?? this.types,
      created: created ?? this.created,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      identifier: identifier ?? this.identifier,
      birth: birth ?? this.birth,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Person copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String?>? userName,
    Wrapped<List<Right>?>? rights,
    Wrapped<List<enums.UserType>?>? types,
    Wrapped<DateTime?>? created,
    Wrapped<String?>? name,
    Wrapped<String?>? surname,
    Wrapped<String?>? identifier,
    Wrapped<DateTime?>? birth,
    Wrapped<String?>? profilePicture,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
  }) {
    return Person(
      id: (id != null ? id.value : this.id),
      userName: (userName != null ? userName.value : this.userName),
      rights: (rights != null ? rights.value : this.rights),
      types: (types != null ? types.value : this.types),
      created: (created != null ? created.value : this.created),
      name: (name != null ? name.value : this.name),
      surname: (surname != null ? surname.value : this.surname),
      identifier: (identifier != null ? identifier.value : this.identifier),
      birth: (birth != null ? birth.value : this.birth),
      profilePicture: (profilePicture != null
          ? profilePicture.value
          : this.profilePicture),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PersonCreation {
  const PersonCreation({
    this.userName,
    this.password,
    this.types,
    this.name,
    this.surname,
    this.identifier,
    this.birth,
    this.profilePicture,
    this.email,
    this.phone,
  });

  factory PersonCreation.fromJson(Map<String, dynamic> json) =>
      _$PersonCreationFromJson(json);

  static const toJsonFactory = _$PersonCreationToJson;
  Map<String, dynamic> toJson() => _$PersonCreationToJson(this);

  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(
    name: 'types',
    toJson: userTypeListToJson,
    fromJson: userTypeListFromJson,
  )
  final List<enums.UserType>? types;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'surname')
  final String? surname;
  @JsonKey(name: 'identifier')
  final String? identifier;
  @JsonKey(name: 'birth')
  final DateTime? birth;
  @JsonKey(name: 'profilePicture')
  final String? profilePicture;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  static const fromJsonFactory = _$PersonCreationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PersonCreation &&
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
            (identical(other.types, types) ||
                const DeepCollectionEquality().equals(other.types, types)) &&
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
            (identical(other.profilePicture, profilePicture) ||
                const DeepCollectionEquality().equals(
                  other.profilePicture,
                  profilePicture,
                )) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(types) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(surname) ^
      const DeepCollectionEquality().hash(identifier) ^
      const DeepCollectionEquality().hash(birth) ^
      const DeepCollectionEquality().hash(profilePicture) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      runtimeType.hashCode;
}

extension $PersonCreationExtension on PersonCreation {
  PersonCreation copyWith({
    String? userName,
    String? password,
    List<enums.UserType>? types,
    String? name,
    String? surname,
    String? identifier,
    DateTime? birth,
    String? profilePicture,
    String? email,
    String? phone,
  }) {
    return PersonCreation(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      types: types ?? this.types,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      identifier: identifier ?? this.identifier,
      birth: birth ?? this.birth,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  PersonCreation copyWithWrapped({
    Wrapped<String?>? userName,
    Wrapped<String?>? password,
    Wrapped<List<enums.UserType>?>? types,
    Wrapped<String?>? name,
    Wrapped<String?>? surname,
    Wrapped<String?>? identifier,
    Wrapped<DateTime?>? birth,
    Wrapped<String?>? profilePicture,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
  }) {
    return PersonCreation(
      userName: (userName != null ? userName.value : this.userName),
      password: (password != null ? password.value : this.password),
      types: (types != null ? types.value : this.types),
      name: (name != null ? name.value : this.name),
      surname: (surname != null ? surname.value : this.surname),
      identifier: (identifier != null ? identifier.value : this.identifier),
      birth: (birth != null ? birth.value : this.birth),
      profilePicture: (profilePicture != null
          ? profilePicture.value
          : this.profilePicture),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
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
  @JsonKey(
    name: 'type',
    toJson: rightTypeNullableToJson,
    fromJson: rightTypeNullableFromJson,
  )
  final enums.RightType? type;
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
    enums.RightType? type,
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
    Wrapped<enums.RightType?>? type,
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
class Smtp {
  const Smtp({
    this.enabled,
    this.smtpHost,
    this.smtpPort,
    this.enableSsl,
    this.fromEmail,
    this.userName,
    this.password,
  });

  factory Smtp.fromJson(Map<String, dynamic> json) => _$SmtpFromJson(json);

  static const toJsonFactory = _$SmtpToJson;
  Map<String, dynamic> toJson() => _$SmtpToJson(this);

  @JsonKey(name: 'enabled')
  final bool? enabled;
  @JsonKey(name: 'smtpHost')
  final String? smtpHost;
  @JsonKey(name: 'smtpPort')
  final int? smtpPort;
  @JsonKey(name: 'enableSsl')
  final bool? enableSsl;
  @JsonKey(name: 'fromEmail')
  final String? fromEmail;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'password')
  final String? password;
  static const fromJsonFactory = _$SmtpFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Smtp &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.smtpHost, smtpHost) ||
                const DeepCollectionEquality().equals(
                  other.smtpHost,
                  smtpHost,
                )) &&
            (identical(other.smtpPort, smtpPort) ||
                const DeepCollectionEquality().equals(
                  other.smtpPort,
                  smtpPort,
                )) &&
            (identical(other.enableSsl, enableSsl) ||
                const DeepCollectionEquality().equals(
                  other.enableSsl,
                  enableSsl,
                )) &&
            (identical(other.fromEmail, fromEmail) ||
                const DeepCollectionEquality().equals(
                  other.fromEmail,
                  fromEmail,
                )) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality().equals(
                  other.userName,
                  userName,
                )) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(smtpHost) ^
      const DeepCollectionEquality().hash(smtpPort) ^
      const DeepCollectionEquality().hash(enableSsl) ^
      const DeepCollectionEquality().hash(fromEmail) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $SmtpExtension on Smtp {
  Smtp copyWith({
    bool? enabled,
    String? smtpHost,
    int? smtpPort,
    bool? enableSsl,
    String? fromEmail,
    String? userName,
    String? password,
  }) {
    return Smtp(
      enabled: enabled ?? this.enabled,
      smtpHost: smtpHost ?? this.smtpHost,
      smtpPort: smtpPort ?? this.smtpPort,
      enableSsl: enableSsl ?? this.enableSsl,
      fromEmail: fromEmail ?? this.fromEmail,
      userName: userName ?? this.userName,
      password: password ?? this.password,
    );
  }

  Smtp copyWithWrapped({
    Wrapped<bool?>? enabled,
    Wrapped<String?>? smtpHost,
    Wrapped<int?>? smtpPort,
    Wrapped<bool?>? enableSsl,
    Wrapped<String?>? fromEmail,
    Wrapped<String?>? userName,
    Wrapped<String?>? password,
  }) {
    return Smtp(
      enabled: (enabled != null ? enabled.value : this.enabled),
      smtpHost: (smtpHost != null ? smtpHost.value : this.smtpHost),
      smtpPort: (smtpPort != null ? smtpPort.value : this.smtpPort),
      enableSsl: (enableSsl != null ? enableSsl.value : this.enableSsl),
      fromEmail: (fromEmail != null ? fromEmail.value : this.fromEmail),
      userName: (userName != null ? userName.value : this.userName),
      password: (password != null ? password.value : this.password),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Status {
  const Status({
    required this.init,
    required this.externalAuth,
    this.error,
    required this.oauths,
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
  @JsonKey(name: 'oauths', defaultValue: <OauthConnection>[])
  final List<OauthConnection> oauths;
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
            (identical(other.oauths, oauths) ||
                const DeepCollectionEquality().equals(other.oauths, oauths)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(init) ^
      const DeepCollectionEquality().hash(externalAuth) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(oauths) ^
      runtimeType.hashCode;
}

extension $StatusExtension on Status {
  Status copyWith({
    bool? init,
    bool? externalAuth,
    String? error,
    List<OauthConnection>? oauths,
  }) {
    return Status(
      init: init ?? this.init,
      externalAuth: externalAuth ?? this.externalAuth,
      error: error ?? this.error,
      oauths: oauths ?? this.oauths,
    );
  }

  Status copyWithWrapped({
    Wrapped<bool>? init,
    Wrapped<bool>? externalAuth,
    Wrapped<String?>? error,
    Wrapped<List<OauthConnection>>? oauths,
  }) {
    return Status(
      init: (init != null ? init.value : this.init),
      externalAuth: (externalAuth != null
          ? externalAuth.value
          : this.externalAuth),
      error: (error != null ? error.value : this.error),
      oauths: (oauths != null ? oauths.value : this.oauths),
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
class Treatment {
  const Treatment({this.events, this.type});

  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);

  static const toJsonFactory = _$TreatmentToJson;
  Map<String, dynamic> toJson() => _$TreatmentToJson(this);

  @JsonKey(name: 'events', defaultValue: <Event>[])
  final List<Event>? events;
  @JsonKey(
    name: 'type',
    toJson: treatmentTypeNullableToJson,
    fromJson: treatmentTypeNullableFromJson,
  )
  final enums.TreatmentType? type;
  static const fromJsonFactory = _$TreatmentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Treatment &&
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

extension $TreatmentExtension on Treatment {
  Treatment copyWith({List<Event>? events, enums.TreatmentType? type}) {
    return Treatment(events: events ?? this.events, type: type ?? this.type);
  }

  Treatment copyWithWrapped({
    Wrapped<List<Event>?>? events,
    Wrapped<enums.TreatmentType?>? type,
  }) {
    return Treatment(
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
    this.notificationTime,
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
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
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
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.notificationTime, notificationTime) ||
                const DeepCollectionEquality().equals(
                  other.notificationTime,
                  notificationTime,
                )));
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
      const DeepCollectionEquality().hash(notificationTime) ^
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
    DateTime? notificationTime,
  }) {
    return UpdateEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }

  UpdateEvent copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String?>? tag,
    Wrapped<DateTime?>? notificationTime,
  }) {
    return UpdateEvent(
      id: (id != null ? id.value : this.id),
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      tag: (tag != null ? tag.value : this.tag),
      notificationTime: (notificationTime != null
          ? notificationTime.value
          : this.notificationTime),
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
  @JsonKey(
    name: 'source',
    toJson: fileTypesNullableToJson,
    fromJson: fileTypesNullableFromJson,
  )
  final enums.FileTypes? source;
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
    enums.FileTypes? source,
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
    Wrapped<enums.FileTypes?>? source,
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

@JsonSerializable(explicitToJson: true)
class UpdatePatient {
  const UpdatePatient({
    this.id,
    this.birth,
    this.profilePicture,
    this.name,
    this.surname,
    this.identifier,
  });

  factory UpdatePatient.fromJson(Map<String, dynamic> json) =>
      _$UpdatePatientFromJson(json);

  static const toJsonFactory = _$UpdatePatientToJson;
  Map<String, dynamic> toJson() => _$UpdatePatientToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'birth')
  final DateTime? birth;
  @JsonKey(name: 'profilePicture')
  final String? profilePicture;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'surname')
  final String? surname;
  @JsonKey(name: 'identifier')
  final String? identifier;
  static const fromJsonFactory = _$UpdatePatientFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePatient &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.birth, birth) ||
                const DeepCollectionEquality().equals(other.birth, birth)) &&
            (identical(other.profilePicture, profilePicture) ||
                const DeepCollectionEquality().equals(
                  other.profilePicture,
                  profilePicture,
                )) &&
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
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(birth) ^
      const DeepCollectionEquality().hash(profilePicture) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(surname) ^
      const DeepCollectionEquality().hash(identifier) ^
      runtimeType.hashCode;
}

extension $UpdatePatientExtension on UpdatePatient {
  UpdatePatient copyWith({
    int? id,
    DateTime? birth,
    String? profilePicture,
    String? name,
    String? surname,
    String? identifier,
  }) {
    return UpdatePatient(
      id: id ?? this.id,
      birth: birth ?? this.birth,
      profilePicture: profilePicture ?? this.profilePicture,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      identifier: identifier ?? this.identifier,
    );
  }

  UpdatePatient copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<DateTime?>? birth,
    Wrapped<String?>? profilePicture,
    Wrapped<String?>? name,
    Wrapped<String?>? surname,
    Wrapped<String?>? identifier,
  }) {
    return UpdatePatient(
      id: (id != null ? id.value : this.id),
      birth: (birth != null ? birth.value : this.birth),
      profilePicture: (profilePicture != null
          ? profilePicture.value
          : this.profilePicture),
      name: (name != null ? name.value : this.name),
      surname: (surname != null ? surname.value : this.surname),
      identifier: (identifier != null ? identifier.value : this.identifier),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdatePerson {
  const UpdatePerson({
    this.id,
    this.types,
    this.name,
    this.surname,
    this.identifier,
    this.birth,
    this.profilePicture,
    this.email,
    this.phone,
  });

  factory UpdatePerson.fromJson(Map<String, dynamic> json) =>
      _$UpdatePersonFromJson(json);

  static const toJsonFactory = _$UpdatePersonToJson;
  Map<String, dynamic> toJson() => _$UpdatePersonToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(
    name: 'types',
    toJson: userTypeListToJson,
    fromJson: userTypeListFromJson,
  )
  final List<enums.UserType>? types;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'surname')
  final String? surname;
  @JsonKey(name: 'identifier')
  final String? identifier;
  @JsonKey(name: 'birth')
  final DateTime? birth;
  @JsonKey(name: 'profilePicture')
  final String? profilePicture;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  static const fromJsonFactory = _$UpdatePersonFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdatePerson &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.types, types) ||
                const DeepCollectionEquality().equals(other.types, types)) &&
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
            (identical(other.profilePicture, profilePicture) ||
                const DeepCollectionEquality().equals(
                  other.profilePicture,
                  profilePicture,
                )) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(types) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(surname) ^
      const DeepCollectionEquality().hash(identifier) ^
      const DeepCollectionEquality().hash(birth) ^
      const DeepCollectionEquality().hash(profilePicture) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      runtimeType.hashCode;
}

extension $UpdatePersonExtension on UpdatePerson {
  UpdatePerson copyWith({
    int? id,
    List<enums.UserType>? types,
    String? name,
    String? surname,
    String? identifier,
    DateTime? birth,
    String? profilePicture,
    String? email,
    String? phone,
  }) {
    return UpdatePerson(
      id: id ?? this.id,
      types: types ?? this.types,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      identifier: identifier ?? this.identifier,
      birth: birth ?? this.birth,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  UpdatePerson copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<List<enums.UserType>?>? types,
    Wrapped<String?>? name,
    Wrapped<String?>? surname,
    Wrapped<String?>? identifier,
    Wrapped<DateTime?>? birth,
    Wrapped<String?>? profilePicture,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
  }) {
    return UpdatePerson(
      id: (id != null ? id.value : this.id),
      types: (types != null ? types.value : this.types),
      name: (name != null ? name.value : this.name),
      surname: (surname != null ? surname.value : this.surname),
      identifier: (identifier != null ? identifier.value : this.identifier),
      birth: (birth != null ? birth.value : this.birth),
      profilePicture: (profilePicture != null
          ? profilePicture.value
          : this.profilePicture),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserStats {
  const UserStats({required this.userCount});

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  static const toJsonFactory = _$UserStatsToJson;
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  @JsonKey(name: 'userCount', defaultValue: <CountRecord>[])
  final List<CountRecord> userCount;
  static const fromJsonFactory = _$UserStatsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserStats &&
            (identical(other.userCount, userCount) ||
                const DeepCollectionEquality().equals(
                  other.userCount,
                  userCount,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userCount) ^ runtimeType.hashCode;
}

extension $UserStatsExtension on UserStats {
  UserStats copyWith({List<CountRecord>? userCount}) {
    return UserStats(userCount: userCount ?? this.userCount);
  }

  UserStats copyWithWrapped({Wrapped<List<CountRecord>>? userCount}) {
    return UserStats(
      userCount: (userCount != null ? userCount.value : this.userCount),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiImportTypePost$RequestBody {
  const ApiImportTypePost$RequestBody({required this.file});

  factory ApiImportTypePost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiImportTypePost$RequestBodyFromJson(json);

  static const toJsonFactory = _$ApiImportTypePost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$ApiImportTypePost$RequestBodyToJson(this);

  @JsonKey(name: 'file')
  final String file;
  static const fromJsonFactory = _$ApiImportTypePost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiImportTypePost$RequestBody &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(file) ^ runtimeType.hashCode;
}

extension $ApiImportTypePost$RequestBodyExtension
    on ApiImportTypePost$RequestBody {
  ApiImportTypePost$RequestBody copyWith({String? file}) {
    return ApiImportTypePost$RequestBody(file: file ?? this.file);
  }

  ApiImportTypePost$RequestBody copyWithWrapped({Wrapped<String>? file}) {
    return ApiImportTypePost$RequestBody(
      file: (file != null ? file.value : this.file),
    );
  }
}

String? fileTypesNullableToJson(enums.FileTypes? fileTypes) {
  return fileTypes?.value;
}

String? fileTypesToJson(enums.FileTypes fileTypes) {
  return fileTypes.value;
}

enums.FileTypes fileTypesFromJson(
  Object? fileTypes, [
  enums.FileTypes? defaultValue,
]) {
  return enums.FileTypes.values.firstWhereOrNull((e) => e.value == fileTypes) ??
      defaultValue ??
      enums.FileTypes.swaggerGeneratedUnknown;
}

enums.FileTypes? fileTypesNullableFromJson(
  Object? fileTypes, [
  enums.FileTypes? defaultValue,
]) {
  if (fileTypes == null) {
    return null;
  }
  return enums.FileTypes.values.firstWhereOrNull((e) => e.value == fileTypes) ??
      defaultValue;
}

String fileTypesExplodedListToJson(List<enums.FileTypes>? fileTypes) {
  return fileTypes?.map((e) => e.value!).join(',') ?? '';
}

List<String> fileTypesListToJson(List<enums.FileTypes>? fileTypes) {
  if (fileTypes == null) {
    return [];
  }

  return fileTypes.map((e) => e.value!).toList();
}

List<enums.FileTypes> fileTypesListFromJson(
  List? fileTypes, [
  List<enums.FileTypes>? defaultValue,
]) {
  if (fileTypes == null) {
    return defaultValue ?? [];
  }

  return fileTypes.map((e) => fileTypesFromJson(e.toString())).toList();
}

List<enums.FileTypes>? fileTypesNullableListFromJson(
  List? fileTypes, [
  List<enums.FileTypes>? defaultValue,
]) {
  if (fileTypes == null) {
    return defaultValue;
  }

  return fileTypes.map((e) => fileTypesFromJson(e.toString())).toList();
}

String? metricDataTypeNullableToJson(enums.MetricDataType? metricDataType) {
  return metricDataType?.value;
}

String? metricDataTypeToJson(enums.MetricDataType metricDataType) {
  return metricDataType.value;
}

enums.MetricDataType metricDataTypeFromJson(
  Object? metricDataType, [
  enums.MetricDataType? defaultValue,
]) {
  return enums.MetricDataType.values.firstWhereOrNull(
        (e) => e.value == metricDataType,
      ) ??
      defaultValue ??
      enums.MetricDataType.swaggerGeneratedUnknown;
}

enums.MetricDataType? metricDataTypeNullableFromJson(
  Object? metricDataType, [
  enums.MetricDataType? defaultValue,
]) {
  if (metricDataType == null) {
    return null;
  }
  return enums.MetricDataType.values.firstWhereOrNull(
        (e) => e.value == metricDataType,
      ) ??
      defaultValue;
}

String metricDataTypeExplodedListToJson(
  List<enums.MetricDataType>? metricDataType,
) {
  return metricDataType?.map((e) => e.value!).join(',') ?? '';
}

List<String> metricDataTypeListToJson(
  List<enums.MetricDataType>? metricDataType,
) {
  if (metricDataType == null) {
    return [];
  }

  return metricDataType.map((e) => e.value!).toList();
}

List<enums.MetricDataType> metricDataTypeListFromJson(
  List? metricDataType, [
  List<enums.MetricDataType>? defaultValue,
]) {
  if (metricDataType == null) {
    return defaultValue ?? [];
  }

  return metricDataType
      .map((e) => metricDataTypeFromJson(e.toString()))
      .toList();
}

List<enums.MetricDataType>? metricDataTypeNullableListFromJson(
  List? metricDataType, [
  List<enums.MetricDataType>? defaultValue,
]) {
  if (metricDataType == null) {
    return defaultValue;
  }

  return metricDataType
      .map((e) => metricDataTypeFromJson(e.toString()))
      .toList();
}

String? metricSummaryNullableToJson(enums.MetricSummary? metricSummary) {
  return metricSummary?.value;
}

String? metricSummaryToJson(enums.MetricSummary metricSummary) {
  return metricSummary.value;
}

enums.MetricSummary metricSummaryFromJson(
  Object? metricSummary, [
  enums.MetricSummary? defaultValue,
]) {
  return enums.MetricSummary.values.firstWhereOrNull(
        (e) => e.value == metricSummary,
      ) ??
      defaultValue ??
      enums.MetricSummary.swaggerGeneratedUnknown;
}

enums.MetricSummary? metricSummaryNullableFromJson(
  Object? metricSummary, [
  enums.MetricSummary? defaultValue,
]) {
  if (metricSummary == null) {
    return null;
  }
  return enums.MetricSummary.values.firstWhereOrNull(
        (e) => e.value == metricSummary,
      ) ??
      defaultValue;
}

String metricSummaryExplodedListToJson(
  List<enums.MetricSummary>? metricSummary,
) {
  return metricSummary?.map((e) => e.value!).join(',') ?? '';
}

List<String> metricSummaryListToJson(List<enums.MetricSummary>? metricSummary) {
  if (metricSummary == null) {
    return [];
  }

  return metricSummary.map((e) => e.value!).toList();
}

List<enums.MetricSummary> metricSummaryListFromJson(
  List? metricSummary, [
  List<enums.MetricSummary>? defaultValue,
]) {
  if (metricSummary == null) {
    return defaultValue ?? [];
  }

  return metricSummary.map((e) => metricSummaryFromJson(e.toString())).toList();
}

List<enums.MetricSummary>? metricSummaryNullableListFromJson(
  List? metricSummary, [
  List<enums.MetricSummary>? defaultValue,
]) {
  if (metricSummary == null) {
    return defaultValue;
  }

  return metricSummary.map((e) => metricSummaryFromJson(e.toString())).toList();
}

String? rightTypeNullableToJson(enums.RightType? rightType) {
  return rightType?.value;
}

String? rightTypeToJson(enums.RightType rightType) {
  return rightType.value;
}

enums.RightType rightTypeFromJson(
  Object? rightType, [
  enums.RightType? defaultValue,
]) {
  return enums.RightType.values.firstWhereOrNull((e) => e.value == rightType) ??
      defaultValue ??
      enums.RightType.swaggerGeneratedUnknown;
}

enums.RightType? rightTypeNullableFromJson(
  Object? rightType, [
  enums.RightType? defaultValue,
]) {
  if (rightType == null) {
    return null;
  }
  return enums.RightType.values.firstWhereOrNull((e) => e.value == rightType) ??
      defaultValue;
}

String rightTypeExplodedListToJson(List<enums.RightType>? rightType) {
  return rightType?.map((e) => e.value!).join(',') ?? '';
}

List<String> rightTypeListToJson(List<enums.RightType>? rightType) {
  if (rightType == null) {
    return [];
  }

  return rightType.map((e) => e.value!).toList();
}

List<enums.RightType> rightTypeListFromJson(
  List? rightType, [
  List<enums.RightType>? defaultValue,
]) {
  if (rightType == null) {
    return defaultValue ?? [];
  }

  return rightType.map((e) => rightTypeFromJson(e.toString())).toList();
}

List<enums.RightType>? rightTypeNullableListFromJson(
  List? rightType, [
  List<enums.RightType>? defaultValue,
]) {
  if (rightType == null) {
    return defaultValue;
  }

  return rightType.map((e) => rightTypeFromJson(e.toString())).toList();
}

String? treatmentTypeNullableToJson(enums.TreatmentType? treatmentType) {
  return treatmentType?.value;
}

String? treatmentTypeToJson(enums.TreatmentType treatmentType) {
  return treatmentType.value;
}

enums.TreatmentType treatmentTypeFromJson(
  Object? treatmentType, [
  enums.TreatmentType? defaultValue,
]) {
  return enums.TreatmentType.values.firstWhereOrNull(
        (e) => e.value == treatmentType,
      ) ??
      defaultValue ??
      enums.TreatmentType.swaggerGeneratedUnknown;
}

enums.TreatmentType? treatmentTypeNullableFromJson(
  Object? treatmentType, [
  enums.TreatmentType? defaultValue,
]) {
  if (treatmentType == null) {
    return null;
  }
  return enums.TreatmentType.values.firstWhereOrNull(
        (e) => e.value == treatmentType,
      ) ??
      defaultValue;
}

String treatmentTypeExplodedListToJson(
  List<enums.TreatmentType>? treatmentType,
) {
  return treatmentType?.map((e) => e.value!).join(',') ?? '';
}

List<String> treatmentTypeListToJson(List<enums.TreatmentType>? treatmentType) {
  if (treatmentType == null) {
    return [];
  }

  return treatmentType.map((e) => e.value!).toList();
}

List<enums.TreatmentType> treatmentTypeListFromJson(
  List? treatmentType, [
  List<enums.TreatmentType>? defaultValue,
]) {
  if (treatmentType == null) {
    return defaultValue ?? [];
  }

  return treatmentType.map((e) => treatmentTypeFromJson(e.toString())).toList();
}

List<enums.TreatmentType>? treatmentTypeNullableListFromJson(
  List? treatmentType, [
  List<enums.TreatmentType>? defaultValue,
]) {
  if (treatmentType == null) {
    return defaultValue;
  }

  return treatmentType.map((e) => treatmentTypeFromJson(e.toString())).toList();
}

String? userTypeNullableToJson(enums.UserType? userType) {
  return userType?.value;
}

String? userTypeToJson(enums.UserType userType) {
  return userType.value;
}

enums.UserType userTypeFromJson(
  Object? userType, [
  enums.UserType? defaultValue,
]) {
  return enums.UserType.values.firstWhereOrNull((e) => e.value == userType) ??
      defaultValue ??
      enums.UserType.swaggerGeneratedUnknown;
}

enums.UserType? userTypeNullableFromJson(
  Object? userType, [
  enums.UserType? defaultValue,
]) {
  if (userType == null) {
    return null;
  }
  return enums.UserType.values.firstWhereOrNull((e) => e.value == userType) ??
      defaultValue;
}

String userTypeExplodedListToJson(List<enums.UserType>? userType) {
  return userType?.map((e) => e.value!).join(',') ?? '';
}

List<String> userTypeListToJson(List<enums.UserType>? userType) {
  if (userType == null) {
    return [];
  }

  return userType.map((e) => e.value!).toList();
}

List<enums.UserType> userTypeListFromJson(
  List? userType, [
  List<enums.UserType>? defaultValue,
]) {
  if (userType == null) {
    return defaultValue ?? [];
  }

  return userType.map((e) => userTypeFromJson(e.toString())).toList();
}

List<enums.UserType>? userTypeNullableListFromJson(
  List? userType, [
  List<enums.UserType>? defaultValue,
]) {
  if (userType == null) {
    return defaultValue;
  }

  return userType.map((e) => userTypeFromJson(e.toString())).toList();
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
