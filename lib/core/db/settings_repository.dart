import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'providers.dart';

final settingsProvider = StreamProvider<Setting>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.settings)..where((s) => s.id.equals(1))).watchSingle();
});

Future<void> updateSettings(AppDatabase db, SettingsCompanion changes) =>
    (db.update(db.settings)..where((s) => s.id.equals(1))).write(changes);
