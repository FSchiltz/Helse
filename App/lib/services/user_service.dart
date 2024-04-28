import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class UserService extends ApiService {
  UserService(super.account);

  Future<List<Person>?> persons() async {
    var api = await getService();
    return await call(api.apiPersonGet);
  }

  Future<String?> login(String username, String password) async {
    var api = await getService();
    var response = await api.apiAuthPost(body: Connection(user: username, password: password));

    return response.isSuccessful ? response.bodyString : null;
  }

  Future<void> addPerson(PersonCreation person) async {
    var api = await getService();

    await call(() => api.apiPersonPost(body: person));
  }

  Future<List<Person>?> patients() async {
    var api = await getService();
    return await call(api.apiPatientsGet);
  }
}