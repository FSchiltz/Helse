import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helse/ui/common/loading_builder.dart';

void main() {
  testWidgets('shows loader while waiting', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(
      MaterialApp(
        home: LoadingBuilder<String>(
          (_) => completer.future,
          builder: (_, data, _) => Text(data),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LoadingBuilder<String>), findsOneWidget);
    expect(find.text('hello'), findsNothing);
  });

  testWidgets('renders loaded data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoadingBuilder<String>(
          (_) async => 'hello',
          builder: (_, data, _) => Text(data),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('reset reloads future', (tester) async {
    var calls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: LoadingBuilder<int>(
          (_) async {
            calls++;
            return calls;
          },
          builder: (_, data, reset) => Column(
            children: [
              Text('$data'),
              ElevatedButton(onPressed: reset, child: const Text('reload')),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('reload'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
  });
}
