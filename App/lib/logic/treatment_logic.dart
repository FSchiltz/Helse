import '../services/account.dart';
import '../services/api_service.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';

class TreatementLogic {
  final Account _account;

  TreatementLogic(Account account) : _account = account;

  Future<List<Treatement>> get(DateTime? start, DateTime? end, {int? person}) async {
    return (await ApiService(_account).getTreatments(start?.toUtc(), end?.toUtc(), person: person)) ?? List<Treatement>.empty();
  }

  Future add(CreateTreatment treatment) async {
    await ApiService(_account).addTreatment(treatment);
  }

  Future<List<EventType>?> getTypes() async {
    return await ApiService(_account).treatmentType();
  }
}
