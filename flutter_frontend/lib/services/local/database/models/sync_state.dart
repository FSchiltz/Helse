import 'package:drift/drift.dart';

class SyncState extends Table {
  IntColumn get id => integer()();
  BoolColumn get hasChanges => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
