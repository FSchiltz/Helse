import 'package:helse/services/api_service.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

class LoginService extends ApiService {
  LoginService(super.account);
  Future<TokenResponse?> login(String username, String password, String? redirect) async {
    var api = await getService();
    var response = await api.apiAuthPost(body: Connection(user: username, password: password, redirect: redirect));

    switch (response.statusCode) {
      case 401:
        throw Exception("Incorrect username or password");
      case 200:
        return response.body;
      default:
        throw Exception(response.error ?? "Error");
    }
  }
}
