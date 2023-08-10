import '../services/account.dart';
import '../services/api_service.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';

class PersonsLogic {
  final Account _account;

  PersonsLogic(Account account) : _account = account;

  Future<List<Person>> getPatients() async {
    return (await ApiService(_account).getPatients()) ?? List<Person>.empty();
  }
}
