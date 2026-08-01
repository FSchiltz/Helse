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
            person: Value(person ?? 0),
            created: DateTime.now().toUtc(),
            sourceId: event.sourceId,
            source: event.source!.name,
            tag: Value(event.tag),
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
            userEditable: false,
          ),
        );
  }

  @override
  Future<List<Event>?> agenda(DateTime? start, DateTime? end) async {
    return [];
  }

  @override
  Future<int?> countEvents(int? person, SearchEvent search) async {
    var countExp = account.database.event.id.count();

    final query = account.database.selectOnly(account.database.event)
      ..addColumns([countExp]);

    query.where(account.database.event.type.equals(search.type));
    query.where(account.database.event.person.equals(person ?? 0));

    if (search.from != null) {
      query.where(
        account.database.event.start.isBiggerOrEqualValue(search.from!),
      );
    }

    if (search.to != null) {
      query.where(account.database.event.end.isSmallerOrEqualValue(search.to!));
    }

    if (search.value != null) {
      query.where(account.database.event.description.like('${search.value}%'));
    }

    if (search.filterSource != null) {
      query.where(account.database.event.source.equals(search.source!.name));
    }

    return await query.map((row) => row.read(countExp)).getSingle();
  }

  @override
  Future<void> deleteEvent(int event) async {
    await (account.database.event.delete()
          ..where((tbl) => tbl.id.equals(event)))
        .go();
  }

  @override
  Future<void> deleteEvents(List<Event> events, {int? person}) async {
    // TODO: implement deleteEvents
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEventsType(int event) async {
    await (account.database.eventType.delete()
          ..where((tbl) => tbl.id.equals(event)))
        .go();
  }

  @override
  Future<List<Event>?> events(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final query = account.database.select(account.database.event)
      ..where((x) => x.type.equals(type))
      ..where((x) => x.start.isBiggerOrEqualValue(start))
      ..where((x) => x.end.isSmallerOrEqualValue(end));

    if (person == null) {
      query.where((x) => x.person.isNull());
    } else {
      query.where((x) => x.person.equals(person));
    }

    final result = await query.get();
    return result.map(_mapEvent).toList();
  }

  @override
  Future<EventStats?> eventsSummary(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final data = await events(type, start, end, person: person) ?? [];

    return EventStats(summaries: [], durations: [], events: data);
  }

  @override
  Future<List<EventType>?> eventsType(bool all) async {
    final result = await account.database
        .select(account.database.eventType)
        .get();
    return result
        .map(
          (e) => EventType(
            id: e.id,
            userEditable: e.userEditable,
            name: e.name,
            groupId: e.groupId,
            description: e.description,
            standAlone: e.standAlone,
            timeDifference: e.timeDifference,
            visible: e.visible,
          ),
        )
        .toList();
  }

  @override
  Future<List<Event>?> searchEvents(
    int? person,
    SearchEvent search,
    int page,
    int pageSize,
  ) async {
    final query = account.database.select(account.database.event);

    query.where((x) => x.type.equals(search.type));
    query.where((x) => x.person.equals(person ?? 0));

    if (search.from != null) {
      query.where((x) => x.start.isBiggerOrEqualValue(search.from!));
    }

    if (search.to != null) {
      query.where((x) => x.end.isSmallerOrEqualValue(search.to!));
    }

    if (search.value != null) {
      query.where((x) => x.description.like('${search.value}%'));
    }

    if (search.filterSource != null) {
      query.where((x) => x.source.equals(search.source!.name));
    }

    query.limit(pageSize, offset: pageSize * page);
    final result = await query.get();
    return result.map(_mapEvent).toList();
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

  Event _mapEvent(EventData e) {
    return Event(
      id: e.id,
      type: e.type,
      start: e.start,
      stop: e.end,
      description: e.description,
      person: e.person,
      tag: e.tag,
      source: ImportTypes.values.asNameMap()[e.source],
      sourceId: e.sourceId,
    );
  }
}
