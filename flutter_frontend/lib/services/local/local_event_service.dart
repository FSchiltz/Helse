import 'package:drift/drift.dart';
import 'package:helse/services/event_service.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalEventService extends LocalService implements EventService {
  LocalEventService(super.account);

  @override
  Future<int?> addEvent(CreateEvent event, {int? person}) async {
    final newRow = await account.database
        .into(account.database.event)
        .insertReturning(
          EventCompanion.insert(
            description: event.description ?? '',
            end: event.stop,
            start: event.start,
            type: event.type,
            person: Value(person),
            created: DateTime.now().toUtc(),
          ),
        );

    return newRow.id;
  }

  @override
  Future<void> addEventsType(CreateEventType event) async {
    await account.database
        .into(account.database.eventType)
        .insert(
          EventTypeCompanion.insert(
            groupId: event.groupId,
            name: event.name,
            standAlone: event.standAlone ?? false,
            visible: event.visible ?? false,
            description: Value(event.description),
            timeDifference: Value(event.timeDifference),
            created: DateTime.now().toUtc(),
          ),
        );
  }

  @override
  Future<List<Event>?> agenda(DateTime? start, DateTime? end) {
    // TODO: implement agenda
    throw UnimplementedError();
  }

  @override
  Future<int?> countEvents(int? person, SearchEvent search) {
    // TODO: implement countEvents
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEvent(int event) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEvents(List<Event> events, {int? person}) {
    // TODO: implement deleteEvents
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEventsType(int event) {
    // TODO: implement deleteEventsType
    throw UnimplementedError();
  }

  @override
  Future<List<Event>?> events(
    int? type,
    DateTime? start,
    DateTime? end, {
    int? person,
  }) {
    // TODO: implement events
    throw UnimplementedError();
  }

  @override
  Future<EventStats?> eventsSummary(
    int? type,
    DateTime? start,
    DateTime? end, {
    int? person,
  }) {
    // TODO: implement eventsSummary
    throw UnimplementedError();
  }

  @override
  Future<List<EventType>?> eventsType(bool all) {
    // TODO: implement eventsType
    throw UnimplementedError();
  }

  @override
  Future<List<Event>?> searchEvents(
    int? person,
    SearchEvent search,
    int page,
    int pageSize,
  ) {
    // TODO: implement searchEvents
    throw UnimplementedError();
  }

  @override
  Future<void> updateEvent(UpdateEvent event) {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }

  @override
  Future<void> updateEvents(PatchEvent patch, {int? person}) {
    // TODO: implement updateEvents
    throw UnimplementedError();
  }

  @override
  Future<void> updateEventsType(UpdateEventType event) {
    // TODO: implement updateEventsType
    throw UnimplementedError();
  }
}
