import 'package:drift/drift.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/services/user_service.dart';

class LocalUserService extends LocalService implements UserService {
  LocalUserService(super.account);

  @override
  Future<UserId?> addPerson(PersonCreation person) async {
    if (person.userName?.trim().isNotEmpty == true ||
        person.password?.isNotEmpty == true ||
        person.types?.any((type) => type != UserType.patient) == true) {
      throw UnsupportedError(
        Translation.current.peopleWithCredentialsOnlineOnly,
      );
    }

    final newRow = await database
        .into(database.person)
        .insertReturning(
          PersonCompanion.insert(
            identifier: person.identifier ?? '',
            name: Value(person.name),
            birth: Value(person.birth),
            email: Value(person.email),
            phone: Value(person.phone),
            surname: Value(person.surname),
            profilePicture: Value(person.profilePicture),
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
    onlineOnly();
  }

  @override
  Future<List<Session>> getSessions() async {
    return [];
  }

  @override
  Future<void> logout(bool all) async {}

  @override
  Future<List<Person>?> patients() async {
    final result = await (database.select(
      database.person,
    )..where((e) => e.types.contains(UserType.patient.name))).get();

    return result.map(toModel).toList();
  }

  @override
  Future<String?> patientProfilePicture(int patient) async {
    final result = await (database.select(
      database.person,
    )..where((e) => e.id.equals(patient))).getSingleOrNull();
    return result?.profilePicture;
  }

  @override
  Future<List<Person>?> persons() async {
    final result = await database.select(database.person).get();

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
    await (database.update(
      database.person,
    )..where((person) => person.id.equals(update.id!))).write(
      PersonCompanion(
        id: Value(update.id!),
        identifier: Value(update.identifier!),
        birth: Value(update.birth),
        name: Value(update.name),
        profilePicture: Value(update.profilePicture),
        surname: Value(update.surname),
        synced: const Value(false),
      ),
    );
  }

  @override
  Future<void> updatePerson(UpdatePerson update) async {
    onlineOnly();
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
      surname: e.surname,
      types: e.types
          ?.split(';')
          .map((type) => UserType.values.asNameMap()[type])
          .whereType<UserType>()
          .toList(),
    );
  }
}
