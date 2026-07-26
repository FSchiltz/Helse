import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/user_service.dart';

import '../swagger/generated_code/helseapi.swagger.dart';

class ApiUserService extends ApiService implements UserService {
  ApiUserService(super.account);

  @override
  Future<List<Person>?> persons() async {
    final api = await getService();
    return await call(api.apiPersonGet);
  }

  @override
  Future<UserId?> addPerson(PersonCreation person) async {
    final api = await getService();

    return await call(() => api.apiPersonPost(body: person));
  }

  @override
  Future<List<Person>?> patients() async {
    final api = await getService();
    return await call(api.apiPatientsGet);
  }

  @override
  Future<void> updatePerson(UpdatePerson update) async {
    final api = await getService();
    await call(() => api.apiPersonPut(body: update));
  }

  @override
  Future<void> deletePerson(int id) async {
    final api = await getService();
    await call(() => api.apiPersonUserIdDelete(userId: id));
  }

  @override
  Future<List<Person>> caregiver() async {
    final api = await getService();
    return await call<List<Person>>(api.apiPersonCaregiverGet) ?? [];
  }

  @override
  Future<void> updatePatient(UpdatePatient update) async {
    final api = await getService();
    await call(() => api.apiPatientsPut(body: update));
  }

  @override
  Future<void> sharePatient({
    required int patient,
    required int caregiver,
    required bool edit,
  }) async {
    final api = await getService();
    return await call(
      () => api.apiPatientsShareGet(
        patient: patient,
        caregiver: caregiver,
        edit: edit,
      ),
    );
  }

  @override
  Future<List<Session>> getSessions() async {
    final api = await getService();
    return (await call(api.apiSessionsGet)) ?? [];
  }

  @override
  Future<void> logout(bool all) async {
    final api = await getService(sendRefresh: !all);
    await call(api.apiLogoutGet);
  }
}
