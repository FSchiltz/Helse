import 'dart:async';
import 'package:chopper/chopper.dart';
import 'account.dart';
import 'swagger_generated_code/swagger.swagger.dart';

class ApiService {
  final Account _account;

  ApiService(Account account) : _account = account;

  Future<Swagger> _getService() async {
    var url = await _account.getUrl();
    if (url == null) throw Exception("Url missing");

    var token = await _account.getToken();
    return Swagger.create(baseUrl: Uri.parse(url), interceptors: [
      HeadersInterceptor({'Authorization': 'Bearer $token'})
    ]);
  }

  Future<String?> login(String username, String password) async {
    var api = await _getService();
    var response = await api.authPost(body: Connection(user: username, password: password));

    return response.isSuccessful ? response.bodyString : null;
  }

  Future<List<MetricType>?> metricsType() async {
    var api = await _getService();
    var response = await api.metricsTypeGet();
    var list = response.isSuccessful ? response.body : null;
    return list;
  }

  Future<List<Metric>?> metrics(int type, String start, String end) async {
    var api = await _getService();
    var response = await api.metricsGet(type: type, start: start, end: end);
    var list = response.isSuccessful ? response.body : null;
    return list;
  }

  Future<void> addMetrics(CreateMetric metric) async {
    var api = await _getService();
    var response = await api.metricsPost(body: metric);
    if (!response.isSuccessful) {
      throw Exception("Error");
    }
  }
}
