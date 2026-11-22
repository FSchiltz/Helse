import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/local/database/database.dart';

void main() {
  test('persists offline file bytes in the local database', () async {
    final database = Database(NativeDatabase.memory());
    addTearDown(database.close);
    final bytes = Uint8List.fromList([0, 1, 2, 255]);

    final id = await database
        .into(database.file)
        .insert(
          FileCompanion.insert(
            type: 'none',
            dataType: 'application/octet-stream',
            name: 'attachment.bin',
            description: '',
            start: DateTime.utc(2026),
            valid: true,
            person: 0,
            created: DateTime.utc(2026),
            content: Value(bytes),
          ),
        );

    final file = await (database.select(
      database.file,
    )..where((row) => row.id.equals(id))).getSingle();

    expect(file.content, orderedEquals(bytes));
  });
}
