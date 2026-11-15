import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/account.dart';
import 'package:helse/ui/login.dart';

class _TestAccount extends Account {
  @override
  String? get(String name) => null;
}

void main() {
  testWidgets('shows an error for a hostless server URL', (tester) async {
    await Dependencies.init(account: _TestAccount());

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginPage(),
      ),
    );

    final urlField = find.byKey(const Key('loginForm_urlInput_textField'));
    await tester.enterText(urlField, 'http://');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Invalid url'), findsOneWidget);
  });
}
