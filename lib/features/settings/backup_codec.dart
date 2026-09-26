import 'dart:convert';

import 'package:drift/drift.dart' show ValueSerializer;

import '../../core/db/app_database.dart';

const backupFormat = 'events-tracker-backup';
const backupVersion = 1;

class BackupData {
  const BackupData({
    required this.settings,
    required this.sleepSessions,
    required this.categories,
    required this.expenses,
  });

  final Setting settings;
  final List<SleepSession> sleepSessions;
  final List<Category> categories;
  final List<Expense> expenses;
}

String backupToJson(BackupData d) =>
    const JsonEncoder.withIndent('  ').convert({
      'format': backupFormat,
      'version': backupVersion,
      'settings': d.settings.toJson(),
      'sleepSessions': [for (final r in d.sleepSessions) r.toJson()],
      'categories': [for (final r in d.categories) r.toJson()],
      'expenses': [for (final r in d.expenses) r.toJson()],
    });

/// Parses a backup file. Throws [FormatException] if it is not a valid backup.
BackupData backupFromJson(String source) {
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException {
    throw const FormatException('Not a JSON file');
  }
  if (decoded is! Map<String, dynamic> || decoded['format'] != backupFormat) {
    throw const FormatException('This is not a tracker backup file');
  }
  final raw = decoded;
  if (raw['version'] != backupVersion) {
    throw FormatException('Unsupported backup version ${raw['version']}');
  }
  try {
    List<T> rows<T>(String key, T Function(Map<String, dynamic>) f) => [
      for (final r in raw[key] as List) f(r as Map<String, dynamic>),
    ];
    return BackupData(
      settings: Setting.fromJson(raw['settings'] as Map<String, dynamic>),
      sleepSessions: rows('sleepSessions', SleepSession.fromJson),
      categories: rows('categories', Category.fromJson),
      expenses: rows('expenses', Expense.fromJson),
    );
  } on TypeError {
    throw const FormatException('Backup file is damaged');
  }
}

/// One CSV per table, keyed by file name. Dates are written as ISO-8601 text.
Map<String, String> backupToCsv(BackupData d) {
  const s = ValueSerializer.defaults(serializeDateTimeValuesAsString: true);
  return {
    'sleep_sessions.csv': _csv([
      for (final r in d.sleepSessions) r.toJson(serializer: s),
    ]),
    'categories.csv': _csv([
      for (final r in d.categories) r.toJson(serializer: s),
    ]),
    'expenses.csv': _csv([for (final r in d.expenses) r.toJson(serializer: s)]),
  };
}

String _csv(List<Map<String, dynamic>> rows) {
  if (rows.isEmpty) return '';
  final headers = rows.first.keys.toList();
  return [
    headers.join(','),
    for (final r in rows) headers.map((h) => _cell(r[h])).join(','),
  ].join('\n');
}

String _cell(Object? v) {
  if (v == null) return '';
  final s = '$v';
  return s.contains(RegExp(r'[",\n\r]')) ? '"${s.replaceAll('"', '""')}"' : s;
}
