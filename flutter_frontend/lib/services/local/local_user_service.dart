import 'package:drift/drift.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/services/user_service.dart';

class LocalUserService extends LocalService implements UserService {
  LocalUserService(super.account);

  @override
  Future<UserId?> addPerson(PersonCreation person) async {
    final newRow = await account.database
        .into(account.database.person)
        .insertReturning(
          PersonCompanion.insert(
            identifier: person.identifier ?? '',
            name: Value(person.name),
            birth: Value(person.birth),
            email: Value(person.email),
            phone: Value(person.phone),
            surname: Value(person.surname),
            types: Value(person.types?.join(';')),
            created: DateTime.now().toUtc(),
          ),
        );

    return UserId(person: newRow.id);
  }

  @override
  Future<List<Person>> caregiver() async => [];

  @override
  Future<void> deletePerson(int id) async {
    await (account.database.delete(
      account.database.person,
    )..where((x) => x.id.equals(id))).go();
  }

  @override
  Future<List<Session>> getSessions() async {
    return [];
  }

  @override
  Future<void> logout(bool all) async {}

  @override
  Future<List<Person>?> patients() async {
    final result = await (account.database.select(
      account.database.person,
    )..where((e) => e.types.contains(UserType.patient.name))).get();

    return result.map(toModel).toList();
  }

  @override
  Future<List<Person>?> persons() async {
    final result = await account.database.select(account.database.person).get();

    return result.map(toModel).toList();
  }

  @override
  Future<void> sharePatient({
    required int patient,
    required int caregiver,
    required bool edit,
  }) async {}

  @override
  Future<void> updatePatient(UpdatePatient update) async {
    await account.database
        .update(account.database.person)
        .replace(
          PersonCompanion(
            id: Value(update.id!),
            identifier: Value(update.identifier!),
            birth: Value(update.birth),
            name: Value(update.name),
            profilePicture: Value(update.profilePicture),
            surname: Value(update.surname),
          ),
        );
  }

  @override
  Future<void> updatePerson(UpdatePerson update) async {
    await account.database
        .update(account.database.person)
        .write(
          PersonCompanion(
            id: Value(update.id!),
            identifier: Value(update.identifier!),
            birth: Value(update.birth),
            email: Value(update.email),
            name: Value(update.name),
            phone: Value(update.phone),
            profilePicture: Value(update.profilePicture),
            surname: Value(update.surname),
          ),
        );
  }

  Person toModel(PersonData e) {
    return Person(
      id: e.id,
      birth: e.birth,
      created: e.created,
      email: e.email,
      identifier: e.identifier,
      name: e.name,
      phone: e.phone,
      profilePicture: e.profilePicture,
      surname: e.surname,
    );
  }
}
