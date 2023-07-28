import 'package:helse/services/swagger_generated_code/swagger.swagger.dart';

import '../../services/account.dart';
import '../../services/api_service.dart';

class ImportLogic {
  final Account _account;

  ImportLogic(Account account) : _account = account;

  Future<List<FileType>?> getType() async {
    return await ApiService(_account).fileType();
  }

  Future<void> import(String? file, int type) async {
    return await ApiService(_account).import(file, type);
  }
}
