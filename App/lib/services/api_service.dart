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

  Future<Swagger> _getService({String? override}) async {
    var url = override ?? await _account.getUrl();
    if (url == null) throw Exception("Url missing");

    var token = await _account.getToken();
    return Swagger.create(baseUrl: Uri.parse(url), interceptors: [
      HeadersInterceptor({'Authorization': 'Bearer $token'})
    ]);
  }

  Future<String?> login(String username, String password) async {
    var api = await _getService();
    var response = await api.apiAuthPost(body: Connection(user: username, password: password));

    return response.isSuccessful ? response.bodyString : null;
  }

  Future<void> createAccount(PersonCreation person) async {
    var api = await _getService();

    await _call(() => api.apiPersonPost(body: person));
  }

  Future<Status?> isInit(String url) async {
    try {
      var api = await _getService(override: url);
      var response = await api.apiStatusGet();

      if (!response.isSuccessful) return null;

      return response.body;
    } catch (_) {
      // don't crash on this call, the user may have entered a wrong url
      return null;
    }
  }

  Future<List<Person>?> getUsers() async {
    var api = await _getService();
    return await _call(api.apiPersonGet);
  }

  Future<List<MetricType>?> metricsType() async {
    var api = await _getService();
    return await _call(api.apiMetricsTypeGet);
  }

  Future<List<Metric>?> metrics(int? type, DateTime? start, DateTime? end, {int? person}) async {
    var api = await _getService();
    return await _call(() => api.apiMetricsGet(type: type, start: start, end: end, personId: person));
  }

  Future<void> addMetrics(CreateMetric metric, {int? person}) async {
    var api = await _getService();
    await _call(() => api.apiMetricsPost(body: metric, personId: person));
  }

  Future<List<EventType>?> eventsType(bool all) async {
    var api = await _getService();
    return await _call(() => api.apiEventsTypeGet(all: all));
  }

  Future<List<Event>?> events(int? type, DateTime? start, DateTime? end, {int? person}) async {
    var api = await _getService();
    return await _call(() => api.apiEventsGet(type: type, start: start, end: end, personId: person));
  }

  Future<List<Event>?> agenda(DateTime? start, DateTime? end) async {
    var api = await _getService();
    return await _call(() => api.apiPatientsAgendaGet(start: start, end: end));
  }

  Future<void> addEvents(CreateEvent event, {int? person}) async {
    var api = await _getService();
    await _call(() => api.apiEventsPost(body: event, personId: person));
  }

  Future<List<FileType>?> fileType() async {
    var api = await _getService();
    return await _call(api.apiImportTypesGet);
  }

  Future<void> import(String? file, int type) async {
    var api = await _getService();
    await _call(() => api.apiImportTypePost(body: file, type: type));
  }

  Future<List<Person>?> getPatients() async {
    var api = await _getService();
    return await _call(api.apiPatientsGet);
  }

  Future<List<Treatement>?> getTreatments(DateTime? start, DateTime? end, {int? person}) async {
    var api = await _getService();
    return await _call(() => api.apiTreatmentGet(start: start, end: end, personId: person));
  }

  Future<void> addTreatment(CreateTreatment treatment) async {
    var api = await _getService();
    await _call(() => api.apiTreatmentPost(body: treatment));
  }

  Future<List<EventType>?> treatmentType() async {
    var api = await _getService();
    return await _call(api.apiTreatmentTypeGet);
  }

  Future<Settings> getSettings() async {
    var api = await _getService();
    return await _call(api.apiAdminSettingsGet) ?? const Settings();
  }

  Future<void> saveSettings(Settings settings) async {
    var api = await _getService();
    await _call(() => api.apiAdminSettingsPost(body: settings));
  }
}
