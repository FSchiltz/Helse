import '../swagger_generated_code/swagger.swagger.dart';

class Service {
  Service(String baseUrl) : _api = Swagger.create(baseUrl: Uri.parse(baseUrl));

  final Swagger _api;

  Future<String?> login(String username, String password) async {
    var response = await _api.authPost(body: Connection(user: username, password: password));
    return response.isSuccessful ? response.bodyString : null;
  }
}
