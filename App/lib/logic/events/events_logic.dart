import '../../services/account.dart';
import '../../services/api_service.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';

class EventsLogic {
  final Account _account;

  EventsLogic(Account account) : _account = account;

  Future<List<EventType>> getType() async {
    return (await ApiService(_account).eventsType()) ?? List<EventType>.empty();
  }

  Future<List<Event>> getEvent(int? type, DateTime? start, DateTime? end, {int? person}) async {
    return (await ApiService(_account).events(type, start?.toUtc().toString(), end?.toUtc().toString(), person: person)) ?? List<Event>.empty();
  }

   Future<List<Event>> agenda(DateTime? start, DateTime? end) async {
    return (await ApiService(_account).agenda( start?.toUtc().toString(), end?.toUtc().toString()) )?? List<Event>.empty();
  }

  Future<void> addEvent(CreateEvent event, {int? person}) {
    return ApiService(_account).addEvents(event, person: person);
  }
}
