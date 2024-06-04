import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class UserService extends ApiService {
  UserService(super.account);

  Future<List<Person>?> persons() async {
    var api = await getService();
    return await call(api.apiPersonGet);
  }

  Future<void> addPerson(PersonCreation person) async {
    var api = await getService();

    await call(() => api.apiPersonPost(body: person));
  }

  Future<List<Person>?> patients() async {
    var api = await getService();
    return await call(api.apiPatientsGet);
  }

  Future<void> updatePersonRole(int personId, UserType type) async {
    var api = await getService();
    var role = type.value ?? 0;
    await call(() => api.apiPersonRolePost(personId: personId, role: role.toString()));
  }

  Future<List<Person>> caregiver() async {
    var api = await getService();
    return await call(api.apiPersonCaregiverGet) ?? [];
  }

  Future<void> sharePatient({required int patient, required int caregiver, required bool edit }) async {

    var api = await getService();
    return await call(() => api.apiPatientsShareGet(patient: patient, caregiver: caregiver, edit: edit));
  }
}
