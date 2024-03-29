// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'swagger.enums.swagger.dart' as enums;
export 'swagger.enums.swagger.dart';

part 'swagger.swagger.chopper.dart';
part 'swagger.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Swagger extends ChopperService {
  static Swagger create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
        services: [_$Swagger()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Swagger(newClient);
  }

  ///
  Future<chopper.Response<String>> apiAuthPost({required Connection? body}) {
    return _apiAuthPost(body: body);
  }

  ///
  @Post(
    path: '/api/auth',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _apiAuthPost(
      {@Body() required Connection? body});

  ///
  Future<chopper.Response<Status>> apiStatusGet() {
    generatedMapping.putIfAbsent(Status, () => Status.fromJsonFactory);

    return _apiStatusGet();
  }

  ///
  @Get(path: '/api/status')
  Future<chopper.Response<Status>> _apiStatusGet();

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Event>>> apiEventsGet({
    int? type,
    required DateTime? start,
    required DateTime? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiEventsGet(
        type: type, start: start, end: end, personId: personId);
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @Get(path: '/api/events')
  Future<chopper.Response<List<Event>>> _apiEventsGet({
    @Query('type') int? type,
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
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
  @Post(
    path: '/api/events',
    optionalBody: true,
  )
  Future<chopper.Response> _apiEventsPost({
    @Query('personId') int? personId,
    @Body() required CreateEvent? body,
  });

  ///
  ///@param id
  Future<chopper.Response> apiEventsIdDelete({required int? id}) {
    return _apiEventsIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/api/events/{id}')
  Future<chopper.Response> _apiEventsIdDelete({@Path('id') required int? id});

  ///
  Future<chopper.Response> apiEventsTypePost({required EventType? body}) {
    return _apiEventsTypePost(body: body);
  }

  ///
  @Post(
    path: '/api/events/type',
    optionalBody: true,
  )
  Future<chopper.Response> _apiEventsTypePost(
      {@Body() required EventType? body});

  ///
  Future<chopper.Response> apiEventsTypePut({required MetricType? body}) {
    return _apiEventsTypePut(body: body);
  }

  ///
  @Put(
    path: '/api/events/type',
    optionalBody: true,
  )
  Future<chopper.Response> _apiEventsTypePut(
      {@Body() required MetricType? body});

  ///
  Future<chopper.Response<List<EventType>>> apiEventsTypeGet() {
    generatedMapping.putIfAbsent(EventType, () => EventType.fromJsonFactory);

    return _apiEventsTypeGet();
  }

  ///
  @Get(path: '/api/events/type')
  Future<chopper.Response<List<EventType>>> _apiEventsTypeGet();

  ///
  ///@param id
  Future<chopper.Response> apiEventsTypeIdDelete({required int? id}) {
    return _apiEventsTypeIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/api/events/type/{id}')
  Future<chopper.Response> _apiEventsTypeIdDelete(
      {@Path('id') required int? id});

  ///
  Future<chopper.Response<List<FileType>>> apiImportTypesGet() {
    generatedMapping.putIfAbsent(FileType, () => FileType.fromJsonFactory);

    return _apiImportTypesGet();
  }

  ///
  @Get(path: '/api/import/types')
  Future<chopper.Response<List<FileType>>> _apiImportTypesGet();

  ///
  ///@param type
  Future<chopper.Response> apiImportTypePost({
    required int? type,
    required String? body,
  }) {
    return _apiImportTypePost(type: type, body: body);
  }

  ///
  ///@param type
  @Post(
    path: '/api/import/{type}',
    optionalBody: true,
  )
  Future<chopper.Response> _apiImportTypePost({
    @Path('type') required int? type,
    @Body() required String? body,
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
        type: type, start: start, end: end, personId: personId);
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @Get(path: '/api/metrics')
  Future<chopper.Response<List<Metric>>> _apiMetricsGet({
    @Query('type') required int? type,
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
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
  @Post(
    path: '/api/metrics',
    optionalBody: true,
  )
  Future<chopper.Response> _apiMetricsPost({
    @Query('personId') int? personId,
    @Body() required CreateMetric? body,
  });

  ///
  ///@param id
  Future<chopper.Response> apiMetricsIdDelete({required int? id}) {
    return _apiMetricsIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/api/metrics/{id}')
  Future<chopper.Response> _apiMetricsIdDelete({@Path('id') required int? id});

  ///
  Future<chopper.Response> apiMetricsTypePost({required MetricType? body}) {
    return _apiMetricsTypePost(body: body);
  }

  ///
  @Post(
    path: '/api/metrics/type',
    optionalBody: true,
  )
  Future<chopper.Response> _apiMetricsTypePost(
      {@Body() required MetricType? body});

  ///
  Future<chopper.Response> apiMetricsTypePut({required MetricType? body}) {
    return _apiMetricsTypePut(body: body);
  }

  ///
  @Put(
    path: '/api/metrics/type',
    optionalBody: true,
  )
  Future<chopper.Response> _apiMetricsTypePut(
      {@Body() required MetricType? body});

  ///
  Future<chopper.Response<List<MetricType>>> apiMetricsTypeGet() {
    generatedMapping.putIfAbsent(MetricType, () => MetricType.fromJsonFactory);

    return _apiMetricsTypeGet();
  }

  ///
  @Get(path: '/api/metrics/type')
  Future<chopper.Response<List<MetricType>>> _apiMetricsTypeGet();

  ///
  ///@param id
  Future<chopper.Response> apiMetricsTypeIdDelete({required int? id}) {
    return _apiMetricsTypeIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/api/metrics/type/{id}')
  Future<chopper.Response> _apiMetricsTypeIdDelete(
      {@Path('id') required int? id});

  ///
  Future<chopper.Response<List<Person>>> apiPatientsGet() {
    generatedMapping.putIfAbsent(Person, () => Person.fromJsonFactory);

    return _apiPatientsGet();
  }

  ///
  @Get(path: '/api/patients')
  Future<chopper.Response<List<Person>>> _apiPatientsGet();

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
  @Get(path: '/api/patients/agenda')
  Future<chopper.Response<List<Event>>> _apiPatientsAgendaGet({
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
  });

  ///
  Future<chopper.Response> apiPersonPost({required PersonCreation? body}) {
    return _apiPersonPost(body: body);
  }

  ///
  @Post(
    path: '/api/person',
    optionalBody: true,
  )
  Future<chopper.Response> _apiPersonPost(
      {@Body() required PersonCreation? body});

  ///
  Future<chopper.Response<List<Person>>> apiPersonGet() {
    generatedMapping.putIfAbsent(Person, () => Person.fromJsonFactory);

    return _apiPersonGet();
  }

  ///
  @Get(path: '/api/person')
  Future<chopper.Response<List<Person>>> _apiPersonGet();

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
  @Post(
    path: '/api/person/rights/{personId}',
    optionalBody: true,
  )
  Future<chopper.Response> _apiPersonRightsPersonIdPost({
    @Path('personId') required int? personId,
    @Body() required List<Right>? body,
  });

  ///
  Future<chopper.Response> apiAdminSettingsPost({required Settings? body}) {
    return _apiAdminSettingsPost(body: body);
  }

  ///
  @Post(
    path: '/api/admin/settings',
    optionalBody: true,
  )
  Future<chopper.Response> _apiAdminSettingsPost(
      {@Body() required Settings? body});

  ///
  Future<chopper.Response<Settings>> apiAdminSettingsGet() {
    generatedMapping.putIfAbsent(Settings, () => Settings.fromJsonFactory);

    return _apiAdminSettingsGet();
  }

  ///
  @Get(path: '/api/admin/settings')
  Future<chopper.Response<Settings>> _apiAdminSettingsGet();

  ///
  Future<chopper.Response> apiTreatmentPost({required CreateTreatment? body}) {
    return _apiTreatmentPost(body: body);
  }

  ///
  @Post(
    path: '/api/treatment',
    optionalBody: true,
  )
  Future<chopper.Response> _apiTreatmentPost(
      {@Body() required CreateTreatment? body});

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
  @Get(path: '/api/treatment')
  Future<chopper.Response<List<Treatement>>> _apiTreatmentGet({
    @Query('start') required DateTime? start,
    @Query('end') required DateTime? end,
    @Query('personId') int? personId,
  });

  ///
  Future<chopper.Response<List<EventType>>> apiTreatmentTypeGet() {
    generatedMapping.putIfAbsent(EventType, () => EventType.fromJsonFactory);

    return _apiTreatmentTypeGet();
  }

  ///
  @Get(path: '/api/treatment/type')
  Future<chopper.Response<List<EventType>>> _apiTreatmentTypeGet();
}

@JsonSerializable(explicitToJson: true)
class Connection {
  const Connection({
    this.user,
    this.password,
  });

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);

  static const toJsonFactory = _$ConnectionToJson;
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);

  @JsonKey(name: 'user')
  final String? user;
  @JsonKey(name: 'password')
  final String? password;
  static const fromJsonFactory = _$ConnectionFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Connection &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $ConnectionExtension on Connection {
  Connection copyWith({String? user, String? password}) {
    return Connection(
        user: user ?? this.user, password: password ?? this.password);
  }

  Connection copyWithWrapped(
      {Wrapped<String?>? user, Wrapped<String?>? password}) {
    return Connection(
        user: (user != null ? user.value : this.user),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateEvent {
  const CreateEvent({
    this.type,
    this.description,
    this.start,
    this.stop,
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
  static const fromJsonFactory = _$CreateEventFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is CreateEvent &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      runtimeType.hashCode;
}

extension $CreateEventExtension on CreateEvent {
  CreateEvent copyWith(
      {int? type, String? description, DateTime? start, DateTime? stop}) {
    return CreateEvent(
        type: type ?? this.type,
        description: description ?? this.description,
        start: start ?? this.start,
        stop: stop ?? this.stop);
  }

  CreateEvent copyWithWrapped(
      {Wrapped<int?>? type,
      Wrapped<String?>? description,
      Wrapped<DateTime?>? start,
      Wrapped<DateTime?>? stop}) {
    return CreateEvent(
        type: (type != null ? type.value : this.type),
        description:
            (description != null ? description.value : this.description),
        start: (start != null ? start.value : this.start),
        stop: (stop != null ? stop.value : this.stop));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateMetric {
  const CreateMetric({
    this.date,
    this.value,
    this.tag,
    this.type,
  });

  factory CreateMetric.fromJson(Map<String, dynamic> json) =>
      _$CreateMetricFromJson(json);

  static const toJsonFactory = _$CreateMetricToJson;
  Map<String, dynamic> toJson() => _$CreateMetricToJson(this);

  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'value')
  final String? value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int? type;
  static const fromJsonFactory = _$CreateMetricFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is CreateMetric &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(type) ^
      runtimeType.hashCode;
}

extension $CreateMetricExtension on CreateMetric {
  CreateMetric copyWith(
      {DateTime? date, String? value, String? tag, int? type}) {
    return CreateMetric(
        date: date ?? this.date,
        value: value ?? this.value,
        tag: tag ?? this.tag,
        type: type ?? this.type);
  }

  CreateMetric copyWithWrapped(
      {Wrapped<DateTime?>? date,
      Wrapped<String?>? value,
      Wrapped<String?>? tag,
      Wrapped<int?>? type}) {
    return CreateMetric(
        date: (date != null ? date.value : this.date),
        value: (value != null ? value.value : this.value),
        tag: (tag != null ? tag.value : this.tag),
        type: (type != null ? type.value : this.type));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateTreatment {
  const CreateTreatment({
    this.events,
    this.personId,
  });

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is CreateTreatment &&
            (identical(other.events, events) ||
                const DeepCollectionEquality().equals(other.events, events)) &&
            (identical(other.personId, personId) ||
                const DeepCollectionEquality()
                    .equals(other.personId, personId)));
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
        events: events ?? this.events, personId: personId ?? this.personId);
  }

  CreateTreatment copyWithWrapped(
      {Wrapped<List<CreateEvent>?>? events, Wrapped<int?>? personId}) {
    return CreateTreatment(
        events: (events != null ? events.value : this.events),
        personId: (personId != null ? personId.value : this.personId));
  }
}

@JsonSerializable(explicitToJson: true)
class Event {
  const Event({
    this.type,
    this.description,
    this.start,
    this.stop,
    this.user,
    this.file,
    this.treatment,
    this.id,
    this.person,
    this.valid,
    this.address,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  static const toJsonFactory = _$EventToJson;
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
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
  static const fromJsonFactory = _$EventFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Event &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)) &&
            (identical(other.treatment, treatment) ||
                const DeepCollectionEquality()
                    .equals(other.treatment, treatment)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.person, person) ||
                const DeepCollectionEquality().equals(other.person, person)) &&
            (identical(other.valid, valid) ||
                const DeepCollectionEquality().equals(other.valid, valid)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality().equals(other.address, address)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(file) ^
      const DeepCollectionEquality().hash(treatment) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(person) ^
      const DeepCollectionEquality().hash(valid) ^
      const DeepCollectionEquality().hash(address) ^
      runtimeType.hashCode;
}

extension $EventExtension on Event {
  Event copyWith(
      {int? type,
      String? description,
      DateTime? start,
      DateTime? stop,
      int? user,
      int? file,
      int? treatment,
      int? id,
      int? person,
      bool? valid,
      int? address}) {
    return Event(
        type: type ?? this.type,
        description: description ?? this.description,
        start: start ?? this.start,
        stop: stop ?? this.stop,
        user: user ?? this.user,
        file: file ?? this.file,
        treatment: treatment ?? this.treatment,
        id: id ?? this.id,
        person: person ?? this.person,
        valid: valid ?? this.valid,
        address: address ?? this.address);
  }

  Event copyWithWrapped(
      {Wrapped<int?>? type,
      Wrapped<String?>? description,
      Wrapped<DateTime?>? start,
      Wrapped<DateTime?>? stop,
      Wrapped<int?>? user,
      Wrapped<int?>? file,
      Wrapped<int?>? treatment,
      Wrapped<int?>? id,
      Wrapped<int?>? person,
      Wrapped<bool?>? valid,
      Wrapped<int?>? address}) {
    return Event(
        type: (type != null ? type.value : this.type),
        description:
            (description != null ? description.value : this.description),
        start: (start != null ? start.value : this.start),
        stop: (stop != null ? stop.value : this.stop),
        user: (user != null ? user.value : this.user),
        file: (file != null ? file.value : this.file),
        treatment: (treatment != null ? treatment.value : this.treatment),
        id: (id != null ? id.value : this.id),
        person: (person != null ? person.value : this.person),
        valid: (valid != null ? valid.value : this.valid),
        address: (address != null ? address.value : this.address));
  }
}

@JsonSerializable(explicitToJson: true)
class EventType {
  const EventType({
    this.id,
    this.name,
    this.description,
    this.standAlone,
  });

  factory EventType.fromJson(Map<String, dynamic> json) =>
      _$EventTypeFromJson(json);

  static const toJsonFactory = _$EventTypeToJson;
  Map<String, dynamic> toJson() => _$EventTypeToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'standAlone')
  final bool? standAlone;
  static const fromJsonFactory = _$EventTypeFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EventType &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.standAlone, standAlone) ||
                const DeepCollectionEquality()
                    .equals(other.standAlone, standAlone)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(standAlone) ^
      runtimeType.hashCode;
}

extension $EventTypeExtension on EventType {
  EventType copyWith(
      {int? id, String? name, String? description, bool? standAlone}) {
    return EventType(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        standAlone: standAlone ?? this.standAlone);
  }

  EventType copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<String?>? name,
      Wrapped<String?>? description,
      Wrapped<bool?>? standAlone}) {
    return EventType(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        standAlone: (standAlone != null ? standAlone.value : this.standAlone));
  }
}

@JsonSerializable(explicitToJson: true)
class FileType {
  const FileType({
    this.type,
    this.name,
  });

  factory FileType.fromJson(Map<String, dynamic> json) =>
      _$FileTypeFromJson(json);

  static const toJsonFactory = _$FileTypeToJson;
  Map<String, dynamic> toJson() => _$FileTypeToJson(this);

  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'name')
  final String? name;
  static const fromJsonFactory = _$FileTypeFromJson;

  @override
  bool operator ==(dynamic other) {
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

  FileType copyWithWrapped({Wrapped<int?>? type, Wrapped<String?>? name}) {
    return FileType(
        type: (type != null ? type.value : this.type),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class Metric {
  const Metric({
    this.id,
    this.person,
    this.user,
    this.date,
    this.value,
    this.tag,
    this.type,
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
  final String? value;
  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'type')
  final int? type;
  static const fromJsonFactory = _$MetricFromJson;

  @override
  bool operator ==(dynamic other) {
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
                const DeepCollectionEquality().equals(other.type, type)));
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
      runtimeType.hashCode;
}

extension $MetricExtension on Metric {
  Metric copyWith(
      {int? id,
      int? person,
      int? user,
      DateTime? date,
      String? value,
      String? tag,
      int? type}) {
    return Metric(
        id: id ?? this.id,
        person: person ?? this.person,
        user: user ?? this.user,
        date: date ?? this.date,
        value: value ?? this.value,
        tag: tag ?? this.tag,
        type: type ?? this.type);
  }

  Metric copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<int?>? person,
      Wrapped<int?>? user,
      Wrapped<DateTime?>? date,
      Wrapped<String?>? value,
      Wrapped<String?>? tag,
      Wrapped<int?>? type}) {
    return Metric(
        id: (id != null ? id.value : this.id),
        person: (person != null ? person.value : this.person),
        user: (user != null ? user.value : this.user),
        date: (date != null ? date.value : this.date),
        value: (value != null ? value.value : this.value),
        tag: (tag != null ? tag.value : this.tag),
        type: (type != null ? type.value : this.type));
  }
}

@JsonSerializable(explicitToJson: true)
class MetricType {
  const MetricType({
    this.id,
    this.name,
    this.description,
    this.unit,
  });

  factory MetricType.fromJson(Map<String, dynamic> json) =>
      _$MetricTypeFromJson(json);

  static const toJsonFactory = _$MetricTypeToJson;
  Map<String, dynamic> toJson() => _$MetricTypeToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'unit')
  final String? unit;
  static const fromJsonFactory = _$MetricTypeFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is MetricType &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.unit, unit) ||
                const DeepCollectionEquality().equals(other.unit, unit)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(unit) ^
      runtimeType.hashCode;
}

extension $MetricTypeExtension on MetricType {
  MetricType copyWith(
      {int? id, String? name, String? description, String? unit}) {
    return MetricType(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        unit: unit ?? this.unit);
  }

  MetricType copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<String?>? name,
      Wrapped<String?>? description,
      Wrapped<String?>? unit}) {
    return MetricType(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        unit: (unit != null ? unit.value : this.unit));
  }
}

@JsonSerializable(explicitToJson: true)
class Oauth {
  const Oauth({
    this.enabled,
    this.autoRegister,
    this.clientId,
    this.clientSecret,
  });

  factory Oauth.fromJson(Map<String, dynamic> json) => _$OauthFromJson(json);

  static const toJsonFactory = _$OauthToJson;
  Map<String, dynamic> toJson() => _$OauthToJson(this);

  @JsonKey(name: 'enabled')
  final bool? enabled;
  @JsonKey(name: 'autoRegister')
  final bool? autoRegister;
  @JsonKey(name: 'clientId')
  final String? clientId;
  @JsonKey(name: 'clientSecret')
  final String? clientSecret;
  static const fromJsonFactory = _$OauthFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Oauth &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality()
                    .equals(other.enabled, enabled)) &&
            (identical(other.autoRegister, autoRegister) ||
                const DeepCollectionEquality()
                    .equals(other.autoRegister, autoRegister)) &&
            (identical(other.clientId, clientId) ||
                const DeepCollectionEquality()
                    .equals(other.clientId, clientId)) &&
            (identical(other.clientSecret, clientSecret) ||
                const DeepCollectionEquality()
                    .equals(other.clientSecret, clientSecret)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(autoRegister) ^
      const DeepCollectionEquality().hash(clientId) ^
      const DeepCollectionEquality().hash(clientSecret) ^
      runtimeType.hashCode;
}

extension $OauthExtension on Oauth {
  Oauth copyWith(
      {bool? enabled,
      bool? autoRegister,
      String? clientId,
      String? clientSecret}) {
    return Oauth(
        enabled: enabled ?? this.enabled,
        autoRegister: autoRegister ?? this.autoRegister,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret);
  }

  Oauth copyWithWrapped(
      {Wrapped<bool?>? enabled,
      Wrapped<bool?>? autoRegister,
      Wrapped<String?>? clientId,
      Wrapped<String?>? clientSecret}) {
    return Oauth(
        enabled: (enabled != null ? enabled.value : this.enabled),
        autoRegister:
            (autoRegister != null ? autoRegister.value : this.autoRegister),
        clientId: (clientId != null ? clientId.value : this.clientId),
        clientSecret:
            (clientSecret != null ? clientSecret.value : this.clientSecret));
  }
}

@JsonSerializable(explicitToJson: true)
class Person {
  const Person({
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
    this.id,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  static const toJsonFactory = _$PersonToJson;
  Map<String, dynamic> toJson() => _$PersonToJson(this);

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
  @JsonKey(
    name: 'type',
    toJson: userTypeNullableToJson,
    fromJson: userTypeNullableFromJson,
  )
  final enums.UserType? type;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'rights', defaultValue: <Right>[])
  final List<Right>? rights;
  @JsonKey(name: 'id')
  final int? id;
  static const fromJsonFactory = _$PersonFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Person &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.surname, surname) ||
                const DeepCollectionEquality()
                    .equals(other.surname, surname)) &&
            (identical(other.identifier, identifier) ||
                const DeepCollectionEquality()
                    .equals(other.identifier, identifier)) &&
            (identical(other.birth, birth) ||
                const DeepCollectionEquality().equals(other.birth, birth)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality()
                    .equals(other.userName, userName)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.rights, rights) ||
                const DeepCollectionEquality().equals(other.rights, rights)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
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
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $PersonExtension on Person {
  Person copyWith(
      {String? name,
      String? surname,
      String? identifier,
      DateTime? birth,
      String? userName,
      String? password,
      enums.UserType? type,
      String? email,
      String? phone,
      List<Right>? rights,
      int? id}) {
    return Person(
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
        id: id ?? this.id);
  }

  Person copyWithWrapped(
      {Wrapped<String?>? name,
      Wrapped<String?>? surname,
      Wrapped<String?>? identifier,
      Wrapped<DateTime?>? birth,
      Wrapped<String?>? userName,
      Wrapped<String?>? password,
      Wrapped<enums.UserType?>? type,
      Wrapped<String?>? email,
      Wrapped<String?>? phone,
      Wrapped<List<Right>?>? rights,
      Wrapped<int?>? id}) {
    return Person(
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
        id: (id != null ? id.value : this.id));
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
  @JsonKey(
    name: 'type',
    toJson: userTypeNullableToJson,
    fromJson: userTypeNullableFromJson,
  )
  final enums.UserType? type;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'rights', defaultValue: <Right>[])
  final List<Right>? rights;
  static const fromJsonFactory = _$PersonCreationFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PersonCreation &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.surname, surname) ||
                const DeepCollectionEquality()
                    .equals(other.surname, surname)) &&
            (identical(other.identifier, identifier) ||
                const DeepCollectionEquality()
                    .equals(other.identifier, identifier)) &&
            (identical(other.birth, birth) ||
                const DeepCollectionEquality().equals(other.birth, birth)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality()
                    .equals(other.userName, userName)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
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
  PersonCreation copyWith(
      {String? name,
      String? surname,
      String? identifier,
      DateTime? birth,
      String? userName,
      String? password,
      enums.UserType? type,
      String? email,
      String? phone,
      List<Right>? rights}) {
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
        rights: rights ?? this.rights);
  }

  PersonCreation copyWithWrapped(
      {Wrapped<String?>? name,
      Wrapped<String?>? surname,
      Wrapped<String?>? identifier,
      Wrapped<DateTime?>? birth,
      Wrapped<String?>? userName,
      Wrapped<String?>? password,
      Wrapped<enums.UserType?>? type,
      Wrapped<String?>? email,
      Wrapped<String?>? phone,
      Wrapped<List<Right>?>? rights}) {
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
        rights: (rights != null ? rights.value : this.rights));
  }
}

@JsonSerializable(explicitToJson: true)
class Proxy {
  const Proxy({
    this.proxyAuth,
    this.autoRegister,
    this.header,
  });

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Proxy &&
            (identical(other.proxyAuth, proxyAuth) ||
                const DeepCollectionEquality()
                    .equals(other.proxyAuth, proxyAuth)) &&
            (identical(other.autoRegister, autoRegister) ||
                const DeepCollectionEquality()
                    .equals(other.autoRegister, autoRegister)) &&
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
        header: header ?? this.header);
  }

  Proxy copyWithWrapped(
      {Wrapped<bool?>? proxyAuth,
      Wrapped<bool?>? autoRegister,
      Wrapped<String?>? header}) {
    return Proxy(
        proxyAuth: (proxyAuth != null ? proxyAuth.value : this.proxyAuth),
        autoRegister:
            (autoRegister != null ? autoRegister.value : this.autoRegister),
        header: (header != null ? header.value : this.header));
  }
}

@JsonSerializable(explicitToJson: true)
class Right {
  const Right({
    this.personId,
    this.userId,
    this.start,
    this.stop,
    this.type,
  });

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Right &&
            (identical(other.personId, personId) ||
                const DeepCollectionEquality()
                    .equals(other.personId, personId)) &&
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
  Right copyWith(
      {int? personId,
      int? userId,
      DateTime? start,
      DateTime? stop,
      enums.RightType? type}) {
    return Right(
        personId: personId ?? this.personId,
        userId: userId ?? this.userId,
        start: start ?? this.start,
        stop: stop ?? this.stop,
        type: type ?? this.type);
  }

  Right copyWithWrapped(
      {Wrapped<int?>? personId,
      Wrapped<int?>? userId,
      Wrapped<DateTime?>? start,
      Wrapped<DateTime?>? stop,
      Wrapped<enums.RightType?>? type}) {
    return Right(
        personId: (personId != null ? personId.value : this.personId),
        userId: (userId != null ? userId.value : this.userId),
        start: (start != null ? start.value : this.start),
        stop: (stop != null ? stop.value : this.stop),
        type: (type != null ? type.value : this.type));
  }
}

@JsonSerializable(explicitToJson: true)
class Settings {
  const Settings({
    this.oauth,
    this.proxy,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  static const toJsonFactory = _$SettingsToJson;
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  @JsonKey(name: 'oauth')
  final Oauth? oauth;
  @JsonKey(name: 'proxy')
  final Proxy? proxy;
  static const fromJsonFactory = _$SettingsFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Settings &&
            (identical(other.oauth, oauth) ||
                const DeepCollectionEquality().equals(other.oauth, oauth)) &&
            (identical(other.proxy, proxy) ||
                const DeepCollectionEquality().equals(other.proxy, proxy)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(oauth) ^
      const DeepCollectionEquality().hash(proxy) ^
      runtimeType.hashCode;
}

extension $SettingsExtension on Settings {
  Settings copyWith({Oauth? oauth, Proxy? proxy}) {
    return Settings(oauth: oauth ?? this.oauth, proxy: proxy ?? this.proxy);
  }

  Settings copyWithWrapped({Wrapped<Oauth?>? oauth, Wrapped<Proxy?>? proxy}) {
    return Settings(
        oauth: (oauth != null ? oauth.value : this.oauth),
        proxy: (proxy != null ? proxy.value : this.proxy));
  }
}

@JsonSerializable(explicitToJson: true)
class Status {
  const Status({
    this.init,
    this.externalAuth,
    this.error,
  });

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  static const toJsonFactory = _$StatusToJson;
  Map<String, dynamic> toJson() => _$StatusToJson(this);

  @JsonKey(name: 'init')
  final bool? init;
  @JsonKey(name: 'externalAuth')
  final bool? externalAuth;
  @JsonKey(name: 'error')
  final String? error;
  static const fromJsonFactory = _$StatusFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Status &&
            (identical(other.init, init) ||
                const DeepCollectionEquality().equals(other.init, init)) &&
            (identical(other.externalAuth, externalAuth) ||
                const DeepCollectionEquality()
                    .equals(other.externalAuth, externalAuth)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(init) ^
      const DeepCollectionEquality().hash(externalAuth) ^
      const DeepCollectionEquality().hash(error) ^
      runtimeType.hashCode;
}

extension $StatusExtension on Status {
  Status copyWith({bool? init, bool? externalAuth, String? error}) {
    return Status(
        init: init ?? this.init,
        externalAuth: externalAuth ?? this.externalAuth,
        error: error ?? this.error);
  }

  Status copyWithWrapped(
      {Wrapped<bool?>? init,
      Wrapped<bool?>? externalAuth,
      Wrapped<String?>? error}) {
    return Status(
        init: (init != null ? init.value : this.init),
        externalAuth:
            (externalAuth != null ? externalAuth.value : this.externalAuth),
        error: (error != null ? error.value : this.error));
  }
}

@JsonSerializable(explicitToJson: true)
class Treatement {
  const Treatement({
    this.events,
    this.type,
  });

  factory Treatement.fromJson(Map<String, dynamic> json) =>
      _$TreatementFromJson(json);

  static const toJsonFactory = _$TreatementToJson;
  Map<String, dynamic> toJson() => _$TreatementToJson(this);

  @JsonKey(name: 'events', defaultValue: <Event>[])
  final List<Event>? events;
  @JsonKey(
    name: 'type',
    toJson: treatmentTypeNullableToJson,
    fromJson: treatmentTypeNullableFromJson,
  )
  final enums.TreatmentType? type;
  static const fromJsonFactory = _$TreatementFromJson;

  @override
  bool operator ==(dynamic other) {
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
  Treatement copyWith({List<Event>? events, enums.TreatmentType? type}) {
    return Treatement(events: events ?? this.events, type: type ?? this.type);
  }

  Treatement copyWithWrapped(
      {Wrapped<List<Event>?>? events, Wrapped<enums.TreatmentType?>? type}) {
    return Treatement(
        events: (events != null ? events.value : this.events),
        type: (type != null ? type.value : this.type));
  }
}

int? rightTypeNullableToJson(enums.RightType? rightType) {
  return rightType?.value;
}

int? rightTypeToJson(enums.RightType rightType) {
  return rightType.value;
}

enums.RightType rightTypeFromJson(
  Object? rightType, [
  enums.RightType? defaultValue,
]) {
  return enums.RightType.values.firstWhereOrNull((e) =>
          e.value.toString().toLowerCase() ==
          rightType?.toString().toLowerCase()) ??
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

List<int> rightTypeListToJson(List<enums.RightType>? rightType) {
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

int? treatmentTypeNullableToJson(enums.TreatmentType? treatmentType) {
  return treatmentType?.value;
}

int? treatmentTypeToJson(enums.TreatmentType treatmentType) {
  return treatmentType.value;
}

enums.TreatmentType treatmentTypeFromJson(
  Object? treatmentType, [
  enums.TreatmentType? defaultValue,
]) {
  return enums.TreatmentType.values.firstWhereOrNull((e) =>
          e.value.toString().toLowerCase() ==
          treatmentType?.toString().toLowerCase()) ??
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
  return enums.TreatmentType.values
          .firstWhereOrNull((e) => e.value == treatmentType) ??
      defaultValue;
}

String treatmentTypeExplodedListToJson(
    List<enums.TreatmentType>? treatmentType) {
  return treatmentType?.map((e) => e.value!).join(',') ?? '';
}

List<int> treatmentTypeListToJson(List<enums.TreatmentType>? treatmentType) {
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

int? userTypeNullableToJson(enums.UserType? userType) {
  return userType?.value;
}

int? userTypeToJson(enums.UserType userType) {
  return userType.value;
}

enums.UserType userTypeFromJson(
  Object? userType, [
  enums.UserType? defaultValue,
]) {
  return enums.UserType.values.firstWhereOrNull((e) =>
          e.value.toString().toLowerCase() ==
          userType?.toString().toLowerCase()) ??
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

List<int> userTypeListToJson(List<enums.UserType>? userType) {
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
      chopper.Response response) async {
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
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
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
