import 'package:flutter_test/flutter_test.dart';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/services/account.dart';

void main() {
  final logic = AuthenticationLogic(Account());

  group('normalizeServerUrl', () {
    test('trims whitespace and adds https to a host', () {
      expect(logic.normalizeServerUrl(' example.com '), 'https://example.com');
    });

    test('preserves explicit http and https schemes', () {
      expect(
        logic.normalizeServerUrl(' http://example.com '),
        'http://example.com',
      );
      expect(
        logic.normalizeServerUrl('https://example.com'),
        'https://example.com',
      );
    });

    test('keeps an empty URL empty', () {
      expect(logic.normalizeServerUrl('  '), isEmpty);
    });
  });

  test(
    'checkUrl rejects non-absolute, hostless, and unsupported URLs',
    () async {
      for (final url in [
        '',
        '/relative/path',
        'https://',
        'ftp://example.com',
      ]) {
        await expectLater(logic.checkUrl(url), throwsA(isA<FormatException>()));
      }
    },
  );
}
