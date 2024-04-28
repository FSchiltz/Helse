import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class EventService extends ApiService {
  EventService(super.account);

    Future<List<EventType>?> eventsType(bool all) async {
    var api = await getService();
    return await call(() => api.apiEventsTypeGet(all: all));
  }

  Future<List<Event>?> events(int? type, DateTime? start, DateTime? end, {int? person}) async {
    var api = await getService();
    return await call(() => api.apiEventsGet(type: type, start: start, end: end, personId: person));
  }

  Future<List<Event>?> agenda(DateTime? start, DateTime? end) async {
    var api = await getService();
    return await call(() => api.apiPatientsAgendaGet(start: start, end: end));
  }

  Future<void> addEvents(CreateEvent event, {int? person}) async {
    var api = await getService();
    await call(() => api.apiEventsPost(body: event, personId: person));
  }
}
