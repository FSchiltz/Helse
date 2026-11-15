import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/account.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  test(
    'clear preserves the saved URL and removes other account data',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({
            Account.url: 'https://example.com',
            Account.refresh: 'refresh-token',
          });
      final account = Account();
      await account.setup();

      await account.clear();

      expect(account.get(Account.url), 'https://example.com');
      expect(account.get(Account.refresh), isNull);
    },
  );
}
