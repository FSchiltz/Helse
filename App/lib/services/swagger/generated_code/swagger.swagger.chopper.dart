// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$Swagger extends Swagger {
  _$Swagger([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = Swagger;

  @override
  Future<Response<String>> _apiAuthPost({required Connection? body}) {
    final Uri $url = Uri.parse('/api/auth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Status>> _apiStatusGet() {
    final Uri $url = Uri.parse('/api/status');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Status, Status>($request);
  }

  @override
  Future<Response<List<Event>>> _apiEventsGet({
    int? type,
    required String? start,
    required String? end,
    int? personId,
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
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsPost({
    int? personId,
    required CreateEvent? body,
  }) {
    final Uri $url = Uri.parse('/api/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'personId': personId
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsIdDelete({required int? id}) {
    final Uri $url = Uri.parse('/api/events/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsTypePost({required EventType? body}) {
    final Uri $url = Uri.parse('/api/events/type');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsTypePut({required MetricType? body}) {
    final Uri $url = Uri.parse('/api/events/type');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<EventType>>> _apiEventsTypeGet() {
    final Uri $url = Uri.parse('/api/events/type');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<EventType>, EventType>($request);
  }

  @override
  Future<Response<dynamic>> _apiEventsTypeIdDelete({required int? id}) {
    final Uri $url = Uri.parse('/api/events/type/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<FileType>>> _apiImportTypesGet() {
    final Uri $url = Uri.parse('/api/import/types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<FileType>, FileType>($request);
  }

  @override
  Future<Response<dynamic>> _apiImportTypePost({
    required int? type,
    required String? body,
  }) {
    final Uri $url = Uri.parse('/api/import/${type}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Metric>>> _apiMetricsGet({
    required int? type,
    required String? start,
    required String? end,
    int? personId,
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
    );
    return client.send<List<Metric>, Metric>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsPost({
    int? personId,
    required CreateMetric? body,
  }) {
    final Uri $url = Uri.parse('/api/metrics');
    final Map<String, dynamic> $params = <String, dynamic>{
      'personId': personId
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsIdDelete({required int? id}) {
    final Uri $url = Uri.parse('/api/metrics/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypePost({required MetricType? body}) {
    final Uri $url = Uri.parse('/api/metrics/type');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypePut({required MetricType? body}) {
    final Uri $url = Uri.parse('/api/metrics/type');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<MetricType>>> _apiMetricsTypeGet() {
    final Uri $url = Uri.parse('/api/metrics/type');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<MetricType>, MetricType>($request);
  }

  @override
  Future<Response<dynamic>> _apiMetricsTypeIdDelete({required int? id}) {
    final Uri $url = Uri.parse('/api/metrics/type/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiPersonPost({required Person? body}) {
    final Uri $url = Uri.parse('/api/person');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Person>>> _apiPersonGet() {
    final Uri $url = Uri.parse('/api/person');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Person>, Person>($request);
  }
}
