import 'package:helse/services/api_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LoginService extends ApiService {
  LoginService(super.account);
  Future<ConnectionResponse?> login(Connection connection) async {
    var api = await getService();
    var response = await api.apiAuthPost(body: connection);

    switch (response.statusCode) {
      case 401:
        throw ArgumentError("Incorrect username or password");
      case 200:
        return response.body;
      default:
        throw StateError(response.error?.toString() ?? "Error");
    }
  }
}
