import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class UserService extends ApiService {
  UserService(super.account);

  Future<List<Person>?> persons() async {
    var api = await getService();
    return await call(api.apiPersonGet);
  }

  Future<void> addPerson(PersonCreation person) async {
    var api = await getService();

    await call<void>(() => api.apiPersonPost(body: person));
  }

  Future<List<Person>?> patients() async {
    var api = await getService();
    return await call(api.apiPatientsGet);
  }

  Future<void> updatePerson(UpdatePerson update) async {
    var api = await getService();
    await call<void>(() => api.apiPersonPut(body: update));
  }

  Future<void> deletePerson(int id) async {
    var api = await getService();
    await call<void>(() => api.apiPersonPersonIdDelete(userId: id));
  }

  Future<List<Person>> caregiver() async {
    var api = await getService();
    return await call<List<Person>>(api.apiPersonCaregiverGet) ?? [];
  }

  Future<void> updatePatient(UpdatePatient update) async {
    var api = await getService();
    await call<void>(() => api.apiPatientsPut(body: update));
  }

  Future<void> sharePatient({
    required int patient,
    required int caregiver,
    required bool edit,
  }) async {
    var api = await getService();
    return await call(
      () => api.apiPatientsShareGet(
        patient: patient,
        caregiver: caregiver,
        edit: edit,
      ),
    );
  }
}
