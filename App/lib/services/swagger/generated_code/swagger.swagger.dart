// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
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
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Swagger(newClient);
  }

  ///
  Future<chopper.Response<String>> authPost({required Connection? body}) {
    return _authPost(body: body);
  }

  ///
  @Post(
    path: '/auth',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _authPost(
      {@Body() required Connection? body});

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Event>>> eventsGet({
    required int? type,
    required String? start,
    required String? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _eventsGet(type: type, start: start, end: end, personId: personId);
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @Get(path: '/events')
  Future<chopper.Response<List<Event>>> _eventsGet({
    @Query('type') required int? type,
    @Query('start') required String? start,
    @Query('end') required String? end,
    @Query('personId') int? personId,
  });

  ///
  ///@param personId
  Future<chopper.Response> eventsPost({
    int? personId,
    required CreateEvent? body,
  }) {
    return _eventsPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @Post(
    path: '/events',
    optionalBody: true,
  )
  Future<chopper.Response> _eventsPost({
    @Query('personId') int? personId,
    @Body() required CreateEvent? body,
  });

  ///
  ///@param id
  Future<chopper.Response> eventsIdDelete({required int? id}) {
    return _eventsIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/events/{id}')
  Future<chopper.Response> _eventsIdDelete({@Path('id') required int? id});

  ///
  Future<chopper.Response> eventsTypePost({required EventType? body}) {
    return _eventsTypePost(body: body);
  }

  ///
  @Post(
    path: '/events/type',
    optionalBody: true,
  )
  Future<chopper.Response> _eventsTypePost({@Body() required EventType? body});

  ///
  Future<chopper.Response> eventsTypePut({required MetricType? body}) {
    return _eventsTypePut(body: body);
  }

  ///
  @Put(
    path: '/events/type',
    optionalBody: true,
  )
  Future<chopper.Response> _eventsTypePut({@Body() required MetricType? body});

  ///
  Future<chopper.Response<List<EventType>>> eventsTypeGet() {
    generatedMapping.putIfAbsent(EventType, () => EventType.fromJsonFactory);

    return _eventsTypeGet();
  }

  ///
  @Get(path: '/events/type')
  Future<chopper.Response<List<EventType>>> _eventsTypeGet();

  ///
  ///@param id
  Future<chopper.Response> eventsTypeIdDelete({required int? id}) {
    return _eventsTypeIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/events/type/{id}')
  Future<chopper.Response> _eventsTypeIdDelete({@Path('id') required int? id});

  ///
  Future<chopper.Response<List<FileType>>> importTypesGet() {
    generatedMapping.putIfAbsent(FileType, () => FileType.fromJsonFactory);

    return _importTypesGet();
  }

  ///
  @Get(path: '/import/types')
  Future<chopper.Response<List<FileType>>> _importTypesGet();

  ///
  ///@param type
  Future<chopper.Response> importTypePost({
    required int? type,
    required String? body,
  }) {
    return _importTypePost(type: type, body: body);
  }

  ///
  ///@param type
  @Post(
    path: '/import/{type}',
    optionalBody: true,
  )
  Future<chopper.Response> _importTypePost({
    @Path('type') required int? type,
    @Body() required String? body,
  });

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  Future<chopper.Response<List<Metric>>> metricsGet({
    required int? type,
    required String? start,
    required String? end,
    int? personId,
  }) {
    generatedMapping.putIfAbsent(Metric, () => Metric.fromJsonFactory);

    return _metricsGet(type: type, start: start, end: end, personId: personId);
  }

  ///
  ///@param type
  ///@param start
  ///@param end
  ///@param personId
  @Get(path: '/metrics')
  Future<chopper.Response<List<Metric>>> _metricsGet({
    @Query('type') required int? type,
    @Query('start') required String? start,
    @Query('end') required String? end,
    @Query('personId') int? personId,
  });

  ///
  ///@param personId
  Future<chopper.Response> metricsPost({
    int? personId,
    required CreateMetric? body,
  }) {
    return _metricsPost(personId: personId, body: body);
  }

  ///
  ///@param personId
  @Post(
    path: '/metrics',
    optionalBody: true,
  )
  Future<chopper.Response> _metricsPost({
    @Query('personId') int? personId,
    @Body() required CreateMetric? body,
  });

  ///
  ///@param id
  Future<chopper.Response> metricsIdDelete({required int? id}) {
    return _metricsIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/metrics/{id}')
  Future<chopper.Response> _metricsIdDelete({@Path('id') required int? id});

  ///
  Future<chopper.Response> metricsTypePost({required MetricType? body}) {
    return _metricsTypePost(body: body);
  }

  ///
  @Post(
    path: '/metrics/type',
    optionalBody: true,
  )
  Future<chopper.Response> _metricsTypePost(
      {@Body() required MetricType? body});

  ///
  Future<chopper.Response> metricsTypePut({required MetricType? body}) {
    return _metricsTypePut(body: body);
  }

  ///
  @Put(
    path: '/metrics/type',
    optionalBody: true,
  )
  Future<chopper.Response> _metricsTypePut({@Body() required MetricType? body});

  ///
  Future<chopper.Response<List<MetricType>>> metricsTypeGet() {
    generatedMapping.putIfAbsent(MetricType, () => MetricType.fromJsonFactory);

    return _metricsTypeGet();
  }

  ///
  @Get(path: '/metrics/type')
  Future<chopper.Response<List<MetricType>>> _metricsTypeGet();

  ///
  ///@param id
  Future<chopper.Response> metricsTypeIdDelete({required int? id}) {
    return _metricsTypeIdDelete(id: id);
  }

  ///
  ///@param id
  @Delete(path: '/metrics/type/{id}')
  Future<chopper.Response> _metricsTypeIdDelete({@Path('id') required int? id});

  ///
  Future<chopper.Response> personPost({required Person? body}) {
    return _personPost(body: body);
  }

  ///
  @Post(
    path: '/person',
    optionalBody: true,
  )
  Future<chopper.Response> _personPost({@Body() required Person? body});
}

@JsonSerializable(explicitToJson: true)
class Connection {
  Connection({
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
  CreateEvent({
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
  CreateMetric({
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
class Event {
  Event({
    this.id,
    this.person,
    this.user,
    this.file,
    this.treatment,
    this.type,
    this.description,
    this.start,
    this.stop,
    this.valid,
    this.address,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  static const toJsonFactory = _$EventToJson;
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'person')
  final int? person;
  @JsonKey(name: 'user')
  final int? user;
  @JsonKey(name: 'file')
  final int? file;
  @JsonKey(name: 'treatment')
  final int? treatment;
  @JsonKey(name: 'type')
  final int? type;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'stop')
  final DateTime? stop;
  @JsonKey(name: 'valid')
  final bool? valid;
  @JsonKey(name: 'address')
  final int? address;
  static const fromJsonFactory = _$EventFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Event &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.person, person) ||
                const DeepCollectionEquality().equals(other.person, person)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)) &&
            (identical(other.treatment, treatment) ||
                const DeepCollectionEquality()
                    .equals(other.treatment, treatment)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)) &&
            (identical(other.valid, valid) ||
                const DeepCollectionEquality().equals(other.valid, valid)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality().equals(other.address, address)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(person) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(file) ^
      const DeepCollectionEquality().hash(treatment) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(start) ^
      const DeepCollectionEquality().hash(stop) ^
      const DeepCollectionEquality().hash(valid) ^
      const DeepCollectionEquality().hash(address) ^
      runtimeType.hashCode;
}

extension $EventExtension on Event {
  Event copyWith(
      {int? id,
      int? person,
      int? user,
      int? file,
      int? treatment,
      int? type,
      String? description,
      DateTime? start,
      DateTime? stop,
      bool? valid,
      int? address}) {
    return Event(
        id: id ?? this.id,
        person: person ?? this.person,
        user: user ?? this.user,
        file: file ?? this.file,
        treatment: treatment ?? this.treatment,
        type: type ?? this.type,
        description: description ?? this.description,
        start: start ?? this.start,
        stop: stop ?? this.stop,
        valid: valid ?? this.valid,
        address: address ?? this.address);
  }

  Event copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<int?>? person,
      Wrapped<int?>? user,
      Wrapped<int?>? file,
      Wrapped<int?>? treatment,
      Wrapped<int?>? type,
      Wrapped<String?>? description,
      Wrapped<DateTime?>? start,
      Wrapped<DateTime?>? stop,
      Wrapped<bool?>? valid,
      Wrapped<int?>? address}) {
    return Event(
        id: (id != null ? id.value : this.id),
        person: (person != null ? person.value : this.person),
        user: (user != null ? user.value : this.user),
        file: (file != null ? file.value : this.file),
        treatment: (treatment != null ? treatment.value : this.treatment),
        type: (type != null ? type.value : this.type),
        description:
            (description != null ? description.value : this.description),
        start: (start != null ? start.value : this.start),
        stop: (stop != null ? stop.value : this.stop),
        valid: (valid != null ? valid.value : this.valid),
        address: (address != null ? address.value : this.address));
  }
}

@JsonSerializable(explicitToJson: true)
class EventType {
  EventType({
    this.id,
    this.name,
    this.description,
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
                    .equals(other.description, description)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $EventTypeExtension on EventType {
  EventType copyWith({int? id, String? name, String? description}) {
    return EventType(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description);
  }

  EventType copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<String?>? name,
      Wrapped<String?>? description}) {
    return EventType(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description));
  }
}

@JsonSerializable(explicitToJson: true)
class FileType {
  FileType({
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
  Metric({
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
  MetricType({
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
class Person {
  Person({
    this.name,
    this.surname,
    this.identifier,
    this.birth,
    this.userName,
    this.password,
    this.type,
    this.email,
    this.phone,
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
    toJson: userTypeToJson,
    fromJson: userTypeFromJson,
  )
  final enums.UserType? type;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
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
                const DeepCollectionEquality().equals(other.phone, phone)));
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
      String? phone}) {
    return Person(
        name: name ?? this.name,
        surname: surname ?? this.surname,
        identifier: identifier ?? this.identifier,
        birth: birth ?? this.birth,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        type: type ?? this.type,
        email: email ?? this.email,
        phone: phone ?? this.phone);
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
      Wrapped<String?>? phone}) {
    return Person(
        name: (name != null ? name.value : this.name),
        surname: (surname != null ? surname.value : this.surname),
        identifier: (identifier != null ? identifier.value : this.identifier),
        birth: (birth != null ? birth.value : this.birth),
        userName: (userName != null ? userName.value : this.userName),
        password: (password != null ? password.value : this.password),
        type: (type != null ? type.value : this.type),
        email: (email != null ? email.value : this.email),
        phone: (phone != null ? phone.value : this.phone));
  }
}

int? userTypeToJson(enums.UserType? userType) {
  return userType?.value;
}

enums.UserType userTypeFromJson(
  Object? userType, [
  enums.UserType? defaultValue,
]) {
  return enums.UserType.values.firstWhereOrNull((e) => e.value == userType) ??
      defaultValue ??
      enums.UserType.swaggerGeneratedUnknown;
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
