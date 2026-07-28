import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class EventService {
  Future<List<EventType>?> eventsType(bool all);

  Future<void> addEventsType(CreateEventType event);

  Future<void> updateEventsType(UpdateEventType event);

  Future<void> deleteEventsType(int event);

  Future<List<Event>?> events(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  });

  Future<EventStats?> eventsSummary(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  });

  Future<List<Event>?> agenda(DateTime? start, DateTime? end);

  Future<int?> addEvent(CreateEvent event, {int? person});

  Future<void> updateEvent(UpdateEvent event);

  Future<void> deleteEvent(int event);

  Future<List<Event>?> searchEvents(
    int? person,
    SearchEvent search,
    int page,
    int pageSize,
  );

  Future<int?> countEvents(int? person, SearchEvent search);

  Future<void> deleteEvents(List<Event> events, {int? person});

  Future<void> updateEvents(PatchEvent patch, {int? person});
}
