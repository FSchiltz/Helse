import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class UserService {
  Future<List<Person>?> persons();

  Future<UserId?> addPerson(
    PersonCreation person,
  );

  Future<List<Person>?> patients();

  Future<void> updatePerson(
    UpdatePerson update,
  );

  Future<void> deletePerson(
    int id,
  );

  Future<List<Person>> caregiver();

  Future<void> updatePatient(
    UpdatePatient update,
  );

  Future<void> sharePatient({
    required int patient,
    required int caregiver,
    required bool edit,
  });

  Future<List<Session>> getSessions();

  Future<void> logout(
    bool all,
  );
}
