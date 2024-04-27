import 'dart:async';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../services/api_service.dart';
import '../../services/account.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// Authentication logic
/// TODO Add refresh token support
class AuthenticationLogic {
  final _controller = StreamController<AuthenticationStatus>();
  final Account _account;

  AuthenticationLogic(Account account) : _account = account;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  /// Check if the user is logged in
  Future<void> checkLogin() async {
    var token = await _account.getToken();
    if (token != null && token.isNotEmpty) _controller.add(AuthenticationStatus.authenticated);
  }

  /// Call the login service
  Future<void> logIn({required String url, required String username, required String password}) async {
    await _account.setUrl(url);
    var token = await ApiService(_account).login(username, password);
    if (token != null) {
      var cleaned = token.replaceAll('"', "");
      await _account.setToken(cleaned);

      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  Future<List<Person>> getUsers() async {
    return (await ApiService(_account).getUsers()) ?? [];
  }

  Future<Person> getUser() async {
    var token = await getToken();
    if (token == null) throw Exception("Not connected");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var data = decodedToken["roles"];
    if (data == null) return const Person(type: UserType.swaggerGeneratedUnknown);

    var name = decodedToken["name"];
    if(name?.isEmpty ?? true) name = null;

    var surname = decodedToken["surname"];

    if(surname?.isEmpty ?? true) surname = null;

    // the enum start at 0 so we add 1
    UserType role = UserType.values[int.parse(data) + 1];
    return Person(type: role, name: name, surname: surname);
  }

  /// Init the account for a first connection
  Future<void> initAccount({required String url, required PersonCreation person}) async {
    await _account.setUrl(url);
    await ApiService(_account).createAccount(person);
  }

  Future<void> createAccount({required PersonCreation person}) {
    return ApiService(_account).createAccount(person);
  }

  Future<Status?> isInit(String url) async {
    return await ApiService(_account).isInit(url);
  }

  /// Call the logout service
  void logOut() {
    _account.removeToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  /// Get the current token
  Future<String?> getToken() {
    return _account.getToken();
  }
}
