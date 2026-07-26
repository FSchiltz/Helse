import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/services/user_service.dart';

class LocalUserService extends LocalService implements UserService {
  LocalUserService(super.account);

  @override
  Future<UserId?> addPerson(PersonCreation person) {
    // TODO: implement addPerson
    throw UnimplementedError();
  }

  @override
  Future<List<Person>> caregiver() {
    // TODO: implement caregiver
    throw UnimplementedError();
  }

  @override
  Future<void> deletePerson(int id) {
    // TODO: implement deletePerson
    throw UnimplementedError();
  }

  @override
  Future<List<Session>> getSessions() async {
    return [];
  }

  @override
  Future<void> logout(bool all) async {}

  @override
  Future<List<Person>?> patients() {
    // TODO: implement patients
    throw UnimplementedError();
  }

  @override
  Future<List<Person>?> persons() {
    // TODO: implement persons
    throw UnimplementedError();
  }

  @override
  Future<void> sharePatient({
    required int patient,
    required int caregiver,
    required bool edit,
  }) async {}

  @override
  Future<void> updatePatient(UpdatePatient update) {
    // TODO: implement updatePatient
    throw UnimplementedError();
  }

  @override
  Future<void> updatePerson(UpdatePerson update) {
    // TODO: implement updatePerson
    throw UnimplementedError();
  }
}
