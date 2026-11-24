import 'package:drift/drift.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/local/database/database.dart';

class LocalService {
  final Account account;

  LocalService(this.account);

  static Database? _database;
  Database get database => _database ??= Database();

  Future<void> markChanged() => database.markLocalChanges();

  Never onlineOnly() =>
      throw UnsupportedError(Translation.current.administrationOnlineOnly);

  void requireUserInitiatedOffline() {
    if (account.isEnabled(Account.offline) != true) {
      onlineOnly();
    }
  }

  Future<void> queueDeletion(
    String entity,
    int serverId, {
    int? relatedId,
  }) async {
    await database
        .into(database.pendingDeletion)
        .insert(
          PendingDeletionCompanion.insert(
            entity: entity,
            serverId: serverId,
            relatedId: Value(relatedId),
            created: DateTime.now().toUtc(),
          ),
        );
    await markChanged();
  }
}
