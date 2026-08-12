import 'package:helse/services/local/database/database.dart';

class LocalService {
  static Database? _database;
  Database get database => _database ??= Database();
}
