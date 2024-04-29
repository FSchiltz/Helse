import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class UserService extends ApiService {
  UserService(super.account);

  Future<List<Person>?> persons() async {
    var api = await getService();
    return await call(api.apiPersonGet);
  }

  Future<String> login(String username, String password, String? redirect) async {
    var api = await getService();
    var response = await api.apiAuthPost(body: Connection(user: username, password: password, redirect: redirect));

    switch (response.statusCode) {
      case 401:
        throw Exception("Incorrect username or password");
    }

    return response.isSuccessful ? response.bodyString : throw Exception(response.error ?? "Error");
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
}
