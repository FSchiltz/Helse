import 'package:helse/services/api/cached_api_service.dart';
import 'package:helse/services/event_service.dart';

import '../swagger/generated_code/helseapi.swagger.dart';

class ApiEventService extends CachedApiService implements EventService {  
  ApiEventService(super.account);

  @override
  Future<List<EventType>?> eventsType(bool all) async {
    final api = await getService();
    final result = await call(() => api.apiEventsTypeGet(all: all));
    if (result != null) {
      await cache.saveEventTypes(result);
    }
    return result;
  }

  @override
  Future<int?> addEventsType(CreateEventType event) async {
    final api = await getService();
    final id = await call(() => api.apiEventsTypePost(body: event));
    return createdId(id);
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
    final result = await call(
      () => api.apiEventsGet(
        type: type,
        start: start.toUtc(),
        end: end.toUtc(),
        personId: person,
      ),
    );
    if (result != null) {
      await cache.saveEvents(result);
    }
    return result;
  }

  @override
  Future<EventStats?> eventsSummary(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final api = await getService();
    final result = await call(
      () => api.apiEventsSummaryGet(
        type: type,
        start: start.toUtc(),
        end: end.toUtc(),
        personId: person,
      ),
    );
    final events = result?.events;
    if (events != null) {
      await cache.saveEvents(events);
    }
    return result;
  }

  @override
  Future<List<Event>?> agenda(DateTime? start, DateTime? end) async {
    final api = await getService();
    final result = await call(
      () => api.apiPatientsAgendaGet(start: start?.toUtc(), end: end?.toUtc()),
    );
    if (result != null) {
      await cache.saveEvents(result);
    }
    return result;
  }

  @override
  Future<int?> addEvent(CreateEvent event, {int? person}) async {
    final api = await getService();
    return await call(() => api.apiEventsPost(body: event, personId: person));
  }

  @override
  Future<void> updateEvent(UpdateEvent event) async {
    final api = await getService();
    final id = await cache.eventServerId(event.id);
    await call(
      () => api.apiEventsPut(
        body: UpdateEvent(
          id: id,
          type: event.type,
          description: event.description,
          start: event.start,
          stop: event.stop,
          tag: event.tag,
          notificationTime: event.notificationTime,
          source: event.source,
          sourceId: event.sourceId,
        ),
      ),
    );
  }

  @override
  Future<void> deleteEvent(int event) async {
    final api = await getService();
    final serverId = await cache.eventServerId(event);
    await call(() => api.apiEventsIdDelete(id: serverId));
    await cache.removeEvent(serverId);
  }

  @override
  Future<List<Event>?> searchEvents(
    int? person,
    SearchEvent search,
    int page,
    int pageSize,
  ) async {
    final api = await getService();
    final result = await call(
      () => api.apiEventsSearchPost(
        body: search,
        personId: person,
        page: page,
        pageSize: pageSize,
      ),
    );
    if (result != null) {
      await cache.saveEvents(result);
    }
    return result;
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
    final ids = await Future.wait(
      events.map((event) => cache.eventServerId(event.id)),
    );
    await call(() => api.apiEventsDeletePost(body: ids, person: person));
    for (final id in ids) {
      await cache.removeEvent(id);
    }
  }

  @override
  Future<void> updateEvents(PatchEvent patch, {int? person}) async {
    final api = await getService();
    await call(() => api.apiEventsUpdatePut(body: patch, personId: person));
  }
}
