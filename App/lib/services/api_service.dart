import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'account.dart';

class ApiService {
  final Account _account;

  ApiService(Account account) : _account = account;

  Future<T?> _call<T>(Future<Response<T>> Function() call) async {
    var response = await call();
    T? result;

    if (!response.isSuccessful) {
      switch (response.statusCode) {
        case 401:
          // no auth, we remove the token and return null;
          _account.removeToken();
          result = null;
          break;
        default:
          throw Exception(response.error);
      }
    } else {
      result = response.body;
    }
    return result;
  }

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
    return await _call(api.metricsTypeGet);
  }

  Future<List<Metric>?> metrics(int? type, String? start, String? end) async {
    var api = await _getService();
    return await _call(() => api.metricsGet(type: type, start: start, end: end));
  }

  Future<void> addMetrics(CreateMetric metric) async {
    var api = await _getService();
    await _call(() => api.metricsPost(body: metric));
  }

Future<List<EventType>?> eventsType() async {
    var api = await _getService();
    return await _call(api.eventsTypeGet);
  }

  Future<List<Event>?> events(int? type, String? start, String? end) async {
    var api = await _getService();
    return await _call(() => api.eventsGet(type: type, start: start, end: end));
  }

  Future<void> addEvents(CreateEvent event) async {
    var api = await _getService();
    await _call(() => api.eventsPost(body: event));
  }

  Future<List<FileType>?> fileType() async {
    var api = await _getService();
    return await _call(api.importTypesGet);
  }

   Future<void> import(String? file, int type) async {
    var api = await _getService();
    await _call(() => api.importTypePost(body: file, type: type));
  }
}
