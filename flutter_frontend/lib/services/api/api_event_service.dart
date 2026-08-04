import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/event_service.dart';

import '../swagger/generated_code/helseapi.swagger.dart';

class ApiEventService extends ApiService implements EventService{
  ApiEventService(super.account);

  @override
  Future<List<EventType>?> eventsType(bool all) async {
    final api = await getService();
    return await call(() => api.apiEventsTypeGet(all: all));
  }

  @override
  Future<void> addEventsType(CreateEventType event) async {
    final api = await getService();
    await call(() => api.apiEventsTypePost(body: event));
  }

  @override
  Future<void> updateEventsType(UpdateEventType event) async {
    final api = await getService();
    await call(() => api.apiEventsTypePut(body: event));
  }

  @override
  Future<void> deleteEventsType(int event) async {
    final api = await getService();
    await call(() => api.apiEventsTypeIdDelete(id: event));
  }

  @override
  Future<List<Event>?> events(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final api = await getService();
    return await call(
      () => api.apiEventsGet(
        type: type,
        start: start.toUtc(),
        end: end.toUtc(),
        personId: person,
      ),
    );
  }

  @override
  Future<EventStats?> eventsSummary(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final api = await getService();
    return await call(
      () => api.apiEventsSummaryGet(
        type: type,
        start: start.toUtc(),
        end: end.toUtc(),
        personId: person,
      ),
    );
  }

  @override
  Future<List<Event>?> agenda(DateTime? start, DateTime? end) async {
    final api = await getService();
    return await call(
      () => api.apiPatientsAgendaGet(start: start?.toUtc(), end: end?.toUtc()),
    );
  }

  @override
  Future<int?> addEvent(CreateEvent event, {int? person}) async {
    final api = await getService();
    return await call(() => api.apiEventsPost(body: event, personId: person));
  }

  @override
  Future<void> updateEvent(UpdateEvent event) async {
    final api = await getService();
    await call(() => api.apiEventsPut(body: event));
  }

  @override
  Future<void> deleteEvent(int event) async {
    final api = await getService();
    await call(() => api.apiEventsIdDelete(id: event));
  }

  @override
  Future<List<Event>?> searchEvents(
    int? person,
    SearchEvent search,
    int page,
    int pageSize,
  ) async {
    final api = await getService();
    return await call(
      () => api.apiEventsSearchPost(
        body: search,
        personId: person,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  @override
  Future<int?> countEvents(int? person, SearchEvent search) async {
    final api = await getService();
    return await call(
      () => api.apiEventsCountPost(body: search, personId: person),
    );
  }

  @override
  Future<void> deleteEvents(List<Event> events, {int? person}) async {
    final api = await getService();
    await call(
      () => api.apiEventsDeletePost(
        body: events.map((e) => e.id).toList(),
        person: person,
      ),
    );
  }

  @override
  Future<void> updateEvents(PatchEvent patch, {int? person}) async {
    final api = await getService();
    await call(() => api.apiEventsUpdatePut(body: patch, personId: person));
  }
}
