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
  Future<chopper.Response<ConnectionResponse>> apiAuthPost({
    required Connection? body,
  }) {
    generatedMapping.putIfAbsent(
      ConnectionResponse,
      () => ConnectionResponse.fromJsonFactory,
    );

    return _apiAuthPost(body: body);
  }

  ///
  @POST(path: '/api/auth', optionalBody: true)
  Future<chopper.Response<ConnectionResponse>> _apiAuthPost({
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
  Future<chopper.Response<ConnectionResponse>> apiRefreshGet() {
    generatedMapping.putIfAbsent(
      ConnectionResponse,
      () => ConnectionResponse.fromJsonFactory,
    );

    return _apiRefreshGet();
  }

  ///
  @GET(path: '/api/refresh')
  Future<chopper.Response<ConnectionResponse>> _apiRefreshGet({
    @chopper.Tag()
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
  Future<chopper.Response> apiLogoutGet() {
    return _apiLogoutGet();
  }

  ///
  @GET(path: '/api/logout')
  Future<chopper.Response> _apiLogoutGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<Session>>> apiSessionsGet() {
    generatedMapping.putIfAbsent(Session, () => Session.fromJsonFactory);

    return _apiSessionsGet();
  }

  ///
  @GET(path: '/api/sessions')
  Future<chopper.Response<List<Session>>> _apiSessionsGet({
    @chopper.Tag()
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
  });

  ///
  Future<chopper.Response<List<Unit>>> apiUnitsGet() {
    generatedMapping.putIfAbsent(Unit, () => Unit.fromJsonFactory);

    return _apiUnitsGet();
  }

  ///
  @GET(path: '/api/units')
  Future<chopper.Response<List<Unit>>> _apiUnitsGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["CommonLogic"],
      deprecated: false,
    ),
  });

  ///
  Future<chopper.Response<UserId>> apiPersonPost({
    required PersonCreation? body,
  }) {
    generatedMapping.putIfAbsent(UserId, () => UserId.fromJsonFactory);

    return _apiPersonPost(body: body);
  }

  ///
  @POST(path: '/api/person', optionalBody: true)
  Future<chopper.Response<UserId>> _apiPersonPost({
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
  Future<chopper.Response> apiPersonUserIdDelete({required int? userId}) {
    return _apiPersonUserIdDelete(userId: userId);
  }

  ///
  ///@param userId
  @DELETE(path: '/api/person/{userId}')
  Future<chopper.Response> _apiPersonUserIdDelete({
    @Path('userId') required int? userId,
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
  Future<chopper.Response<UserSettings>> apiPersonSettingsGet() {
    generatedMapping.putIfAbsent(
      UserSettings,
      () => UserSettings.fromJsonFactory,
    );

    return _apiPersonSettingsGet();
  }

  ///
  @GET(path: '/api/person/settings')
  Future<chopper.Response<UserSettings>> _apiPersonSettingsGet({
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
  Future<chopper.Response> apiPersonSettingsPost({
    required UserSettings? body,
  }) {
    return _apiPersonSettingsPost(body: body);
  }

  ///
  @POST(path: '/api/person/settings', optionalBody: true)
  Future<chopper.Response> _apiPersonSettingsPost({
    @Body() required UserSettings? body,
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
  Future<chopper.Response<PatientsSettings>> apiPatientsSettingsGet() {
    generatedMapping.putIfAbsent(
      PatientsSettings,
      () => PatientsSettings.fromJsonFactory,
    );

    return _apiPatientsSettingsGet();
  }

  ///
  @GET(path: '/api/patients/settings')
  Future<chopper.Response<PatientsSettings>> _apiPatientsSettingsGet({
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
  Future<chopper.Response> apiPatientsSettingsPost({
    required PatientsSettings? body,
  }) {
    return _apiPatientsSettingsPost(body: body);
  }

  ///
  @POST(path: '/api/patients/settings', optionalBody: true)
  Future<chopper.Response> _apiPatientsSettingsPost({
    @Body() required PatientsSettings? body,
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
  ///@param id
  ///@param personId
  Future<chopper.Response<File>> apiFilesIdGet({
    required int? id,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(File, () => File.fromJsonFactory);

    return _apiFilesIdGet(id: id, personId: personId);
  }

  ///
  ///@param id
  ///@param personId
  @GET(path: '/api/files/{id}')
  Future<chopper.Response<File>> _apiFilesIdGet({
    @Path('id') required int? id,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param id
  ///@param personId
  Future<chopper.Response> apiFilesIdDelete({required int? id, int? personId}) {
    return _apiFilesIdDelete(id: id, personId: personId);
  }

  ///
  ///@param id
  ///@param personId
  @DELETE(path: '/api/files/{id}')
  Future<chopper.Response> _apiFilesIdDelete({
    @Path('id') required int? id,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param id
  ///@param personId
  Future<chopper.Response<File>> apiFilesDataIdGet({
    required int? id,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(File, () => File.fromJsonFactory);

    return _apiFilesDataIdGet(id: id, personId: personId);
  }

  ///
  ///@param id
  ///@param personId
  @GET(path: '/api/files/data/{id}')
  Future<chopper.Response<File>> _apiFilesDataIdGet({
    @Path('id') required int? id,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param id
  ///@param personId
  Future<chopper.Response> apiFilesDataIdPost({
    required int? id,
    int? personId,
    required dynamic file,
  }) {
    return _apiFilesDataIdPost(id: id, personId: personId, file: file);
  }

  ///
  ///@param id
  ///@param personId
  @POST(path: '/api/files/data/{id}', optionalBody: true)
  @Multipart()
  Future<chopper.Response> _apiFilesDataIdPost({
    @Path('id') required int? id,
    @Query('personId') int? personId,
    @Part('file') required dynamic file,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param personId
  ///@param Page
  ///@param PageSize
  Future<chopper.Response<List<File>>> apiFilesGet({
    int? personId,
    required int? page,
    required int? pageSize,
  }) {
    generatedMapping.putIfAbsent(File, () => File.fromJsonFactory);

    return _apiFilesGet(personId: personId, page: page, pageSize: pageSize);
  }

  ///
  ///@param personId
  ///@param Page
  ///@param PageSize
  @GET(path: '/api/files')
  Future<chopper.Response<List<File>>> _apiFilesGet({
    @Query('personId') int? personId,
    @Query('Page') required int? page,
    @Query('PageSize') required int? pageSize,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param personId
  Future<chopper.Response> apiFilesPut({
    int? personId,
    required UpdateFile? body,
  }) {
    return _apiFilesPut(personId: personId, body: body);
  }

  ///
  ///@param personId
  @PUT(path: '/api/files', optionalBody: true)
  Future<chopper.Response> _apiFilesPut({
    @Query('personId') int? personId,
    @Body() required UpdateFile? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param personId
  Future<chopper.Response<int>> apiFilesPost({
    int? personId,
    required CreateFile? body,
  }) {
    return _apiFilesPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/files', optionalBody: true)
  Future<chopper.Response<int>> _apiFilesPost({
    @Query('personId') int? personId,
    @Body() required CreateFile? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param metricid
  ///@param personId
  Future<chopper.Response<List<File>>> apiFilesMetricsMetricidGet({
    required int? metricid,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(File, () => File.fromJsonFactory);

    return _apiFilesMetricsMetricidGet(metricid: metricid, personId: personId);
  }

  ///
  ///@param metricid
  ///@param personId
  @GET(path: '/api/files/metrics/{metricid}')
  Future<chopper.Response<List<File>>> _apiFilesMetricsMetricidGet({
    @Path('metricid') required int? metricid,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param metricid
  ///@param fileid
  ///@param personId
  Future<chopper.Response> apiFilesMetricsMetricidFileidPost({
    required int? metricid,
    required int? fileid,
    int? personId,
  }) {
    return _apiFilesMetricsMetricidFileidPost(
      metricid: metricid,
      fileid: fileid,
      personId: personId,
    );
  }

  ///
  ///@param metricid
  ///@param fileid
  ///@param personId
  @POST(path: '/api/files/metrics/{metricid}/{fileid}', optionalBody: true)
  Future<chopper.Response> _apiFilesMetricsMetricidFileidPost({
    @Path('metricid') required int? metricid,
    @Path('fileid') required int? fileid,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param metricid
  ///@param fileid
  ///@param personId
  Future<chopper.Response> apiFilesMetricsMetricidFileidDelete({
    required int? metricid,
    required int? fileid,
    int? personId,
  }) {
    return _apiFilesMetricsMetricidFileidDelete(
      metricid: metricid,
      fileid: fileid,
      personId: personId,
    );
  }

  ///
  ///@param metricid
  ///@param fileid
  ///@param personId
  @DELETE(path: '/api/files/metrics/{metricid}/{fileid}')
  Future<chopper.Response> _apiFilesMetricsMetricidFileidDelete({
    @Path('metricid') required int? metricid,
    @Path('fileid') required int? fileid,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param eventid
  ///@param personId
  Future<chopper.Response<List<File>>> apiFilesEventsEventidGet({
    required int? eventid,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(File, () => File.fromJsonFactory);

    return _apiFilesEventsEventidGet(eventid: eventid, personId: personId);
  }

  ///
  ///@param eventid
  ///@param personId
  @GET(path: '/api/files/events/{eventid}')
  Future<chopper.Response<List<File>>> _apiFilesEventsEventidGet({
    @Path('eventid') required int? eventid,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param eventid
  ///@param fileid
  ///@param personId
  Future<chopper.Response> apiFilesEventsEventidFileidPost({
    required int? eventid,
    required int? fileid,
    int? personId,
  }) {
    return _apiFilesEventsEventidFileidPost(
      eventid: eventid,
      fileid: fileid,
      personId: personId,
    );
  }

  ///
  ///@param eventid
  ///@param fileid
  ///@param personId
  @POST(path: '/api/files/events/{eventid}/{fileid}', optionalBody: true)
  Future<chopper.Response> _apiFilesEventsEventidFileidPost({
    @Path('eventid') required int? eventid,
    @Path('fileid') required int? fileid,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
      deprecated: false,
    ),
  });

  ///
  ///@param eventid
  ///@param fileid
  ///@param personId
  Future<chopper.Response> apiFilesEventsEventidFileidDelete({
    required int? eventid,
    required int? fileid,
    int? personId,
  }) {
    return _apiFilesEventsEventidFileidDelete(
      eventid: eventid,
      fileid: fileid,
      personId: personId,
    );
  }

  ///
  ///@param eventid
  ///@param fileid
  ///@param personId
  @DELETE(path: '/api/files/events/{eventid}/{fileid}')
  Future<chopper.Response> _apiFilesEventsEventidFileidDelete({
    @Path('eventid') required int? eventid,
    @Path('fileid') required int? fileid,
    @Query('personId') int? personId,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["FilesLogics"],
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
  Future<chopper.Response<int>> apiMetricsPost({
    int? personId,
    required CreateMetric? body,
  }) {
    return _apiMetricsPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/metrics', optionalBody: true)
  Future<chopper.Response<int>> _apiMetricsPost({
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
  ///@param personId
  Future<chopper.Response> apiMetricsIdDelete({
    required int? id,
    int? personId,
  }) {
    return _apiMetricsIdDelete(id: id, personId: personId);
  }

  ///
  ///@param id
  ///@param personId
  @DELETE(path: '/api/metrics/{id}')
  Future<chopper.Response> _apiMetricsIdDelete({
    @Path('id') required int? id,
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
  Future<chopper.Response> apiMetricsUpdatePut({
    int? personId,
    required PatchMetric? body,
  }) {
    return _apiMetricsUpdatePut(personId: personId, body: body);
  }

  ///
  ///@param personId
  @PUT(path: '/api/metrics/update', optionalBody: true)
  Future<chopper.Response> _apiMetricsUpdatePut({
    @Query('personId') int? personId,
    @Body() required PatchMetric? body,
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
  ///@param person
  Future<chopper.Response> apiMetricsDeletePost({
    int? person,
    required List<int>? body,
  }) {
    return _apiMetricsDeletePost(person: person, body: body);
  }

  ///
  ///@param person
  @POST(path: '/api/metrics/delete', optionalBody: true)
  Future<chopper.Response> _apiMetricsDeletePost({
    @Query('person') int? person,
    @Body() required List<int>? body,
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
  ///@param Page
  ///@param PageSize
  Future<chopper.Response<List<Metric>>> apiMetricsSearchPost({
    int? personId,
    required int? page,
    required int? pageSize,
    required SearchMetric? body,
  }) {
    generatedMapping.putIfAbsent(Metric, () => Metric.fromJsonFactory);

    return _apiMetricsSearchPost(
      personId: personId,
      page: page,
      pageSize: pageSize,
      body: body,
    );
  }

  ///
  ///@param personId
  ///@param Page
  ///@param PageSize
  @POST(path: '/api/metrics/search', optionalBody: true)
  Future<chopper.Response<List<Metric>>> _apiMetricsSearchPost({
    @Query('personId') int? personId,
    @Query('Page') required int? page,
    @Query('PageSize') required int? pageSize,
    @Body() required SearchMetric? body,
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
  Future<chopper.Response<int>> apiMetricsCountPost({
    int? personId,
    required SearchMetric? body,
  }) {
    return _apiMetricsCountPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/metrics/count', optionalBody: true)
  Future<chopper.Response<int>> _apiMetricsCountPost({
    @Query('personId') int? personId,
    @Body() required SearchMetric? body,
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
  Future<chopper.Response> apiMetricsTypePost({
    required CreateMetricType? body,
  }) {
    return _apiMetricsTypePost(body: body);
  }

  ///
  @POST(path: '/api/metrics/type', optionalBody: true)
  Future<chopper.Response> _apiMetricsTypePost({
    @Body() required CreateMetricType? body,
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
  Future<chopper.Response> apiMetricsTypePut({
    required UpdateMetricType? body,
  }) {
    return _apiMetricsTypePut(body: body);
  }

  ///
  @PUT(path: '/api/metrics/type', optionalBody: true)
  Future<chopper.Response> _apiMetricsTypePut({
    @Body() required UpdateMetricType? body,
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
  Future<chopper.Response> apiMetricsGroupsPost({required CreateGroup? body}) {
    return _apiMetricsGroupsPost(body: body);
  }

  ///
  @POST(path: '/api/metrics/groups', optionalBody: true)
  Future<chopper.Response> _apiMetricsGroupsPost({
    @Body() required CreateGroup? body,
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
  Future<chopper.Response> apiMetricsGroupsPut({required UpdateGroup? body}) {
    return _apiMetricsGroupsPut(body: body);
  }

  ///
  @PUT(path: '/api/metrics/groups', optionalBody: true)
  Future<chopper.Response> _apiMetricsGroupsPut({
    @Body() required UpdateGroup? body,
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
  Future<chopper.Response<List<Group>>> apiMetricsGroupsGet() {
    generatedMapping.putIfAbsent(Group, () => Group.fromJsonFactory);

    return _apiMetricsGroupsGet();
  }

  ///
  @GET(path: '/api/metrics/groups')
  Future<chopper.Response<List<Group>>> _apiMetricsGroupsGet({
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
  Future<chopper.Response> apiMetricsGroupsIdDelete({required int? id}) {
    return _apiMetricsGroupsIdDelete(id: id);
  }

  ///
  ///@param id
  @DELETE(path: '/api/metrics/groups/{id}')
  Future<chopper.Response> _apiMetricsGroupsIdDelete({
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
  Future<chopper.Response<EventStats>> apiEventsSummaryGet({
    required int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(EventStats, () => EventStats.fromJsonFactory);

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
  Future<chopper.Response<EventStats>> _apiEventsSummaryGet({
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
  Future<chopper.Response<int>> apiEventsPost({
    int? personId,
    required CreateEvent? body,
  }) {
    return _apiEventsPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/events', optionalBody: true)
  Future<chopper.Response<int>> _apiEventsPost({
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
  Future<chopper.Response> apiEventsPut({required UpdateEvent? body}) {
    return _apiEventsPut(body: body);
  }

  ///
  @PUT(path: '/api/events', optionalBody: true)
  Future<chopper.Response> _apiEventsPut({
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
  ///@param personId
  Future<chopper.Response> apiEventsUpdatePut({
    int? personId,
    required PatchEvent? body,
  }) {
    return _apiEventsUpdatePut(personId: personId, body: body);
  }

  ///
  ///@param personId
  @PUT(path: '/api/events/update', optionalBody: true)
  Future<chopper.Response> _apiEventsUpdatePut({
    @Query('personId') int? personId,
    @Body() required PatchEvent? body,
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
  ///@param person
  Future<chopper.Response> apiEventsDeletePost({
    int? person,
    required List<int>? body,
  }) {
    return _apiEventsDeletePost(person: person, body: body);
  }

  ///
  ///@param person
  @POST(path: '/api/events/delete', optionalBody: true)
  Future<chopper.Response> _apiEventsDeletePost({
    @Query('person') int? person,
    @Body() required List<int>? body,
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
  ///@param Page
  ///@param PageSize
  Future<chopper.Response<List<Event>>> apiEventsSearchPost({
    int? personId,
    required int? page,
    required int? pageSize,
    required SearchEvent? body,
  }) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiEventsSearchPost(
      personId: personId,
      page: page,
      pageSize: pageSize,
      body: body,
    );
  }

  ///
  ///@param personId
  ///@param Page
  ///@param PageSize
  @POST(path: '/api/events/search', optionalBody: true)
  Future<chopper.Response<List<Event>>> _apiEventsSearchPost({
    @Query('personId') int? personId,
    @Query('Page') required int? page,
    @Query('PageSize') required int? pageSize,
    @Body() required SearchEvent? body,
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
  Future<chopper.Response<int>> apiEventsCountPost({
    int? personId,
    required SearchEvent? body,
  }) {
    return _apiEventsCountPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @POST(path: '/api/events/count', optionalBody: true)
  Future<chopper.Response<int>> _apiEventsCountPost({
    @Query('personId') int? personId,
    @Body() required SearchEvent? body,
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
  Future<chopper.Response> apiEventsTypePost({required CreateEventType? body}) {
    return _apiEventsTypePost(body: body);
  }

  ///
  @POST(path: '/api/events/type', optionalBody: true)
  Future<chopper.Response> _apiEventsTypePost({
    @Body() required CreateEventType? body,
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
  Future<chopper.Response> apiEventsTypePut({required UpdateEventType? body}) {
    return _apiEventsTypePut(body: body);
  }

  ///
  @PUT(path: '/api/events/type', optionalBody: true)
  Future<chopper.Response> _apiEventsTypePut({
    @Body() required UpdateEventType? body,
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
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
      tags: ["AdminLogic"],
      deprecated: false,
    ),
  });

  ///
  Future<chopper.Response<UserCreationStats>> apiAdminStatsUsersGet() {
    generatedMapping.putIfAbsent(
      UserCreationStats,
      () => UserCreationStats.fromJsonFactory,
    );

    return _apiAdminStatsUsersGet();
  }

  ///
  @GET(path: '/api/admin/stats/users')
  Future<chopper.Response<UserCreationStats>> _apiAdminStatsUsersGet({
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
  Future<chopper.Response<EventCreationStats>> apiAdminStatsEventsGet({
    required DateTime? start,
    required DateTime? end,
  }) {
    generatedMapping.putIfAbsent(
      EventCreationStats,
      () => EventCreationStats.fromJsonFactory,
    );

    return _apiAdminStatsEventsGet(start: start, end: end);
  }

  ///
  ///@param start
  ///@param end
  @GET(path: '/api/admin/stats/events')
  Future<chopper.Response<EventCreationStats>> _apiAdminStatsEventsGet({
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
  Future<chopper.Response<MetricCreationStats>> apiAdminStatsMetricsGet({
    required DateTime? start,
    required DateTime? end,
  }) {
    generatedMapping.putIfAbsent(
      MetricCreationStats,
      () => MetricCreationStats.fromJsonFactory,
    );

    return _apiAdminStatsMetricsGet(start: start, end: end);
  }

  ///
  ///@param start
  ///@param end
  @GET(path: '/api/admin/stats/metrics')
  Future<chopper.Response<MetricCreationStats>> _apiAdminStatsMetricsGet({
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
  Future<chopper.Response<List<ImportType>>> apiImportTypesGet() {
    generatedMapping.putIfAbsent(ImportType, () => ImportType.fromJsonFactory);

    return _apiImportTypesGet();
  }

  ///
  @GET(path: '/api/import/types')
  Future<chopper.Response<List<ImportType>>> _apiImportTypesGet({
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
  ///@param patient
  Future<chopper.Response<JobId>> apiImportTypePost({
    required int? type,
    int? patient,
    required dynamic file,
  }) {
    generatedMapping.putIfAbsent(JobId, () => JobId.fromJsonFactory);

    return _apiImportTypePost(type: type, patient: patient, file: file);
  }

  ///
  ///@param type
  ///@param patient
  @POST(path: '/api/import/{type}', optionalBody: true)
  @Multipart()
  Future<chopper.Response<JobId>> _apiImportTypePost({
    @Path('type') required int? type,
    @Query('patient') int? patient,
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
  Future<chopper.Response<List<JobResultInfo>>> apiImportJobsAllGet() {
    generatedMapping.putIfAbsent(
      JobResultInfo,
      () => JobResultInfo.fromJsonFactory,
    );

    return _apiImportJobsAllGet();
  }

  ///
  @GET(path: '/api/import/jobs/all')
  Future<chopper.Response<List<JobResultInfo>>> _apiImportJobsAllGet({
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
  Future<chopper.Response<List<JobResultInfo>>> apiImportJobsGet() {
    generatedMapping.putIfAbsent(
      JobResultInfo,
      () => JobResultInfo.fromJsonFactory,
    );

    return _apiImportJobsGet();
  }

  ///
  @GET(path: '/api/import/jobs')
  Future<chopper.Response<List<JobResultInfo>>> _apiImportJobsGet({
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
  ///@param id
  Future<chopper.Response<JobResult>> apiImportIdGet({required String? id}) {
    generatedMapping.putIfAbsent(JobResult, () => JobResult.fromJsonFactory);

    return _apiImportIdGet(id: id);
  }

  ///
  ///@param id
  @GET(path: '/api/import/{id}')
  Future<chopper.Response<JobResult>> _apiImportIdGet({
    @Path('id') required String? id,
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
  ///@param patient
  Future<chopper.Response<ImportsResult>> apiImportResultsPost({
    int? patient,
    required ImportData? body,
  }) {
    generatedMapping.putIfAbsent(
      ImportsResult,
      () => ImportsResult.fromJsonFactory,
    );

    return _apiImportResultsPost(patient: patient, body: body);
  }

  ///
  ///@param patient
  @POST(path: '/api/import/results', optionalBody: true)
  Future<chopper.Response<ImportsResult>> _apiImportResultsPost({
    @Query('patient') int? patient,
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
class ConnectionResponse {
  const ConnectionResponse({
    required this.accessToken,
    this.refreshToken,
    required this.roles,
  });

  factory ConnectionResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectionResponseFromJson(json);

  static const toJsonFactory = _$ConnectionResponseToJson;
  Map<String, dynamic> toJson() => _$ConnectionResponseToJson(this);

  @JsonKey(name: 'accessToken')
  final String accessToken;
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;
  @JsonKey(
    name: 'roles',
    toJson: userTypeListToJson,
    fromJson: userTypeListFromJson,
  )
  final List<enums.UserType> roles;
  static const fromJsonFactory = _$ConnectionResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ConnectionResponse &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )) &&
            (identical(other.roles, roles) ||
                const DeepCollectionEquality().equals(other.roles, roles)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      const DeepCollectionEquality().hash(roles) ^
      runtimeType.hashCode;
}

extension $ConnectionResponseExtension on ConnectionResponse {
  ConnectionResponse copyWith({
    String? accessToken,
    String? refreshToken,
    List<enums.UserType>? roles,
  }) {
    return ConnectionResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      roles: roles ?? this.roles,
    );
  }

  ConnectionResponse copyWithWrapped({
    Wrapped<String>? accessToken,
    Wrapped<String?>? refreshToken,
    Wrapped<List<enums.UserType>>? roles,
  }) {
    return ConnectionResponse(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
      roles: (roles != null ? roles.value : this.roles),
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
    required this.type,
    this.description,
    required this.start,
    required this.stop,
    this.tag,
    this.notificationTime,
    this.source,
    this.sourceId,
  });

  factory CreateEvent.fromJson(Map<String, dynamic> json) =>
      _$CreateEventFromJson(json);

  static const toJsonFactory = _$CreateEventToJson;
  Map<String, dynamic> toJson() => _$CreateEventToJson(this);

  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime start;
  @JsonKey(name: 'stop')
  final DateTime stop;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String? sourceId;
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
                )) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
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
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
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
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return CreateEvent(
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
      notificationTime: notificationTime ?? this.notificationTime,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  CreateEvent copyWithWrapped({
    Wrapped<int>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime>? start,
    Wrapped<DateTime>? stop,
    Wrapped<String?>? tag,
    Wrapped<DateTime?>? notificationTime,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String?>? sourceId,
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
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateEventType {
  const CreateEventType({
    required this.name,
    this.description,
    this.standAlone,
    this.visible,
    this.timeDifference,
    required this.groupId,
  });

  factory CreateEventType.fromJson(Map<String, dynamic> json) =>
      _$CreateEventTypeFromJson(json);

  static const toJsonFactory = _$CreateEventTypeToJson;
  Map<String, dynamic> toJson() => _$CreateEventTypeToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'standAlone')
  final bool? standAlone;
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'timeDifference')
  final String? timeDifference;
  @JsonKey(name: 'groupId')
  final int groupId;
  static const fromJsonFactory = _$CreateEventTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateEventType &&
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
            (identical(other.visible, visible) ||
                const DeepCollectionEquality().equals(
                  other.visible,
                  visible,
                )) &&
            (identical(other.timeDifference, timeDifference) ||
                const DeepCollectionEquality().equals(
                  other.timeDifference,
                  timeDifference,
                )) &&
            (identical(other.groupId, groupId) ||
                const DeepCollectionEquality().equals(other.groupId, groupId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(standAlone) ^
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(timeDifference) ^
      const DeepCollectionEquality().hash(groupId) ^
      runtimeType.hashCode;
}

extension $CreateEventTypeExtension on CreateEventType {
  CreateEventType copyWith({
    String? name,
    String? description,
    bool? standAlone,
    bool? visible,
    String? timeDifference,
    int? groupId,
  }) {
    return CreateEventType(
      name: name ?? this.name,
      description: description ?? this.description,
      standAlone: standAlone ?? this.standAlone,
      visible: visible ?? this.visible,
      timeDifference: timeDifference ?? this.timeDifference,
      groupId: groupId ?? this.groupId,
    );
  }

  CreateEventType copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<bool?>? standAlone,
    Wrapped<bool?>? visible,
    Wrapped<String?>? timeDifference,
    Wrapped<int>? groupId,
  }) {
    return CreateEventType(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      standAlone: (standAlone != null ? standAlone.value : this.standAlone),
      visible: (visible != null ? visible.value : this.visible),
      timeDifference: (timeDifference != null
          ? timeDifference.value
          : this.timeDifference),
      groupId: (groupId != null ? groupId.value : this.groupId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateFile {
  const CreateFile({
    required this.dataType,
    this.type,
    this.start,
    this.stop,
    required this.name,
    required this.description,
  });

  factory CreateFile.fromJson(Map<String, dynamic> json) =>
      _$CreateFileFromJson(json);

  static const toJsonFactory = _$CreateFileToJson;
  Map<String, dynamic> toJson() => _$CreateFileToJson(this);

  @JsonKey(name: 'dataType')
  final String dataType;
  @JsonKey(
    name: 'type',
    toJson: fileTypeNullableToJson,
    fromJson: fileTypeNullableFromJson,
  )
  final enums.FileType? type;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  static const fromJsonFactory = _$CreateFileFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateFile &&
            (identical(other.dataType, dataType) ||
                const DeepCollectionEquality().equals(
                  other.dataType,
                  dataType,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(dataType) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $CreateFileExtension on CreateFile {
  CreateFile copyWith({
    String? dataType,
    enums.FileType? type,
    DateTime? start,
    DateTime? stop,
    String? name,
    String? description,
  }) {
    return CreateFile(
      dataType: dataType ?? this.dataType,
      type: type ?? this.type,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  CreateFile copyWithWrapped({
    Wrapped<String>? dataType,
    Wrapped<enums.FileType?>? type,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String>? name,
    Wrapped<String>? description,
  }) {
    return CreateFile(
      dataType: (dataType != null ? dataType.value : this.dataType),
      type: (type != null ? type.value : this.type),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateGroup {
  const CreateGroup({
    required this.name,
    required this.description,
    this.showOnDashboard,
    this.showTitle,
  });

  factory CreateGroup.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupFromJson(json);

  static const toJsonFactory = _$CreateGroupToJson;
  Map<String, dynamic> toJson() => _$CreateGroupToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'showTitle')
  final bool? showTitle;
  static const fromJsonFactory = _$CreateGroupFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateGroup &&
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
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(showTitle) ^
      runtimeType.hashCode;
}

extension $CreateGroupExtension on CreateGroup {
  CreateGroup copyWith({
    String? name,
    String? description,
    bool? showOnDashboard,
    bool? showTitle,
  }) {
    return CreateGroup(
      name: name ?? this.name,
      description: description ?? this.description,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      showTitle: showTitle ?? this.showTitle,
    );
  }

  CreateGroup copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String>? description,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<bool?>? showTitle,
  }) {
    return CreateGroup(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      showTitle: (showTitle != null ? showTitle.value : this.showTitle),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateMetric {
  const CreateMetric({
    this.unit,
    required this.date,
    required this.value,
    this.tag,
    required this.type,
    this.source,
    required this.sourceId,
  });

  factory CreateMetric.fromJson(Map<String, dynamic> json) =>
      _$CreateMetricFromJson(json);

  static const toJsonFactory = _$CreateMetricToJson;
  Map<String, dynamic> toJson() => _$CreateMetricToJson(this);

  @JsonKey(name: 'unit')
  final int? unit;
  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String sourceId;
  static const fromJsonFactory = _$CreateMetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateMetric &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
      runtimeType.hashCode;
}

extension $CreateMetricExtension on CreateMetric {
  CreateMetric copyWith({
    int? unit,
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return CreateMetric(
      unit: unit ?? this.unit,
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  CreateMetric copyWithWrapped({
    Wrapped<int?>? unit,
    Wrapped<DateTime>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int>? type,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String>? sourceId,
  }) {
    return CreateMetric(
      unit: (unit != null ? unit.value : this.unit),
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateMetricType {
  const CreateMetricType({
    required this.unit,
    required this.name,
    this.summaryType,
    this.description,
    this.type,
    this.visible,
    this.showOnDashboard,
    required this.groupId,
    this.valueCount,
    this.timeDifference,
  });

  factory CreateMetricType.fromJson(Map<String, dynamic> json) =>
      _$CreateMetricTypeFromJson(json);

  static const toJsonFactory = _$CreateMetricTypeToJson;
  Map<String, dynamic> toJson() => _$CreateMetricTypeToJson(this);

  @JsonKey(name: 'unit')
  final int unit;
  @JsonKey(name: 'name')
  final String name;
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
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'valueCount')
  final int? valueCount;
  @JsonKey(name: 'timeDifference')
  final String? timeDifference;
  static const fromJsonFactory = _$CreateMetricTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateMetricType &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
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
                const DeepCollectionEquality().equals(
                  other.groupId,
                  groupId,
                )) &&
            (identical(other.valueCount, valueCount) ||
                const DeepCollectionEquality().equals(
                  other.valueCount,
                  valueCount,
                )) &&
            (identical(other.timeDifference, timeDifference) ||
                const DeepCollectionEquality().equals(
                  other.timeDifference,
                  timeDifference,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(summaryType) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(groupId) ^
      const DeepCollectionEquality().hash(valueCount) ^
      const DeepCollectionEquality().hash(timeDifference) ^
      runtimeType.hashCode;
}

extension $CreateMetricTypeExtension on CreateMetricType {
  CreateMetricType copyWith({
    int? unit,
    String? name,
    enums.MetricSummary? summaryType,
    String? description,
    enums.MetricDataType? type,
    bool? visible,
    bool? showOnDashboard,
    int? groupId,
    int? valueCount,
    String? timeDifference,
  }) {
    return CreateMetricType(
      unit: unit ?? this.unit,
      name: name ?? this.name,
      summaryType: summaryType ?? this.summaryType,
      description: description ?? this.description,
      type: type ?? this.type,
      visible: visible ?? this.visible,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      groupId: groupId ?? this.groupId,
      valueCount: valueCount ?? this.valueCount,
      timeDifference: timeDifference ?? this.timeDifference,
    );
  }

  CreateMetricType copyWithWrapped({
    Wrapped<int>? unit,
    Wrapped<String>? name,
    Wrapped<enums.MetricSummary?>? summaryType,
    Wrapped<String?>? description,
    Wrapped<enums.MetricDataType?>? type,
    Wrapped<bool?>? visible,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<int>? groupId,
    Wrapped<int?>? valueCount,
    Wrapped<String?>? timeDifference,
  }) {
    return CreateMetricType(
      unit: (unit != null ? unit.value : this.unit),
      name: (name != null ? name.value : this.name),
      summaryType: (summaryType != null ? summaryType.value : this.summaryType),
      description: (description != null ? description.value : this.description),
      type: (type != null ? type.value : this.type),
      visible: (visible != null ? visible.value : this.visible),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      groupId: (groupId != null ? groupId.value : this.groupId),
      valueCount: (valueCount != null ? valueCount.value : this.valueCount),
      timeDifference: (timeDifference != null
          ? timeDifference.value
          : this.timeDifference),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Event {
  const Event({
    this.user,
    this.treatment,
    required this.id,
    this.person,
    this.valid,
    this.address,
    required this.type,
    this.description,
    required this.start,
    required this.stop,
    this.tag,
    this.notificationTime,
    this.source,
    this.sourceId,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  static const toJsonFactory = _$EventToJson;
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @JsonKey(name: 'user')
  final int? user;
  @JsonKey(name: 'treatment')
  final int? treatment;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'person')
  final int? person;
  @JsonKey(name: 'valid')
  final bool? valid;
  @JsonKey(name: 'address')
  final int? address;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime start;
  @JsonKey(name: 'stop')
  final DateTime stop;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String? sourceId;
  static const fromJsonFactory = _$EventFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Event &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
                )) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(user) ^
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
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
      runtimeType.hashCode;
}

extension $EventExtension on Event {
  Event copyWith({
    int? user,
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
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return Event(
      user: user ?? this.user,
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
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  Event copyWithWrapped({
    Wrapped<int?>? user,
    Wrapped<int?>? treatment,
    Wrapped<int>? id,
    Wrapped<int?>? person,
    Wrapped<bool?>? valid,
    Wrapped<int?>? address,
    Wrapped<int>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime>? start,
    Wrapped<DateTime>? stop,
    Wrapped<String?>? tag,
    Wrapped<DateTime?>? notificationTime,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String?>? sourceId,
  }) {
    return Event(
      user: (user != null ? user.value : this.user),
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
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class EventCreationStats {
  const EventCreationStats({required this.events, required this.eventCounts});

  factory EventCreationStats.fromJson(Map<String, dynamic> json) =>
      _$EventCreationStatsFromJson(json);

  static const toJsonFactory = _$EventCreationStatsToJson;
  Map<String, dynamic> toJson() => _$EventCreationStatsToJson(this);

  @JsonKey(name: 'events', defaultValue: <CountByDate>[])
  final List<CountByDate> events;
  @JsonKey(name: 'eventCounts', defaultValue: <CountRecord>[])
  final List<CountRecord> eventCounts;
  static const fromJsonFactory = _$EventCreationStatsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventCreationStats &&
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

extension $EventCreationStatsExtension on EventCreationStats {
  EventCreationStats copyWith({
    List<CountByDate>? events,
    List<CountRecord>? eventCounts,
  }) {
    return EventCreationStats(
      events: events ?? this.events,
      eventCounts: eventCounts ?? this.eventCounts,
    );
  }

  EventCreationStats copyWithWrapped({
    Wrapped<List<CountByDate>>? events,
    Wrapped<List<CountRecord>>? eventCounts,
  }) {
    return EventCreationStats(
      events: (events != null ? events.value : this.events),
      eventCounts: (eventCounts != null ? eventCounts.value : this.eventCounts),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class EventSettings {
  const EventSettings({
    required this.displaySettings,
    required this.displayValueSettings,
  });

  factory EventSettings.fromJson(Map<String, dynamic> json) =>
      _$EventSettingsFromJson(json);

  static const toJsonFactory = _$EventSettingsToJson;
  Map<String, dynamic> toJson() => _$EventSettingsToJson(this);

  @JsonKey(name: 'displaySettings', defaultValue: <OrderedItem>[])
  final List<OrderedItem> displaySettings;
  @JsonKey(name: 'displayValueSettings', defaultValue: <OrderedItem>[])
  final List<OrderedItem> displayValueSettings;
  static const fromJsonFactory = _$EventSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventSettings &&
            (identical(other.displaySettings, displaySettings) ||
                const DeepCollectionEquality().equals(
                  other.displaySettings,
                  displaySettings,
                )) &&
            (identical(other.displayValueSettings, displayValueSettings) ||
                const DeepCollectionEquality().equals(
                  other.displayValueSettings,
                  displayValueSettings,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(displaySettings) ^
      const DeepCollectionEquality().hash(displayValueSettings) ^
      runtimeType.hashCode;
}

extension $EventSettingsExtension on EventSettings {
  EventSettings copyWith({
    List<OrderedItem>? displaySettings,
    List<OrderedItem>? displayValueSettings,
  }) {
    return EventSettings(
      displaySettings: displaySettings ?? this.displaySettings,
      displayValueSettings: displayValueSettings ?? this.displayValueSettings,
    );
  }

  EventSettings copyWithWrapped({
    Wrapped<List<OrderedItem>>? displaySettings,
    Wrapped<List<OrderedItem>>? displayValueSettings,
  }) {
    return EventSettings(
      displaySettings: (displaySettings != null
          ? displaySettings.value
          : this.displaySettings),
      displayValueSettings: (displayValueSettings != null
          ? displayValueSettings.value
          : this.displayValueSettings),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class EventStats {
  const EventStats({
    required this.summaries,
    required this.durations,
    required this.events,
  });

  factory EventStats.fromJson(Map<String, dynamic> json) =>
      _$EventStatsFromJson(json);

  static const toJsonFactory = _$EventStatsToJson;
  Map<String, dynamic> toJson() => _$EventStatsToJson(this);

  @JsonKey(name: 'summaries', defaultValue: <EventSummary>[])
  final List<EventSummary> summaries;
  @JsonKey(name: 'durations', defaultValue: <Interval>[])
  final List<Interval> durations;
  @JsonKey(name: 'events', defaultValue: <Event>[])
  final List<Event> events;
  static const fromJsonFactory = _$EventStatsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventStats &&
            (identical(other.summaries, summaries) ||
                const DeepCollectionEquality().equals(
                  other.summaries,
                  summaries,
                )) &&
            (identical(other.durations, durations) ||
                const DeepCollectionEquality().equals(
                  other.durations,
                  durations,
                )) &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(summaries) ^
      const DeepCollectionEquality().hash(durations) ^
      const DeepCollectionEquality().hash(events) ^
      runtimeType.hashCode;
}

extension $EventStatsExtension on EventStats {
  EventStats copyWith({
    List<EventSummary>? summaries,
    List<Interval>? durations,
    List<Event>? events,
  }) {
    return EventStats(
      summaries: summaries ?? this.summaries,
      durations: durations ?? this.durations,
      events: events ?? this.events,
    );
  }

  EventStats copyWithWrapped({
    Wrapped<List<EventSummary>>? summaries,
    Wrapped<List<Interval>>? durations,
    Wrapped<List<Event>>? events,
  }) {
    return EventStats(
      summaries: (summaries != null ? summaries.value : this.summaries),
      durations: (durations != null ? durations.value : this.durations),
      events: (events != null ? events.value : this.events),
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
    required this.id,
    required this.userEditable,
    required this.name,
    this.description,
    this.standAlone,
    this.visible,
    this.timeDifference,
    required this.groupId,
  });

  factory EventType.fromJson(Map<String, dynamic> json) =>
      _$EventTypeFromJson(json);

  static const toJsonFactory = _$EventTypeToJson;
  Map<String, dynamic> toJson() => _$EventTypeToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'userEditable')
  final bool userEditable;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'standAlone')
  final bool? standAlone;
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'timeDifference')
  final String? timeDifference;
  @JsonKey(name: 'groupId')
  final int groupId;
  static const fromJsonFactory = _$EventTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventType &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userEditable, userEditable) ||
                const DeepCollectionEquality().equals(
                  other.userEditable,
                  userEditable,
                )) &&
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
            (identical(other.visible, visible) ||
                const DeepCollectionEquality().equals(
                  other.visible,
                  visible,
                )) &&
            (identical(other.timeDifference, timeDifference) ||
                const DeepCollectionEquality().equals(
                  other.timeDifference,
                  timeDifference,
                )) &&
            (identical(other.groupId, groupId) ||
                const DeepCollectionEquality().equals(other.groupId, groupId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userEditable) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(standAlone) ^
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(timeDifference) ^
      const DeepCollectionEquality().hash(groupId) ^
      runtimeType.hashCode;
}

extension $EventTypeExtension on EventType {
  EventType copyWith({
    int? id,
    bool? userEditable,
    String? name,
    String? description,
    bool? standAlone,
    bool? visible,
    String? timeDifference,
    int? groupId,
  }) {
    return EventType(
      id: id ?? this.id,
      userEditable: userEditable ?? this.userEditable,
      name: name ?? this.name,
      description: description ?? this.description,
      standAlone: standAlone ?? this.standAlone,
      visible: visible ?? this.visible,
      timeDifference: timeDifference ?? this.timeDifference,
      groupId: groupId ?? this.groupId,
    );
  }

  EventType copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<bool>? userEditable,
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<bool?>? standAlone,
    Wrapped<bool?>? visible,
    Wrapped<String?>? timeDifference,
    Wrapped<int>? groupId,
  }) {
    return EventType(
      id: (id != null ? id.value : this.id),
      userEditable: (userEditable != null
          ? userEditable.value
          : this.userEditable),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      standAlone: (standAlone != null ? standAlone.value : this.standAlone),
      visible: (visible != null ? visible.value : this.visible),
      timeDifference: (timeDifference != null
          ? timeDifference.value
          : this.timeDifference),
      groupId: (groupId != null ? groupId.value : this.groupId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class File {
  const File({
    this.id,
    this.created,
    this.type,
    this.start,
    this.stop,
    required this.name,
    required this.description,
  });

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);

  static const toJsonFactory = _$FileToJson;
  Map<String, dynamic> toJson() => _$FileToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'created')
  final DateTime? created;
  @JsonKey(
    name: 'type',
    toJson: fileTypeNullableToJson,
    fromJson: fileTypeNullableFromJson,
  )
  final enums.FileType? type;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  static const fromJsonFactory = _$FileFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is File &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.created, created) ||
                const DeepCollectionEquality().equals(
                  other.created,
                  created,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(created) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $FileExtension on File {
  File copyWith({
    int? id,
    DateTime? created,
    enums.FileType? type,
    DateTime? start,
    DateTime? stop,
    String? name,
    String? description,
  }) {
    return File(
      id: id ?? this.id,
      created: created ?? this.created,
      type: type ?? this.type,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  File copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<DateTime?>? created,
    Wrapped<enums.FileType?>? type,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String>? name,
    Wrapped<String>? description,
  }) {
    return File(
      id: (id != null ? id.value : this.id),
      created: (created != null ? created.value : this.created),
      type: (type != null ? type.value : this.type),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
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
class Group {
  const Group({
    this.id,
    required this.name,
    required this.description,
    this.showOnDashboard,
    this.showTitle,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  static const toJsonFactory = _$GroupToJson;
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'showTitle')
  final bool? showTitle;
  static const fromJsonFactory = _$GroupFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Group &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
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
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(showTitle) ^
      runtimeType.hashCode;
}

extension $GroupExtension on Group {
  Group copyWith({
    int? id,
    String? name,
    String? description,
    bool? showOnDashboard,
    bool? showTitle,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      showTitle: showTitle ?? this.showTitle,
    );
  }

  Group copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String>? name,
    Wrapped<String>? description,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<bool?>? showTitle,
  }) {
    return Group(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      showTitle: (showTitle != null ? showTitle.value : this.showTitle),
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
class ImportResult {
  const ImportResult({
    required this.imported,
    required this.skipped,
    required this.failed,
  });

  factory ImportResult.fromJson(Map<String, dynamic> json) =>
      _$ImportResultFromJson(json);

  static const toJsonFactory = _$ImportResultToJson;
  Map<String, dynamic> toJson() => _$ImportResultToJson(this);

  @JsonKey(name: 'imported')
  final int imported;
  @JsonKey(name: 'skipped')
  final int skipped;
  @JsonKey(name: 'failed')
  final int failed;
  static const fromJsonFactory = _$ImportResultFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ImportResult &&
            (identical(other.imported, imported) ||
                const DeepCollectionEquality().equals(
                  other.imported,
                  imported,
                )) &&
            (identical(other.skipped, skipped) ||
                const DeepCollectionEquality().equals(
                  other.skipped,
                  skipped,
                )) &&
            (identical(other.failed, failed) ||
                const DeepCollectionEquality().equals(other.failed, failed)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(imported) ^
      const DeepCollectionEquality().hash(skipped) ^
      const DeepCollectionEquality().hash(failed) ^
      runtimeType.hashCode;
}

extension $ImportResultExtension on ImportResult {
  ImportResult copyWith({int? imported, int? skipped, int? failed}) {
    return ImportResult(
      imported: imported ?? this.imported,
      skipped: skipped ?? this.skipped,
      failed: failed ?? this.failed,
    );
  }

  ImportResult copyWithWrapped({
    Wrapped<int>? imported,
    Wrapped<int>? skipped,
    Wrapped<int>? failed,
  }) {
    return ImportResult(
      imported: (imported != null ? imported.value : this.imported),
      skipped: (skipped != null ? skipped.value : this.skipped),
      failed: (failed != null ? failed.value : this.failed),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ImportsResult {
  const ImportsResult({required this.metrics, required this.events});

  factory ImportsResult.fromJson(Map<String, dynamic> json) =>
      _$ImportsResultFromJson(json);

  static const toJsonFactory = _$ImportsResultToJson;
  Map<String, dynamic> toJson() => _$ImportsResultToJson(this);

  @JsonKey(name: 'metrics')
  final ImportResult metrics;
  @JsonKey(name: 'events')
  final ImportResult events;
  static const fromJsonFactory = _$ImportsResultFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ImportsResult &&
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

extension $ImportsResultExtension on ImportsResult {
  ImportsResult copyWith({ImportResult? metrics, ImportResult? events}) {
    return ImportsResult(
      metrics: metrics ?? this.metrics,
      events: events ?? this.events,
    );
  }

  ImportsResult copyWithWrapped({
    Wrapped<ImportResult>? metrics,
    Wrapped<ImportResult>? events,
  }) {
    return ImportsResult(
      metrics: (metrics != null ? metrics.value : this.metrics),
      events: (events != null ? events.value : this.events),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ImportType {
  const ImportType({required this.type, this.name});

  factory ImportType.fromJson(Map<String, dynamic> json) =>
      _$ImportTypeFromJson(json);

  static const toJsonFactory = _$ImportTypeToJson;
  Map<String, dynamic> toJson() => _$ImportTypeToJson(this);

  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'name')
  final String? name;
  static const fromJsonFactory = _$ImportTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ImportType &&
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

extension $ImportTypeExtension on ImportType {
  ImportType copyWith({int? type, String? name}) {
    return ImportType(type: type ?? this.type, name: name ?? this.name);
  }

  ImportType copyWithWrapped({Wrapped<int>? type, Wrapped<String?>? name}) {
    return ImportType(
      type: (type != null ? type.value : this.type),
      name: (name != null ? name.value : this.name),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Interval {
  const Interval({required this.start, required this.stop});

  factory Interval.fromJson(Map<String, dynamic> json) =>
      _$IntervalFromJson(json);

  static const toJsonFactory = _$IntervalToJson;
  Map<String, dynamic> toJson() => _$IntervalToJson(this);

  @JsonKey(name: 'start')
  final DateTime start;
  @JsonKey(name: 'stop')
  final DateTime stop;
  static const fromJsonFactory = _$IntervalFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Interval &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      runtimeType.hashCode;
}

extension $IntervalExtension on Interval {
  Interval copyWith({DateTime? start, DateTime? stop}) {
    return Interval(start: start ?? this.start, stop: stop ?? this.stop);
  }

  Interval copyWithWrapped({
    Wrapped<DateTime>? start,
    Wrapped<DateTime>? stop,
  }) {
    return Interval(
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JobId {
  const JobId({required this.id});

  factory JobId.fromJson(Map<String, dynamic> json) => _$JobIdFromJson(json);

  static const toJsonFactory = _$JobIdToJson;
  Map<String, dynamic> toJson() => _$JobIdToJson(this);

  @JsonKey(name: 'id')
  final String id;
  static const fromJsonFactory = _$JobIdFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobId &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^ runtimeType.hashCode;
}

extension $JobIdExtension on JobId {
  JobId copyWith({String? id}) {
    return JobId(id: id ?? this.id);
  }

  JobId copyWithWrapped({Wrapped<String>? id}) {
    return JobId(id: (id != null ? id.value : this.id));
  }
}

@JsonSerializable(explicitToJson: true)
class JobResult {
  const JobResult({
    required this.description,
    required this.userId,
    this.progress,
    this.status,
    this.error,
    required this.start,
    required this.enque,
    this.stop,
    this.result,
  });

  factory JobResult.fromJson(Map<String, dynamic> json) =>
      _$JobResultFromJson(json);

  static const toJsonFactory = _$JobResultToJson;
  Map<String, dynamic> toJson() => _$JobResultToJson(this);

  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'userId')
  final int userId;
  @JsonKey(name: 'progress')
  final double? progress;
  @JsonKey(
    name: 'status',
    toJson: jobStatusNullableToJson,
    fromJson: jobStatusNullableFromJson,
  )
  final enums.JobStatus? status;
  @JsonKey(name: 'error')
  final String? error;
  @JsonKey(name: 'start')
  final DateTime start;
  @JsonKey(name: 'enque')
  final DateTime enque;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'result')
  final String? result;
  static const fromJsonFactory = _$JobResultFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobResult &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality().equals(
                  other.progress,
                  progress,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.enque, enque) ||
                const DeepCollectionEquality().equals(other.enque, enque)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(progress) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(enque) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(result) ^
      runtimeType.hashCode;
}

extension $JobResultExtension on JobResult {
  JobResult copyWith({
    String? description,
    int? userId,
    double? progress,
    enums.JobStatus? status,
    String? error,
    DateTime? start,
    DateTime? enque,
    DateTime? stop,
    String? result,
  }) {
    return JobResult(
      description: description ?? this.description,
      userId: userId ?? this.userId,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
      start: start ?? this.start,
      enque: enque ?? this.enque,
      stop: stop ?? this.stop,
      result: result ?? this.result,
    );
  }

  JobResult copyWithWrapped({
    Wrapped<String>? description,
    Wrapped<int>? userId,
    Wrapped<double?>? progress,
    Wrapped<enums.JobStatus?>? status,
    Wrapped<String?>? error,
    Wrapped<DateTime>? start,
    Wrapped<DateTime>? enque,
    Wrapped<DateTime?>? stop,
    Wrapped<String?>? result,
  }) {
    return JobResult(
      description: (description != null ? description.value : this.description),
      userId: (userId != null ? userId.value : this.userId),
      progress: (progress != null ? progress.value : this.progress),
      status: (status != null ? status.value : this.status),
      error: (error != null ? error.value : this.error),
      start: (start != null ? start.value : this.start),
      enque: (enque != null ? enque.value : this.enque),
      stop: (stop != null ? stop.value : this.stop),
      result: (result != null ? result.value : this.result),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JobResultInfo {
  const JobResultInfo({required this.id, required this.result});

  factory JobResultInfo.fromJson(Map<String, dynamic> json) =>
      _$JobResultInfoFromJson(json);

  static const toJsonFactory = _$JobResultInfoToJson;
  Map<String, dynamic> toJson() => _$JobResultInfoToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'result')
  final JobResult result;
  static const fromJsonFactory = _$JobResultInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobResultInfo &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(result) ^
      runtimeType.hashCode;
}

extension $JobResultInfoExtension on JobResultInfo {
  JobResultInfo copyWith({String? id, JobResult? result}) {
    return JobResultInfo(id: id ?? this.id, result: result ?? this.result);
  }

  JobResultInfo copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<JobResult>? result,
  }) {
    return JobResultInfo(
      id: (id != null ? id.value : this.id),
      result: (result != null ? result.value : this.result),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Metric {
  const Metric({
    required this.id,
    required this.person,
    this.user,
    this.unit,
    required this.date,
    required this.value,
    this.tag,
    required this.type,
    this.source,
    required this.sourceId,
  });

  factory Metric.fromJson(Map<String, dynamic> json) => _$MetricFromJson(json);

  static const toJsonFactory = _$MetricToJson;
  Map<String, dynamic> toJson() => _$MetricToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'person')
  final int person;
  @JsonKey(name: 'user')
  final int? user;
  @JsonKey(name: 'unit')
  final dynamic unit;
  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String sourceId;
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
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(person) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
      runtimeType.hashCode;
}

extension $MetricExtension on Metric {
  Metric copyWith({
    int? id,
    int? person,
    int? user,
    dynamic unit,
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return Metric(
      id: id ?? this.id,
      person: person ?? this.person,
      user: user ?? this.user,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  Metric copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<int>? person,
    Wrapped<int?>? user,
    Wrapped<dynamic>? unit,
    Wrapped<DateTime>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int>? type,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String>? sourceId,
  }) {
    return Metric(
      id: (id != null ? id.value : this.id),
      person: (person != null ? person.value : this.person),
      user: (user != null ? user.value : this.user),
      unit: (unit != null ? unit.value : this.unit),
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MetricCreationStats {
  const MetricCreationStats({required this.events, required this.eventCounts});

  factory MetricCreationStats.fromJson(Map<String, dynamic> json) =>
      _$MetricCreationStatsFromJson(json);

  static const toJsonFactory = _$MetricCreationStatsToJson;
  Map<String, dynamic> toJson() => _$MetricCreationStatsToJson(this);

  @JsonKey(name: 'events', defaultValue: <CountByDate>[])
  final List<CountByDate> events;
  @JsonKey(name: 'eventCounts', defaultValue: <CountRecord>[])
  final List<CountRecord> eventCounts;
  static const fromJsonFactory = _$MetricCreationStatsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MetricCreationStats &&
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

extension $MetricCreationStatsExtension on MetricCreationStats {
  MetricCreationStats copyWith({
    List<CountByDate>? events,
    List<CountRecord>? eventCounts,
  }) {
    return MetricCreationStats(
      events: events ?? this.events,
      eventCounts: eventCounts ?? this.eventCounts,
    );
  }

  MetricCreationStats copyWithWrapped({
    Wrapped<List<CountByDate>>? events,
    Wrapped<List<CountRecord>>? eventCounts,
  }) {
    return MetricCreationStats(
      events: (events != null ? events.value : this.events),
      eventCounts: (eventCounts != null ? eventCounts.value : this.eventCounts),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MetricGroupSettings {
  const MetricGroupSettings({required this.displaySettings});

  factory MetricGroupSettings.fromJson(Map<String, dynamic> json) =>
      _$MetricGroupSettingsFromJson(json);

  static const toJsonFactory = _$MetricGroupSettingsToJson;
  Map<String, dynamic> toJson() => _$MetricGroupSettingsToJson(this);

  @JsonKey(name: 'displaySettings', defaultValue: <OrderedItem>[])
  final List<OrderedItem> displaySettings;
  static const fromJsonFactory = _$MetricGroupSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MetricGroupSettings &&
            (identical(other.displaySettings, displaySettings) ||
                const DeepCollectionEquality().equals(
                  other.displaySettings,
                  displaySettings,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(displaySettings) ^
      runtimeType.hashCode;
}

extension $MetricGroupSettingsExtension on MetricGroupSettings {
  MetricGroupSettings copyWith({List<OrderedItem>? displaySettings}) {
    return MetricGroupSettings(
      displaySettings: displaySettings ?? this.displaySettings,
    );
  }

  MetricGroupSettings copyWithWrapped({
    Wrapped<List<OrderedItem>>? displaySettings,
  }) {
    return MetricGroupSettings(
      displaySettings: (displaySettings != null
          ? displaySettings.value
          : this.displaySettings),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MetricSettings {
  const MetricSettings({required this.displaySettings, this.groups});

  factory MetricSettings.fromJson(Map<String, dynamic> json) =>
      _$MetricSettingsFromJson(json);

  static const toJsonFactory = _$MetricSettingsToJson;
  Map<String, dynamic> toJson() => _$MetricSettingsToJson(this);

  @JsonKey(name: 'displaySettings', defaultValue: <OrderedItem>[])
  final List<OrderedItem> displaySettings;
  @JsonKey(name: 'groups')
  final dynamic groups;
  static const fromJsonFactory = _$MetricSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MetricSettings &&
            (identical(other.displaySettings, displaySettings) ||
                const DeepCollectionEquality().equals(
                  other.displaySettings,
                  displaySettings,
                )) &&
            (identical(other.groups, groups) ||
                const DeepCollectionEquality().equals(other.groups, groups)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(displaySettings) ^
      const DeepCollectionEquality().hash(groups) ^
      runtimeType.hashCode;
}

extension $MetricSettingsExtension on MetricSettings {
  MetricSettings copyWith({
    List<OrderedItem>? displaySettings,
    dynamic groups,
  }) {
    return MetricSettings(
      displaySettings: displaySettings ?? this.displaySettings,
      groups: groups ?? this.groups,
    );
  }

  MetricSettings copyWithWrapped({
    Wrapped<List<OrderedItem>>? displaySettings,
    Wrapped<dynamic>? groups,
  }) {
    return MetricSettings(
      displaySettings: (displaySettings != null
          ? displaySettings.value
          : this.displaySettings),
      groups: (groups != null ? groups.value : this.groups),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MetricType {
  const MetricType({
    required this.id,
    required this.unit,
    required this.userEditable,
    required this.name,
    this.summaryType,
    this.description,
    this.type,
    this.visible,
    this.showOnDashboard,
    required this.groupId,
    this.valueCount,
    this.timeDifference,
  });

  factory MetricType.fromJson(Map<String, dynamic> json) =>
      _$MetricTypeFromJson(json);

  static const toJsonFactory = _$MetricTypeToJson;
  Map<String, dynamic> toJson() => _$MetricTypeToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'unit')
  final Unit unit;
  @JsonKey(name: 'userEditable')
  final bool userEditable;
  @JsonKey(name: 'name')
  final String name;
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
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'valueCount')
  final int? valueCount;
  @JsonKey(name: 'timeDifference')
  final String? timeDifference;
  static const fromJsonFactory = _$MetricTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MetricType &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.userEditable, userEditable) ||
                const DeepCollectionEquality().equals(
                  other.userEditable,
                  userEditable,
                )) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
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
                const DeepCollectionEquality().equals(
                  other.groupId,
                  groupId,
                )) &&
            (identical(other.valueCount, valueCount) ||
                const DeepCollectionEquality().equals(
                  other.valueCount,
                  valueCount,
                )) &&
            (identical(other.timeDifference, timeDifference) ||
                const DeepCollectionEquality().equals(
                  other.timeDifference,
                  timeDifference,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(userEditable) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(summaryType) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(groupId) ^
      const DeepCollectionEquality().hash(valueCount) ^
      const DeepCollectionEquality().hash(timeDifference) ^
      runtimeType.hashCode;
}

extension $MetricTypeExtension on MetricType {
  MetricType copyWith({
    int? id,
    Unit? unit,
    bool? userEditable,
    String? name,
    enums.MetricSummary? summaryType,
    String? description,
    enums.MetricDataType? type,
    bool? visible,
    bool? showOnDashboard,
    int? groupId,
    int? valueCount,
    String? timeDifference,
  }) {
    return MetricType(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      userEditable: userEditable ?? this.userEditable,
      name: name ?? this.name,
      summaryType: summaryType ?? this.summaryType,
      description: description ?? this.description,
      type: type ?? this.type,
      visible: visible ?? this.visible,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      groupId: groupId ?? this.groupId,
      valueCount: valueCount ?? this.valueCount,
      timeDifference: timeDifference ?? this.timeDifference,
    );
  }

  MetricType copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<Unit>? unit,
    Wrapped<bool>? userEditable,
    Wrapped<String>? name,
    Wrapped<enums.MetricSummary?>? summaryType,
    Wrapped<String?>? description,
    Wrapped<enums.MetricDataType?>? type,
    Wrapped<bool?>? visible,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<int>? groupId,
    Wrapped<int?>? valueCount,
    Wrapped<String?>? timeDifference,
  }) {
    return MetricType(
      id: (id != null ? id.value : this.id),
      unit: (unit != null ? unit.value : this.unit),
      userEditable: (userEditable != null
          ? userEditable.value
          : this.userEditable),
      name: (name != null ? name.value : this.name),
      summaryType: (summaryType != null ? summaryType.value : this.summaryType),
      description: (description != null ? description.value : this.description),
      type: (type != null ? type.value : this.type),
      visible: (visible != null ? visible.value : this.visible),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      groupId: (groupId != null ? groupId.value : this.groupId),
      valueCount: (valueCount != null ? valueCount.value : this.valueCount),
      timeDifference: (timeDifference != null
          ? timeDifference.value
          : this.timeDifference),
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
class OrderedItem {
  const OrderedItem({
    this.visible,
    this.showOnDashboard,
    this.order,
    required this.name,
    required this.id,
    this.key,
    this.graph,
    this.detailGraph,
    this.parent,
    this.color,
  });

  factory OrderedItem.fromJson(Map<String, dynamic> json) =>
      _$OrderedItemFromJson(json);

  static const toJsonFactory = _$OrderedItemToJson;
  Map<String, dynamic> toJson() => _$OrderedItemToJson(this);

  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'order')
  final int? order;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'key')
  final String? key;
  @JsonKey(
    name: 'graph',
    toJson: graphKindNullableToJson,
    fromJson: graphKindNullableFromJson,
  )
  final enums.GraphKind? graph;
  @JsonKey(
    name: 'detailGraph',
    toJson: graphKindNullableToJson,
    fromJson: graphKindNullableFromJson,
  )
  final enums.GraphKind? detailGraph;
  @JsonKey(name: 'parent')
  final int? parent;
  @JsonKey(name: 'color')
  final int? color;
  static const fromJsonFactory = _$OrderedItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderedItem &&
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
            (identical(other.order, order) ||
                const DeepCollectionEquality().equals(other.order, order)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.graph, graph) ||
                const DeepCollectionEquality().equals(other.graph, graph)) &&
            (identical(other.detailGraph, detailGraph) ||
                const DeepCollectionEquality().equals(
                  other.detailGraph,
                  detailGraph,
                )) &&
            (identical(other.parent, parent) ||
                const DeepCollectionEquality().equals(other.parent, parent)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(order) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(graph) ^
      const DeepCollectionEquality().hash(detailGraph) ^
      const DeepCollectionEquality().hash(parent) ^
      const DeepCollectionEquality().hash(color) ^
      runtimeType.hashCode;
}

extension $OrderedItemExtension on OrderedItem {
  OrderedItem copyWith({
    bool? visible,
    bool? showOnDashboard,
    int? order,
    String? name,
    int? id,
    String? key,
    enums.GraphKind? graph,
    enums.GraphKind? detailGraph,
    int? parent,
    int? color,
  }) {
    return OrderedItem(
      visible: visible ?? this.visible,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      order: order ?? this.order,
      name: name ?? this.name,
      id: id ?? this.id,
      key: key ?? this.key,
      graph: graph ?? this.graph,
      detailGraph: detailGraph ?? this.detailGraph,
      parent: parent ?? this.parent,
      color: color ?? this.color,
    );
  }

  OrderedItem copyWithWrapped({
    Wrapped<bool?>? visible,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<int?>? order,
    Wrapped<String>? name,
    Wrapped<int>? id,
    Wrapped<String?>? key,
    Wrapped<enums.GraphKind?>? graph,
    Wrapped<enums.GraphKind?>? detailGraph,
    Wrapped<int?>? parent,
    Wrapped<int?>? color,
  }) {
    return OrderedItem(
      visible: (visible != null ? visible.value : this.visible),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      order: (order != null ? order.value : this.order),
      name: (name != null ? name.value : this.name),
      id: (id != null ? id.value : this.id),
      key: (key != null ? key.value : this.key),
      graph: (graph != null ? graph.value : this.graph),
      detailGraph: (detailGraph != null ? detailGraph.value : this.detailGraph),
      parent: (parent != null ? parent.value : this.parent),
      color: (color != null ? color.value : this.color),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PatchEvent {
  const PatchEvent({
    this.updateDescription,
    this.updateStop,
    this.updateStart,
    this.updateTag,
    this.ids,
    required this.type,
    this.description,
    required this.start,
    required this.stop,
    this.tag,
    this.notificationTime,
    this.source,
    this.sourceId,
  });

  factory PatchEvent.fromJson(Map<String, dynamic> json) =>
      _$PatchEventFromJson(json);

  static const toJsonFactory = _$PatchEventToJson;
  Map<String, dynamic> toJson() => _$PatchEventToJson(this);

  @JsonKey(name: 'updateDescription')
  final bool? updateDescription;
  @JsonKey(name: 'updateStop')
  final bool? updateStop;
  @JsonKey(name: 'updateStart')
  final bool? updateStart;
  @JsonKey(name: 'updateTag')
  final bool? updateTag;
  @JsonKey(name: 'ids', defaultValue: <int>[])
  final List<int>? ids;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime start;
  @JsonKey(name: 'stop')
  final DateTime stop;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String? sourceId;
  static const fromJsonFactory = _$PatchEventFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PatchEvent &&
            (identical(other.updateDescription, updateDescription) ||
                const DeepCollectionEquality().equals(
                  other.updateDescription,
                  updateDescription,
                )) &&
            (identical(other.updateStop, updateStop) ||
                const DeepCollectionEquality().equals(
                  other.updateStop,
                  updateStop,
                )) &&
            (identical(other.updateStart, updateStart) ||
                const DeepCollectionEquality().equals(
                  other.updateStart,
                  updateStart,
                )) &&
            (identical(other.updateTag, updateTag) ||
                const DeepCollectionEquality().equals(
                  other.updateTag,
                  updateTag,
                )) &&
            (identical(other.ids, ids) ||
                const DeepCollectionEquality().equals(other.ids, ids)) &&
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
                )) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(updateDescription) ^
      const DeepCollectionEquality().hash(updateStop) ^
      const DeepCollectionEquality().hash(updateStart) ^
      const DeepCollectionEquality().hash(updateTag) ^
      const DeepCollectionEquality().hash(ids) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(notificationTime) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
      runtimeType.hashCode;
}

extension $PatchEventExtension on PatchEvent {
  PatchEvent copyWith({
    bool? updateDescription,
    bool? updateStop,
    bool? updateStart,
    bool? updateTag,
    List<int>? ids,
    int? type,
    String? description,
    DateTime? start,
    DateTime? stop,
    String? tag,
    DateTime? notificationTime,
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return PatchEvent(
      updateDescription: updateDescription ?? this.updateDescription,
      updateStop: updateStop ?? this.updateStop,
      updateStart: updateStart ?? this.updateStart,
      updateTag: updateTag ?? this.updateTag,
      ids: ids ?? this.ids,
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
      notificationTime: notificationTime ?? this.notificationTime,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  PatchEvent copyWithWrapped({
    Wrapped<bool?>? updateDescription,
    Wrapped<bool?>? updateStop,
    Wrapped<bool?>? updateStart,
    Wrapped<bool?>? updateTag,
    Wrapped<List<int>?>? ids,
    Wrapped<int>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime>? start,
    Wrapped<DateTime>? stop,
    Wrapped<String?>? tag,
    Wrapped<DateTime?>? notificationTime,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String?>? sourceId,
  }) {
    return PatchEvent(
      updateDescription: (updateDescription != null
          ? updateDescription.value
          : this.updateDescription),
      updateStop: (updateStop != null ? updateStop.value : this.updateStop),
      updateStart: (updateStart != null ? updateStart.value : this.updateStart),
      updateTag: (updateTag != null ? updateTag.value : this.updateTag),
      ids: (ids != null ? ids.value : this.ids),
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      tag: (tag != null ? tag.value : this.tag),
      notificationTime: (notificationTime != null
          ? notificationTime.value
          : this.notificationTime),
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PatchMetric {
  const PatchMetric({
    this.updateValue,
    this.updateDate,
    this.updateTag,
    this.ids,
    this.unit,
    required this.date,
    required this.value,
    this.tag,
    required this.type,
    this.source,
    required this.sourceId,
  });

  factory PatchMetric.fromJson(Map<String, dynamic> json) =>
      _$PatchMetricFromJson(json);

  static const toJsonFactory = _$PatchMetricToJson;
  Map<String, dynamic> toJson() => _$PatchMetricToJson(this);

  @JsonKey(name: 'updateValue')
  final bool? updateValue;
  @JsonKey(name: 'updateDate')
  final bool? updateDate;
  @JsonKey(name: 'updateTag')
  final bool? updateTag;
  @JsonKey(name: 'ids', defaultValue: <int>[])
  final List<int>? ids;
  @JsonKey(name: 'unit')
  final int? unit;
  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String sourceId;
  static const fromJsonFactory = _$PatchMetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PatchMetric &&
            (identical(other.updateValue, updateValue) ||
                const DeepCollectionEquality().equals(
                  other.updateValue,
                  updateValue,
                )) &&
            (identical(other.updateDate, updateDate) ||
                const DeepCollectionEquality().equals(
                  other.updateDate,
                  updateDate,
                )) &&
            (identical(other.updateTag, updateTag) ||
                const DeepCollectionEquality().equals(
                  other.updateTag,
                  updateTag,
                )) &&
            (identical(other.ids, ids) ||
                const DeepCollectionEquality().equals(other.ids, ids)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(updateValue) ^
      const DeepCollectionEquality().hash(updateDate) ^
      const DeepCollectionEquality().hash(updateTag) ^
      const DeepCollectionEquality().hash(ids) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
      runtimeType.hashCode;
}

extension $PatchMetricExtension on PatchMetric {
  PatchMetric copyWith({
    bool? updateValue,
    bool? updateDate,
    bool? updateTag,
    List<int>? ids,
    int? unit,
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return PatchMetric(
      updateValue: updateValue ?? this.updateValue,
      updateDate: updateDate ?? this.updateDate,
      updateTag: updateTag ?? this.updateTag,
      ids: ids ?? this.ids,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  PatchMetric copyWithWrapped({
    Wrapped<bool?>? updateValue,
    Wrapped<bool?>? updateDate,
    Wrapped<bool?>? updateTag,
    Wrapped<List<int>?>? ids,
    Wrapped<int?>? unit,
    Wrapped<DateTime>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int>? type,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String>? sourceId,
  }) {
    return PatchMetric(
      updateValue: (updateValue != null ? updateValue.value : this.updateValue),
      updateDate: (updateDate != null ? updateDate.value : this.updateDate),
      updateTag: (updateTag != null ? updateTag.value : this.updateTag),
      ids: (ids != null ? ids.value : this.ids),
      unit: (unit != null ? unit.value : this.unit),
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PatientSettings {
  const PatientSettings({
    this.patientId,
    this.version,
    this.datePreset,
    this.theme,
    this.metrics,
    this.metricGroups,
    this.events,
    this.eventSettings,
    this.metricSettings,
    this.groups,
  });

  factory PatientSettings.fromJson(Map<String, dynamic> json) =>
      _$PatientSettingsFromJson(json);

  static const toJsonFactory = _$PatientSettingsToJson;
  Map<String, dynamic> toJson() => _$PatientSettingsToJson(this);

  @JsonKey(name: 'patientId')
  final int? patientId;
  @JsonKey(name: 'version')
  final int? version;
  @JsonKey(
    name: 'datePreset',
    toJson: datePresetNullableToJson,
    fromJson: datePresetNullableFromJson,
  )
  final enums.DatePreset? datePreset;
  @JsonKey(
    name: 'theme',
    toJson: interfaceThemeNullableToJson,
    fromJson: interfaceThemeNullableFromJson,
  )
  final enums.InterfaceTheme? theme;
  @JsonKey(name: 'metrics', defaultValue: <OrderedItem>[])
  final List<OrderedItem>? metrics;
  @JsonKey(name: 'metricGroups', defaultValue: <OrderedItem>[])
  final List<OrderedItem>? metricGroups;
  @JsonKey(name: 'events', defaultValue: <OrderedItem>[])
  final List<OrderedItem>? events;
  @JsonKey(name: 'eventSettings')
  final EventSettings? eventSettings;
  @JsonKey(name: 'metricSettings')
  final MetricSettings? metricSettings;
  @JsonKey(name: 'groups')
  final MetricGroupSettings? groups;
  static const fromJsonFactory = _$PatientSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PatientSettings &&
            (identical(other.patientId, patientId) ||
                const DeepCollectionEquality().equals(
                  other.patientId,
                  patientId,
                )) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality().equals(
                  other.version,
                  version,
                )) &&
            (identical(other.datePreset, datePreset) ||
                const DeepCollectionEquality().equals(
                  other.datePreset,
                  datePreset,
                )) &&
            (identical(other.theme, theme) ||
                const DeepCollectionEquality().equals(other.theme, theme)) &&
            (identical(other.metrics, metrics) ||
                const DeepCollectionEquality().equals(
                  other.metrics,
                  metrics,
                )) &&
            (identical(other.metricGroups, metricGroups) ||
                const DeepCollectionEquality().equals(
                  other.metricGroups,
                  metricGroups,
                )) &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)) &&
            (identical(other.eventSettings, eventSettings) ||
                const DeepCollectionEquality().equals(
                  other.eventSettings,
                  eventSettings,
                )) &&
            (identical(other.metricSettings, metricSettings) ||
                const DeepCollectionEquality().equals(
                  other.metricSettings,
                  metricSettings,
                )) &&
            (identical(other.groups, groups) ||
                const DeepCollectionEquality().equals(other.groups, groups)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(patientId) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(datePreset) ^
      const DeepCollectionEquality().hash(theme) ^
      const DeepCollectionEquality().hash(metrics) ^
      const DeepCollectionEquality().hash(metricGroups) ^
      const DeepCollectionEquality().hash(events) ^
      const DeepCollectionEquality().hash(eventSettings) ^
      const DeepCollectionEquality().hash(metricSettings) ^
      const DeepCollectionEquality().hash(groups) ^
      runtimeType.hashCode;
}

extension $PatientSettingsExtension on PatientSettings {
  PatientSettings copyWith({
    int? patientId,
    int? version,
    enums.DatePreset? datePreset,
    enums.InterfaceTheme? theme,
    List<OrderedItem>? metrics,
    List<OrderedItem>? metricGroups,
    List<OrderedItem>? events,
    EventSettings? eventSettings,
    MetricSettings? metricSettings,
    MetricGroupSettings? groups,
  }) {
    return PatientSettings(
      patientId: patientId ?? this.patientId,
      version: version ?? this.version,
      datePreset: datePreset ?? this.datePreset,
      theme: theme ?? this.theme,
      metrics: metrics ?? this.metrics,
      metricGroups: metricGroups ?? this.metricGroups,
      events: events ?? this.events,
      eventSettings: eventSettings ?? this.eventSettings,
      metricSettings: metricSettings ?? this.metricSettings,
      groups: groups ?? this.groups,
    );
  }

  PatientSettings copyWithWrapped({
    Wrapped<int?>? patientId,
    Wrapped<int?>? version,
    Wrapped<enums.DatePreset?>? datePreset,
    Wrapped<enums.InterfaceTheme?>? theme,
    Wrapped<List<OrderedItem>?>? metrics,
    Wrapped<List<OrderedItem>?>? metricGroups,
    Wrapped<List<OrderedItem>?>? events,
    Wrapped<EventSettings?>? eventSettings,
    Wrapped<MetricSettings?>? metricSettings,
    Wrapped<MetricGroupSettings?>? groups,
  }) {
    return PatientSettings(
      patientId: (patientId != null ? patientId.value : this.patientId),
      version: (version != null ? version.value : this.version),
      datePreset: (datePreset != null ? datePreset.value : this.datePreset),
      theme: (theme != null ? theme.value : this.theme),
      metrics: (metrics != null ? metrics.value : this.metrics),
      metricGroups: (metricGroups != null
          ? metricGroups.value
          : this.metricGroups),
      events: (events != null ? events.value : this.events),
      eventSettings: (eventSettings != null
          ? eventSettings.value
          : this.eventSettings),
      metricSettings: (metricSettings != null
          ? metricSettings.value
          : this.metricSettings),
      groups: (groups != null ? groups.value : this.groups),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PatientsSettings {
  const PatientsSettings({this.version, this.$default, this.patients});

  factory PatientsSettings.fromJson(Map<String, dynamic> json) =>
      _$PatientsSettingsFromJson(json);

  static const toJsonFactory = _$PatientsSettingsToJson;
  Map<String, dynamic> toJson() => _$PatientsSettingsToJson(this);

  @JsonKey(name: 'version')
  final int? version;
  @JsonKey(name: 'default')
  final PatientSettings? $default;
  @JsonKey(name: 'patients', defaultValue: <PatientSettings>[])
  final List<PatientSettings>? patients;
  static const fromJsonFactory = _$PatientsSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PatientsSettings &&
            (identical(other.version, version) ||
                const DeepCollectionEquality().equals(
                  other.version,
                  version,
                )) &&
            (identical(other.$default, $default) ||
                const DeepCollectionEquality().equals(
                  other.$default,
                  $default,
                )) &&
            (identical(other.patients, patients) ||
                const DeepCollectionEquality().equals(
                  other.patients,
                  patients,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash($default) ^
      const DeepCollectionEquality().hash(patients) ^
      runtimeType.hashCode;
}

extension $PatientsSettingsExtension on PatientsSettings {
  PatientsSettings copyWith({
    int? version,
    PatientSettings? $default,
    List<PatientSettings>? patients,
  }) {
    return PatientsSettings(
      version: version ?? this.version,
      $default: $default ?? this.$default,
      patients: patients ?? this.patients,
    );
  }

  PatientsSettings copyWithWrapped({
    Wrapped<int?>? version,
    Wrapped<PatientSettings?>? $default,
    Wrapped<List<PatientSettings>?>? patients,
  }) {
    return PatientsSettings(
      version: (version != null ? version.value : this.version),
      $default: ($default != null ? $default.value : this.$default),
      patients: (patients != null ? patients.value : this.patients),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Person {
  const Person({
    required this.id,
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
  final int id;
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
    Wrapped<int>? id,
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
class SearchEvent {
  const SearchEvent({
    required this.type,
    this.value,
    this.from,
    this.to,
    this.source,
    this.filterSource,
  });

  factory SearchEvent.fromJson(Map<String, dynamic> json) =>
      _$SearchEventFromJson(json);

  static const toJsonFactory = _$SearchEventToJson;
  Map<String, dynamic> toJson() => _$SearchEventToJson(this);

  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'value')
  final String? value;
  @JsonKey(name: 'from')
  final DateTime? from;
  @JsonKey(name: 'to')
  final DateTime? to;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'filterSource')
  final bool? filterSource;
  static const fromJsonFactory = _$SearchEventFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchEvent &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.from, from) ||
                const DeepCollectionEquality().equals(other.from, from)) &&
            (identical(other.to, to) ||
                const DeepCollectionEquality().equals(other.to, to)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.filterSource, filterSource) ||
                const DeepCollectionEquality().equals(
                  other.filterSource,
                  filterSource,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(from) ^
      const DeepCollectionEquality().hash(to) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(filterSource) ^
      runtimeType.hashCode;
}

extension $SearchEventExtension on SearchEvent {
  SearchEvent copyWith({
    int? type,
    String? value,
    DateTime? from,
    DateTime? to,
    enums.ImportTypes? source,
    bool? filterSource,
  }) {
    return SearchEvent(
      type: type ?? this.type,
      value: value ?? this.value,
      from: from ?? this.from,
      to: to ?? this.to,
      source: source ?? this.source,
      filterSource: filterSource ?? this.filterSource,
    );
  }

  SearchEvent copyWithWrapped({
    Wrapped<int>? type,
    Wrapped<String?>? value,
    Wrapped<DateTime?>? from,
    Wrapped<DateTime?>? to,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<bool?>? filterSource,
  }) {
    return SearchEvent(
      type: (type != null ? type.value : this.type),
      value: (value != null ? value.value : this.value),
      from: (from != null ? from.value : this.from),
      to: (to != null ? to.value : this.to),
      source: (source != null ? source.value : this.source),
      filterSource: (filterSource != null
          ? filterSource.value
          : this.filterSource),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class SearchMetric {
  const SearchMetric({
    required this.type,
    this.value,
    this.from,
    this.to,
    this.minValue,
    this.maxValue,
    this.source,
    this.isTrue,
    this.filterSource,
  });

  factory SearchMetric.fromJson(Map<String, dynamic> json) =>
      _$SearchMetricFromJson(json);

  static const toJsonFactory = _$SearchMetricToJson;
  Map<String, dynamic> toJson() => _$SearchMetricToJson(this);

  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'value')
  final String? value;
  @JsonKey(name: 'from')
  final DateTime? from;
  @JsonKey(name: 'to')
  final DateTime? to;
  @JsonKey(name: 'minValue')
  final int? minValue;
  @JsonKey(name: 'maxValue')
  final int? maxValue;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'isTrue')
  final bool? isTrue;
  @JsonKey(name: 'filterSource')
  final bool? filterSource;
  static const fromJsonFactory = _$SearchMetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchMetric &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.from, from) ||
                const DeepCollectionEquality().equals(other.from, from)) &&
            (identical(other.to, to) ||
                const DeepCollectionEquality().equals(other.to, to)) &&
            (identical(other.minValue, minValue) ||
                const DeepCollectionEquality().equals(
                  other.minValue,
                  minValue,
                )) &&
            (identical(other.maxValue, maxValue) ||
                const DeepCollectionEquality().equals(
                  other.maxValue,
                  maxValue,
                )) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.isTrue, isTrue) ||
                const DeepCollectionEquality().equals(other.isTrue, isTrue)) &&
            (identical(other.filterSource, filterSource) ||
                const DeepCollectionEquality().equals(
                  other.filterSource,
                  filterSource,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(from) ^
      const DeepCollectionEquality().hash(to) ^
      const DeepCollectionEquality().hash(minValue) ^
      const DeepCollectionEquality().hash(maxValue) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(isTrue) ^
      const DeepCollectionEquality().hash(filterSource) ^
      runtimeType.hashCode;
}

extension $SearchMetricExtension on SearchMetric {
  SearchMetric copyWith({
    int? type,
    String? value,
    DateTime? from,
    DateTime? to,
    int? minValue,
    int? maxValue,
    enums.ImportTypes? source,
    bool? isTrue,
    bool? filterSource,
  }) {
    return SearchMetric(
      type: type ?? this.type,
      value: value ?? this.value,
      from: from ?? this.from,
      to: to ?? this.to,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      source: source ?? this.source,
      isTrue: isTrue ?? this.isTrue,
      filterSource: filterSource ?? this.filterSource,
    );
  }

  SearchMetric copyWithWrapped({
    Wrapped<int>? type,
    Wrapped<String?>? value,
    Wrapped<DateTime?>? from,
    Wrapped<DateTime?>? to,
    Wrapped<int?>? minValue,
    Wrapped<int?>? maxValue,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<bool?>? isTrue,
    Wrapped<bool?>? filterSource,
  }) {
    return SearchMetric(
      type: (type != null ? type.value : this.type),
      value: (value != null ? value.value : this.value),
      from: (from != null ? from.value : this.from),
      to: (to != null ? to.value : this.to),
      minValue: (minValue != null ? minValue.value : this.minValue),
      maxValue: (maxValue != null ? maxValue.value : this.maxValue),
      source: (source != null ? source.value : this.source),
      isTrue: (isTrue != null ? isTrue.value : this.isTrue),
      filterSource: (filterSource != null
          ? filterSource.value
          : this.filterSource),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Session {
  const Session({
    required this.sessionId,
    this.ip,
    this.location,
    this.userAgent,
    this.start,
    this.stop,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  static const toJsonFactory = _$SessionToJson;
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @JsonKey(name: 'sessionId')
  final String sessionId;
  @JsonKey(name: 'ip')
  final String? ip;
  @JsonKey(name: 'location')
  final String? location;
  @JsonKey(name: 'userAgent')
  final String? userAgent;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  static const fromJsonFactory = _$SessionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Session &&
            (identical(other.sessionId, sessionId) ||
                const DeepCollectionEquality().equals(
                  other.sessionId,
                  sessionId,
                )) &&
            (identical(other.ip, ip) ||
                const DeepCollectionEquality().equals(other.ip, ip)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.userAgent, userAgent) ||
                const DeepCollectionEquality().equals(
                  other.userAgent,
                  userAgent,
                )) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(sessionId) ^
      const DeepCollectionEquality().hash(ip) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(userAgent) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      runtimeType.hashCode;
}

extension $SessionExtension on Session {
  Session copyWith({
    String? sessionId,
    String? ip,
    String? location,
    String? userAgent,
    DateTime? start,
    DateTime? stop,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      ip: ip ?? this.ip,
      location: location ?? this.location,
      userAgent: userAgent ?? this.userAgent,
      start: start ?? this.start,
      stop: stop ?? this.stop,
    );
  }

  Session copyWithWrapped({
    Wrapped<String>? sessionId,
    Wrapped<String?>? ip,
    Wrapped<String?>? location,
    Wrapped<String?>? userAgent,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
  }) {
    return Session(
      sessionId: (sessionId != null ? sessionId.value : this.sessionId),
      ip: (ip != null ? ip.value : this.ip),
      location: (location != null ? location.value : this.location),
      userAgent: (userAgent != null ? userAgent.value : this.userAgent),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
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
class Unit {
  const Unit({
    required this.type,
    required this.id,
    required this.code,
    this.description,
    this.baseUnit,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  static const toJsonFactory = _$UnitToJson;
  Map<String, dynamic> toJson() => _$UnitToJson(this);

  @JsonKey(name: 'type', toJson: unitTypeToJson, fromJson: unitTypeFromJson)
  final enums.UnitType type;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'baseUnit')
  final dynamic baseUnit;
  static const fromJsonFactory = _$UnitFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Unit &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.baseUnit, baseUnit) ||
                const DeepCollectionEquality().equals(
                  other.baseUnit,
                  baseUnit,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(baseUnit) ^
      runtimeType.hashCode;
}

extension $UnitExtension on Unit {
  Unit copyWith({
    enums.UnitType? type,
    int? id,
    String? code,
    String? description,
    dynamic baseUnit,
  }) {
    return Unit(
      type: type ?? this.type,
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      baseUnit: baseUnit ?? this.baseUnit,
    );
  }

  Unit copyWithWrapped({
    Wrapped<enums.UnitType>? type,
    Wrapped<int>? id,
    Wrapped<String>? code,
    Wrapped<String?>? description,
    Wrapped<dynamic>? baseUnit,
  }) {
    return Unit(
      type: (type != null ? type.value : this.type),
      id: (id != null ? id.value : this.id),
      code: (code != null ? code.value : this.code),
      description: (description != null ? description.value : this.description),
      baseUnit: (baseUnit != null ? baseUnit.value : this.baseUnit),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateEvent {
  const UpdateEvent({
    this.id,
    required this.type,
    this.description,
    required this.start,
    required this.stop,
    this.tag,
    this.notificationTime,
    this.source,
    this.sourceId,
  });

  factory UpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventFromJson(json);

  static const toJsonFactory = _$UpdateEventToJson;
  Map<String, dynamic> toJson() => _$UpdateEventToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime start;
  @JsonKey(name: 'stop')
  final DateTime stop;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'notificationTime')
  final DateTime? notificationTime;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String? sourceId;
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
                )) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
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
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
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
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return UpdateEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      tag: tag ?? this.tag,
      notificationTime: notificationTime ?? this.notificationTime,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  UpdateEvent copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int>? type,
    Wrapped<String?>? description,
    Wrapped<DateTime>? start,
    Wrapped<DateTime>? stop,
    Wrapped<String?>? tag,
    Wrapped<DateTime?>? notificationTime,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String?>? sourceId,
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
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateEventType {
  const UpdateEventType({
    required this.id,
    required this.name,
    this.description,
    this.standAlone,
    this.visible,
    this.timeDifference,
    required this.groupId,
  });

  factory UpdateEventType.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventTypeFromJson(json);

  static const toJsonFactory = _$UpdateEventTypeToJson;
  Map<String, dynamic> toJson() => _$UpdateEventTypeToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'standAlone')
  final bool? standAlone;
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'timeDifference')
  final String? timeDifference;
  @JsonKey(name: 'groupId')
  final int groupId;
  static const fromJsonFactory = _$UpdateEventTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateEventType &&
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
            (identical(other.visible, visible) ||
                const DeepCollectionEquality().equals(
                  other.visible,
                  visible,
                )) &&
            (identical(other.timeDifference, timeDifference) ||
                const DeepCollectionEquality().equals(
                  other.timeDifference,
                  timeDifference,
                )) &&
            (identical(other.groupId, groupId) ||
                const DeepCollectionEquality().equals(other.groupId, groupId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(standAlone) ^
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(timeDifference) ^
      const DeepCollectionEquality().hash(groupId) ^
      runtimeType.hashCode;
}

extension $UpdateEventTypeExtension on UpdateEventType {
  UpdateEventType copyWith({
    int? id,
    String? name,
    String? description,
    bool? standAlone,
    bool? visible,
    String? timeDifference,
    int? groupId,
  }) {
    return UpdateEventType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      standAlone: standAlone ?? this.standAlone,
      visible: visible ?? this.visible,
      timeDifference: timeDifference ?? this.timeDifference,
      groupId: groupId ?? this.groupId,
    );
  }

  UpdateEventType copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<bool?>? standAlone,
    Wrapped<bool?>? visible,
    Wrapped<String?>? timeDifference,
    Wrapped<int>? groupId,
  }) {
    return UpdateEventType(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      standAlone: (standAlone != null ? standAlone.value : this.standAlone),
      visible: (visible != null ? visible.value : this.visible),
      timeDifference: (timeDifference != null
          ? timeDifference.value
          : this.timeDifference),
      groupId: (groupId != null ? groupId.value : this.groupId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateFile {
  const UpdateFile({
    this.id,
    required this.dataType,
    this.type,
    this.start,
    this.stop,
    required this.name,
    required this.description,
  });

  factory UpdateFile.fromJson(Map<String, dynamic> json) =>
      _$UpdateFileFromJson(json);

  static const toJsonFactory = _$UpdateFileToJson;
  Map<String, dynamic> toJson() => _$UpdateFileToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'dataType')
  final String dataType;
  @JsonKey(
    name: 'type',
    toJson: fileTypeNullableToJson,
    fromJson: fileTypeNullableFromJson,
  )
  final enums.FileType? type;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  static const fromJsonFactory = _$UpdateFileFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateFile &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.dataType, dataType) ||
                const DeepCollectionEquality().equals(
                  other.dataType,
                  dataType,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(dataType) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $UpdateFileExtension on UpdateFile {
  UpdateFile copyWith({
    int? id,
    String? dataType,
    enums.FileType? type,
    DateTime? start,
    DateTime? stop,
    String? name,
    String? description,
  }) {
    return UpdateFile(
      id: id ?? this.id,
      dataType: dataType ?? this.dataType,
      type: type ?? this.type,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  UpdateFile copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String>? dataType,
    Wrapped<enums.FileType?>? type,
    Wrapped<DateTime?>? start,
    Wrapped<DateTime?>? stop,
    Wrapped<String>? name,
    Wrapped<String>? description,
  }) {
    return UpdateFile(
      id: (id != null ? id.value : this.id),
      dataType: (dataType != null ? dataType.value : this.dataType),
      type: (type != null ? type.value : this.type),
      start: (start != null ? start.value : this.start),
      stop: (stop != null ? stop.value : this.stop),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateGroup {
  const UpdateGroup({
    this.id,
    required this.name,
    required this.description,
    this.showOnDashboard,
    this.showTitle,
  });

  factory UpdateGroup.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupFromJson(json);

  static const toJsonFactory = _$UpdateGroupToJson;
  Map<String, dynamic> toJson() => _$UpdateGroupToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'showTitle')
  final bool? showTitle;
  static const fromJsonFactory = _$UpdateGroupFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateGroup &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
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
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(showTitle) ^
      runtimeType.hashCode;
}

extension $UpdateGroupExtension on UpdateGroup {
  UpdateGroup copyWith({
    int? id,
    String? name,
    String? description,
    bool? showOnDashboard,
    bool? showTitle,
  }) {
    return UpdateGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      showTitle: showTitle ?? this.showTitle,
    );
  }

  UpdateGroup copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String>? name,
    Wrapped<String>? description,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<bool?>? showTitle,
  }) {
    return UpdateGroup(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      showTitle: (showTitle != null ? showTitle.value : this.showTitle),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateMetric {
  const UpdateMetric({
    this.id,
    this.unit,
    required this.date,
    required this.value,
    this.tag,
    required this.type,
    this.source,
    required this.sourceId,
  });

  factory UpdateMetric.fromJson(Map<String, dynamic> json) =>
      _$UpdateMetricFromJson(json);

  static const toJsonFactory = _$UpdateMetricToJson;
  Map<String, dynamic> toJson() => _$UpdateMetricToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'unit')
  final int? unit;
  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(
    name: 'source',
    toJson: importTypesNullableToJson,
    fromJson: importTypesNullableFromJson,
  )
  final enums.ImportTypes? source;
  @JsonKey(name: 'sourceId')
  final String sourceId;
  static const fromJsonFactory = _$UpdateMetricFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateMetric &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.sourceId, sourceId) ||
                const DeepCollectionEquality().equals(
                  other.sourceId,
                  sourceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(sourceId) ^
      runtimeType.hashCode;
}

extension $UpdateMetricExtension on UpdateMetric {
  UpdateMetric copyWith({
    int? id,
    int? unit,
    DateTime? date,
    String? value,
    String? tag,
    int? type,
    enums.ImportTypes? source,
    String? sourceId,
  }) {
    return UpdateMetric(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  UpdateMetric copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? unit,
    Wrapped<DateTime>? date,
    Wrapped<String>? value,
    Wrapped<String?>? tag,
    Wrapped<int>? type,
    Wrapped<enums.ImportTypes?>? source,
    Wrapped<String>? sourceId,
  }) {
    return UpdateMetric(
      id: (id != null ? id.value : this.id),
      unit: (unit != null ? unit.value : this.unit),
      date: (date != null ? date.value : this.date),
      value: (value != null ? value.value : this.value),
      tag: (tag != null ? tag.value : this.tag),
      type: (type != null ? type.value : this.type),
      source: (source != null ? source.value : this.source),
      sourceId: (sourceId != null ? sourceId.value : this.sourceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateMetricType {
  const UpdateMetricType({
    required this.id,
    required this.unit,
    required this.name,
    this.summaryType,
    this.description,
    this.type,
    this.visible,
    this.showOnDashboard,
    required this.groupId,
    this.valueCount,
    this.timeDifference,
  });

  factory UpdateMetricType.fromJson(Map<String, dynamic> json) =>
      _$UpdateMetricTypeFromJson(json);

  static const toJsonFactory = _$UpdateMetricTypeToJson;
  Map<String, dynamic> toJson() => _$UpdateMetricTypeToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'unit')
  final int unit;
  @JsonKey(name: 'name')
  final String name;
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
  @JsonKey(name: 'visible')
  final bool? visible;
  @JsonKey(name: 'showOnDashboard')
  final bool? showOnDashboard;
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'valueCount')
  final int? valueCount;
  @JsonKey(name: 'timeDifference')
  final String? timeDifference;
  static const fromJsonFactory = _$UpdateMetricTypeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateMetricType &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
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
                const DeepCollectionEquality().equals(
                  other.groupId,
                  groupId,
                )) &&
            (identical(other.valueCount, valueCount) ||
                const DeepCollectionEquality().equals(
                  other.valueCount,
                  valueCount,
                )) &&
            (identical(other.timeDifference, timeDifference) ||
                const DeepCollectionEquality().equals(
                  other.timeDifference,
                  timeDifference,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(unit) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(summaryType) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(visible) ^
      const DeepCollectionEquality().hash(showOnDashboard) ^
      const DeepCollectionEquality().hash(groupId) ^
      const DeepCollectionEquality().hash(valueCount) ^
      const DeepCollectionEquality().hash(timeDifference) ^
      runtimeType.hashCode;
}

extension $UpdateMetricTypeExtension on UpdateMetricType {
  UpdateMetricType copyWith({
    int? id,
    int? unit,
    String? name,
    enums.MetricSummary? summaryType,
    String? description,
    enums.MetricDataType? type,
    bool? visible,
    bool? showOnDashboard,
    int? groupId,
    int? valueCount,
    String? timeDifference,
  }) {
    return UpdateMetricType(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      summaryType: summaryType ?? this.summaryType,
      description: description ?? this.description,
      type: type ?? this.type,
      visible: visible ?? this.visible,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      groupId: groupId ?? this.groupId,
      valueCount: valueCount ?? this.valueCount,
      timeDifference: timeDifference ?? this.timeDifference,
    );
  }

  UpdateMetricType copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<int>? unit,
    Wrapped<String>? name,
    Wrapped<enums.MetricSummary?>? summaryType,
    Wrapped<String?>? description,
    Wrapped<enums.MetricDataType?>? type,
    Wrapped<bool?>? visible,
    Wrapped<bool?>? showOnDashboard,
    Wrapped<int>? groupId,
    Wrapped<int?>? valueCount,
    Wrapped<String?>? timeDifference,
  }) {
    return UpdateMetricType(
      id: (id != null ? id.value : this.id),
      unit: (unit != null ? unit.value : this.unit),
      name: (name != null ? name.value : this.name),
      summaryType: (summaryType != null ? summaryType.value : this.summaryType),
      description: (description != null ? description.value : this.description),
      type: (type != null ? type.value : this.type),
      visible: (visible != null ? visible.value : this.visible),
      showOnDashboard: (showOnDashboard != null
          ? showOnDashboard.value
          : this.showOnDashboard),
      groupId: (groupId != null ? groupId.value : this.groupId),
      valueCount: (valueCount != null ? valueCount.value : this.valueCount),
      timeDifference: (timeDifference != null
          ? timeDifference.value
          : this.timeDifference),
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
class UserCreationStats {
  const UserCreationStats({required this.userCount});

  factory UserCreationStats.fromJson(Map<String, dynamic> json) =>
      _$UserCreationStatsFromJson(json);

  static const toJsonFactory = _$UserCreationStatsToJson;
  Map<String, dynamic> toJson() => _$UserCreationStatsToJson(this);

  @JsonKey(name: 'userCount', defaultValue: <CountRecord>[])
  final List<CountRecord> userCount;
  static const fromJsonFactory = _$UserCreationStatsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCreationStats &&
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

extension $UserCreationStatsExtension on UserCreationStats {
  UserCreationStats copyWith({List<CountRecord>? userCount}) {
    return UserCreationStats(userCount: userCount ?? this.userCount);
  }

  UserCreationStats copyWithWrapped({Wrapped<List<CountRecord>>? userCount}) {
    return UserCreationStats(
      userCount: (userCount != null ? userCount.value : this.userCount),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserId {
  const UserId({required this.person, this.user});

  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);

  static const toJsonFactory = _$UserIdToJson;
  Map<String, dynamic> toJson() => _$UserIdToJson(this);

  @JsonKey(name: 'person')
  final int person;
  @JsonKey(name: 'user')
  final int? user;
  static const fromJsonFactory = _$UserIdFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserId &&
            (identical(other.person, person) ||
                const DeepCollectionEquality().equals(other.person, person)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(person) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $UserIdExtension on UserId {
  UserId copyWith({int? person, int? user}) {
    return UserId(person: person ?? this.person, user: user ?? this.user);
  }

  UserId copyWithWrapped({Wrapped<int>? person, Wrapped<int?>? user}) {
    return UserId(
      person: (person != null ? person.value : this.person),
      user: (user != null ? user.value : this.user),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserSettings {
  const UserSettings({
    this.version,
    this.datePreset,
    this.theme,
    this.metrics,
    this.metricGroups,
    this.events,
    this.eventSettings,
    this.metricSettings,
    this.groups,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  static const toJsonFactory = _$UserSettingsToJson;
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  @JsonKey(name: 'version')
  final int? version;
  @JsonKey(
    name: 'datePreset',
    toJson: datePresetNullableToJson,
    fromJson: datePresetNullableFromJson,
  )
  final enums.DatePreset? datePreset;
  @JsonKey(
    name: 'theme',
    toJson: interfaceThemeNullableToJson,
    fromJson: interfaceThemeNullableFromJson,
  )
  final enums.InterfaceTheme? theme;
  @JsonKey(name: 'metrics', defaultValue: <OrderedItem>[])
  final List<OrderedItem>? metrics;
  @JsonKey(name: 'metricGroups', defaultValue: <OrderedItem>[])
  final List<OrderedItem>? metricGroups;
  @JsonKey(name: 'events', defaultValue: <OrderedItem>[])
  final List<OrderedItem>? events;
  @JsonKey(name: 'eventSettings')
  final EventSettings? eventSettings;
  @JsonKey(name: 'metricSettings')
  final MetricSettings? metricSettings;
  @JsonKey(name: 'groups')
  final MetricGroupSettings? groups;
  static const fromJsonFactory = _$UserSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserSettings &&
            (identical(other.version, version) ||
                const DeepCollectionEquality().equals(
                  other.version,
                  version,
                )) &&
            (identical(other.datePreset, datePreset) ||
                const DeepCollectionEquality().equals(
                  other.datePreset,
                  datePreset,
                )) &&
            (identical(other.theme, theme) ||
                const DeepCollectionEquality().equals(other.theme, theme)) &&
            (identical(other.metrics, metrics) ||
                const DeepCollectionEquality().equals(
                  other.metrics,
                  metrics,
                )) &&
            (identical(other.metricGroups, metricGroups) ||
                const DeepCollectionEquality().equals(
                  other.metricGroups,
                  metricGroups,
                )) &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)) &&
            (identical(other.eventSettings, eventSettings) ||
                const DeepCollectionEquality().equals(
                  other.eventSettings,
                  eventSettings,
                )) &&
            (identical(other.metricSettings, metricSettings) ||
                const DeepCollectionEquality().equals(
                  other.metricSettings,
                  metricSettings,
                )) &&
            (identical(other.groups, groups) ||
                const DeepCollectionEquality().equals(other.groups, groups)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(datePreset) ^
      const DeepCollectionEquality().hash(theme) ^
      const DeepCollectionEquality().hash(metrics) ^
      const DeepCollectionEquality().hash(metricGroups) ^
      const DeepCollectionEquality().hash(events) ^
      const DeepCollectionEquality().hash(eventSettings) ^
      const DeepCollectionEquality().hash(metricSettings) ^
      const DeepCollectionEquality().hash(groups) ^
      runtimeType.hashCode;
}

extension $UserSettingsExtension on UserSettings {
  UserSettings copyWith({
    int? version,
    enums.DatePreset? datePreset,
    enums.InterfaceTheme? theme,
    List<OrderedItem>? metrics,
    List<OrderedItem>? metricGroups,
    List<OrderedItem>? events,
    EventSettings? eventSettings,
    MetricSettings? metricSettings,
    MetricGroupSettings? groups,
  }) {
    return UserSettings(
      version: version ?? this.version,
      datePreset: datePreset ?? this.datePreset,
      theme: theme ?? this.theme,
      metrics: metrics ?? this.metrics,
      metricGroups: metricGroups ?? this.metricGroups,
      events: events ?? this.events,
      eventSettings: eventSettings ?? this.eventSettings,
      metricSettings: metricSettings ?? this.metricSettings,
      groups: groups ?? this.groups,
    );
  }

  UserSettings copyWithWrapped({
    Wrapped<int?>? version,
    Wrapped<enums.DatePreset?>? datePreset,
    Wrapped<enums.InterfaceTheme?>? theme,
    Wrapped<List<OrderedItem>?>? metrics,
    Wrapped<List<OrderedItem>?>? metricGroups,
    Wrapped<List<OrderedItem>?>? events,
    Wrapped<EventSettings?>? eventSettings,
    Wrapped<MetricSettings?>? metricSettings,
    Wrapped<MetricGroupSettings?>? groups,
  }) {
    return UserSettings(
      version: (version != null ? version.value : this.version),
      datePreset: (datePreset != null ? datePreset.value : this.datePreset),
      theme: (theme != null ? theme.value : this.theme),
      metrics: (metrics != null ? metrics.value : this.metrics),
      metricGroups: (metricGroups != null
          ? metricGroups.value
          : this.metricGroups),
      events: (events != null ? events.value : this.events),
      eventSettings: (eventSettings != null
          ? eventSettings.value
          : this.eventSettings),
      metricSettings: (metricSettings != null
          ? metricSettings.value
          : this.metricSettings),
      groups: (groups != null ? groups.value : this.groups),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiFilesDataIdPost$RequestBody {
  const ApiFilesDataIdPost$RequestBody({required this.file});

  factory ApiFilesDataIdPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiFilesDataIdPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$ApiFilesDataIdPost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$ApiFilesDataIdPost$RequestBodyToJson(this);

  @JsonKey(name: 'file')
  final String file;
  static const fromJsonFactory = _$ApiFilesDataIdPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiFilesDataIdPost$RequestBody &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(file) ^ runtimeType.hashCode;
}

extension $ApiFilesDataIdPost$RequestBodyExtension
    on ApiFilesDataIdPost$RequestBody {
  ApiFilesDataIdPost$RequestBody copyWith({String? file}) {
    return ApiFilesDataIdPost$RequestBody(file: file ?? this.file);
  }

  ApiFilesDataIdPost$RequestBody copyWithWrapped({Wrapped<String>? file}) {
    return ApiFilesDataIdPost$RequestBody(
      file: (file != null ? file.value : this.file),
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

String? datePresetNullableToJson(enums.DatePreset? datePreset) {
  return datePreset?.value;
}

String? datePresetToJson(enums.DatePreset datePreset) {
  return datePreset.value;
}

enums.DatePreset datePresetFromJson(
  Object? datePreset, [
  enums.DatePreset? defaultValue,
]) {
  return enums.DatePreset.values.firstWhereOrNull(
        (e) => e.value == datePreset,
      ) ??
      defaultValue ??
      enums.DatePreset.swaggerGeneratedUnknown;
}

enums.DatePreset? datePresetNullableFromJson(
  Object? datePreset, [
  enums.DatePreset? defaultValue,
]) {
  if (datePreset == null) {
    return null;
  }
  return enums.DatePreset.values.firstWhereOrNull(
        (e) => e.value == datePreset,
      ) ??
      defaultValue;
}

String datePresetExplodedListToJson(List<enums.DatePreset>? datePreset) {
  return datePreset?.map((e) => e.value!).join(',') ?? '';
}

List<String> datePresetListToJson(List<enums.DatePreset>? datePreset) {
  if (datePreset == null) {
    return [];
  }

  return datePreset.map((e) => e.value!).toList();
}

List<enums.DatePreset> datePresetListFromJson(
  List? datePreset, [
  List<enums.DatePreset>? defaultValue,
]) {
  if (datePreset == null) {
    return defaultValue ?? [];
  }

  return datePreset.map((e) => datePresetFromJson(e.toString())).toList();
}

List<enums.DatePreset>? datePresetNullableListFromJson(
  List? datePreset, [
  List<enums.DatePreset>? defaultValue,
]) {
  if (datePreset == null) {
    return defaultValue;
  }

  return datePreset.map((e) => datePresetFromJson(e.toString())).toList();
}

String? fileTypeNullableToJson(enums.FileType? fileType) {
  return fileType?.value;
}

String? fileTypeToJson(enums.FileType fileType) {
  return fileType.value;
}

enums.FileType fileTypeFromJson(
  Object? fileType, [
  enums.FileType? defaultValue,
]) {
  return enums.FileType.values.firstWhereOrNull((e) => e.value == fileType) ??
      defaultValue ??
      enums.FileType.swaggerGeneratedUnknown;
}

enums.FileType? fileTypeNullableFromJson(
  Object? fileType, [
  enums.FileType? defaultValue,
]) {
  if (fileType == null) {
    return null;
  }
  return enums.FileType.values.firstWhereOrNull((e) => e.value == fileType) ??
      defaultValue;
}

String fileTypeExplodedListToJson(List<enums.FileType>? fileType) {
  return fileType?.map((e) => e.value!).join(',') ?? '';
}

List<String> fileTypeListToJson(List<enums.FileType>? fileType) {
  if (fileType == null) {
    return [];
  }

  return fileType.map((e) => e.value!).toList();
}

List<enums.FileType> fileTypeListFromJson(
  List? fileType, [
  List<enums.FileType>? defaultValue,
]) {
  if (fileType == null) {
    return defaultValue ?? [];
  }

  return fileType.map((e) => fileTypeFromJson(e.toString())).toList();
}

List<enums.FileType>? fileTypeNullableListFromJson(
  List? fileType, [
  List<enums.FileType>? defaultValue,
]) {
  if (fileType == null) {
    return defaultValue;
  }

  return fileType.map((e) => fileTypeFromJson(e.toString())).toList();
}

String? graphKindNullableToJson(enums.GraphKind? graphKind) {
  return graphKind?.value;
}

String? graphKindToJson(enums.GraphKind graphKind) {
  return graphKind.value;
}

enums.GraphKind graphKindFromJson(
  Object? graphKind, [
  enums.GraphKind? defaultValue,
]) {
  return enums.GraphKind.values.firstWhereOrNull((e) => e.value == graphKind) ??
      defaultValue ??
      enums.GraphKind.swaggerGeneratedUnknown;
}

enums.GraphKind? graphKindNullableFromJson(
  Object? graphKind, [
  enums.GraphKind? defaultValue,
]) {
  if (graphKind == null) {
    return null;
  }
  return enums.GraphKind.values.firstWhereOrNull((e) => e.value == graphKind) ??
      defaultValue;
}

String graphKindExplodedListToJson(List<enums.GraphKind>? graphKind) {
  return graphKind?.map((e) => e.value!).join(',') ?? '';
}

List<String> graphKindListToJson(List<enums.GraphKind>? graphKind) {
  if (graphKind == null) {
    return [];
  }

  return graphKind.map((e) => e.value!).toList();
}

List<enums.GraphKind> graphKindListFromJson(
  List? graphKind, [
  List<enums.GraphKind>? defaultValue,
]) {
  if (graphKind == null) {
    return defaultValue ?? [];
  }

  return graphKind.map((e) => graphKindFromJson(e.toString())).toList();
}

List<enums.GraphKind>? graphKindNullableListFromJson(
  List? graphKind, [
  List<enums.GraphKind>? defaultValue,
]) {
  if (graphKind == null) {
    return defaultValue;
  }

  return graphKind.map((e) => graphKindFromJson(e.toString())).toList();
}

String? importTypesNullableToJson(enums.ImportTypes? importTypes) {
  return importTypes?.value;
}

String? importTypesToJson(enums.ImportTypes importTypes) {
  return importTypes.value;
}

enums.ImportTypes importTypesFromJson(
  Object? importTypes, [
  enums.ImportTypes? defaultValue,
]) {
  return enums.ImportTypes.values.firstWhereOrNull(
        (e) => e.value == importTypes,
      ) ??
      defaultValue ??
      enums.ImportTypes.swaggerGeneratedUnknown;
}

enums.ImportTypes? importTypesNullableFromJson(
  Object? importTypes, [
  enums.ImportTypes? defaultValue,
]) {
  if (importTypes == null) {
    return null;
  }
  return enums.ImportTypes.values.firstWhereOrNull(
        (e) => e.value == importTypes,
      ) ??
      defaultValue;
}

String importTypesExplodedListToJson(List<enums.ImportTypes>? importTypes) {
  return importTypes?.map((e) => e.value!).join(',') ?? '';
}

List<String> importTypesListToJson(List<enums.ImportTypes>? importTypes) {
  if (importTypes == null) {
    return [];
  }

  return importTypes.map((e) => e.value!).toList();
}

List<enums.ImportTypes> importTypesListFromJson(
  List? importTypes, [
  List<enums.ImportTypes>? defaultValue,
]) {
  if (importTypes == null) {
    return defaultValue ?? [];
  }

  return importTypes.map((e) => importTypesFromJson(e.toString())).toList();
}

List<enums.ImportTypes>? importTypesNullableListFromJson(
  List? importTypes, [
  List<enums.ImportTypes>? defaultValue,
]) {
  if (importTypes == null) {
    return defaultValue;
  }

  return importTypes.map((e) => importTypesFromJson(e.toString())).toList();
}

String? interfaceThemeNullableToJson(enums.InterfaceTheme? interfaceTheme) {
  return interfaceTheme?.value;
}

String? interfaceThemeToJson(enums.InterfaceTheme interfaceTheme) {
  return interfaceTheme.value;
}

enums.InterfaceTheme interfaceThemeFromJson(
  Object? interfaceTheme, [
  enums.InterfaceTheme? defaultValue,
]) {
  return enums.InterfaceTheme.values.firstWhereOrNull(
        (e) => e.value == interfaceTheme,
      ) ??
      defaultValue ??
      enums.InterfaceTheme.swaggerGeneratedUnknown;
}

enums.InterfaceTheme? interfaceThemeNullableFromJson(
  Object? interfaceTheme, [
  enums.InterfaceTheme? defaultValue,
]) {
  if (interfaceTheme == null) {
    return null;
  }
  return enums.InterfaceTheme.values.firstWhereOrNull(
        (e) => e.value == interfaceTheme,
      ) ??
      defaultValue;
}

String interfaceThemeExplodedListToJson(
  List<enums.InterfaceTheme>? interfaceTheme,
) {
  return interfaceTheme?.map((e) => e.value!).join(',') ?? '';
}

List<String> interfaceThemeListToJson(
  List<enums.InterfaceTheme>? interfaceTheme,
) {
  if (interfaceTheme == null) {
    return [];
  }

  return interfaceTheme.map((e) => e.value!).toList();
}

List<enums.InterfaceTheme> interfaceThemeListFromJson(
  List? interfaceTheme, [
  List<enums.InterfaceTheme>? defaultValue,
]) {
  if (interfaceTheme == null) {
    return defaultValue ?? [];
  }

  return interfaceTheme
      .map((e) => interfaceThemeFromJson(e.toString()))
      .toList();
}

List<enums.InterfaceTheme>? interfaceThemeNullableListFromJson(
  List? interfaceTheme, [
  List<enums.InterfaceTheme>? defaultValue,
]) {
  if (interfaceTheme == null) {
    return defaultValue;
  }

  return interfaceTheme
      .map((e) => interfaceThemeFromJson(e.toString()))
      .toList();
}

String? jobStatusNullableToJson(enums.JobStatus? jobStatus) {
  return jobStatus?.value;
}

String? jobStatusToJson(enums.JobStatus jobStatus) {
  return jobStatus.value;
}

enums.JobStatus jobStatusFromJson(
  Object? jobStatus, [
  enums.JobStatus? defaultValue,
]) {
  return enums.JobStatus.values.firstWhereOrNull((e) => e.value == jobStatus) ??
      defaultValue ??
      enums.JobStatus.swaggerGeneratedUnknown;
}

enums.JobStatus? jobStatusNullableFromJson(
  Object? jobStatus, [
  enums.JobStatus? defaultValue,
]) {
  if (jobStatus == null) {
    return null;
  }
  return enums.JobStatus.values.firstWhereOrNull((e) => e.value == jobStatus) ??
      defaultValue;
}

String jobStatusExplodedListToJson(List<enums.JobStatus>? jobStatus) {
  return jobStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> jobStatusListToJson(List<enums.JobStatus>? jobStatus) {
  if (jobStatus == null) {
    return [];
  }

  return jobStatus.map((e) => e.value!).toList();
}

List<enums.JobStatus> jobStatusListFromJson(
  List? jobStatus, [
  List<enums.JobStatus>? defaultValue,
]) {
  if (jobStatus == null) {
    return defaultValue ?? [];
  }

  return jobStatus.map((e) => jobStatusFromJson(e.toString())).toList();
}

List<enums.JobStatus>? jobStatusNullableListFromJson(
  List? jobStatus, [
  List<enums.JobStatus>? defaultValue,
]) {
  if (jobStatus == null) {
    return defaultValue;
  }

  return jobStatus.map((e) => jobStatusFromJson(e.toString())).toList();
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

String? unitTypeNullableToJson(enums.UnitType? unitType) {
  return unitType?.value;
}

String? unitTypeToJson(enums.UnitType unitType) {
  return unitType.value;
}

enums.UnitType unitTypeFromJson(
  Object? unitType, [
  enums.UnitType? defaultValue,
]) {
  return enums.UnitType.values.firstWhereOrNull((e) => e.value == unitType) ??
      defaultValue ??
      enums.UnitType.swaggerGeneratedUnknown;
}

enums.UnitType? unitTypeNullableFromJson(
  Object? unitType, [
  enums.UnitType? defaultValue,
]) {
  if (unitType == null) {
    return null;
  }
  return enums.UnitType.values.firstWhereOrNull((e) => e.value == unitType) ??
      defaultValue;
}

String unitTypeExplodedListToJson(List<enums.UnitType>? unitType) {
  return unitType?.map((e) => e.value!).join(',') ?? '';
}

List<String> unitTypeListToJson(List<enums.UnitType>? unitType) {
  if (unitType == null) {
    return [];
  }

  return unitType.map((e) => e.value!).toList();
}

List<enums.UnitType> unitTypeListFromJson(
  List? unitType, [
  List<enums.UnitType>? defaultValue,
]) {
  if (unitType == null) {
    return defaultValue ?? [];
  }

  return unitType.map((e) => unitTypeFromJson(e.toString())).toList();
}

List<enums.UnitType>? unitTypeNullableListFromJson(
  List? unitType, [
  List<enums.UnitType>? defaultValue,
]) {
  if (unitType == null) {
    return defaultValue;
  }

  return unitType.map((e) => unitTypeFromJson(e.toString())).toList();
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
