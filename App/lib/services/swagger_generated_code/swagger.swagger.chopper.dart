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
  Future<Response<String>> _authPost({required Connection? body}) {
    final Uri $url = Uri.parse('/auth');
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
  Future<Response<List<FileType>>> _importTypesGet() {
    final Uri $url = Uri.parse('/import/types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<FileType>, FileType>($request);
  }

  @override
  Future<Response<dynamic>> _importTypesTypePost({
    required int? type,
    required String? body,
  }) {
    final Uri $url = Uri.parse('/import/types/${type}');
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
  Future<Response<List<Metric>>> _metricsGet({
    required int? type,
    required String? start,
    required String? end,
    int? personId,
  }) {
    final Uri $url = Uri.parse('/metrics');
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
  Future<Response<dynamic>> _metricsPost({
    int? personId,
    required CreateMetric? body,
  }) {
    final Uri $url = Uri.parse('/metrics');
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
  Future<Response<dynamic>> _metricsIdDelete({required int? id}) {
    final Uri $url = Uri.parse('/metrics/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _metricsTypePost({required MetricType? body}) {
    final Uri $url = Uri.parse('/metrics/type');
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
  Future<Response<dynamic>> _metricsTypePut({required MetricType? body}) {
    final Uri $url = Uri.parse('/metrics/type');
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
  Future<Response<dynamic>> _metricsTypeDelete({required int? id}) {
    final Uri $url = Uri.parse('/metrics/type');
    final Map<String, dynamic> $params = <String, dynamic>{'id': id};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<MetricType>>> _metricsTypeGet() {
    final Uri $url = Uri.parse('/metrics/type');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<MetricType>, MetricType>($request);
  }

  @override
  Future<Response<dynamic>> _personPost({required Person? body}) {
    final Uri $url = Uri.parse('/person');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
