import 'package:drift/drift.dart';

class Settings extends Table {
  IntColumn get id => integer()();
  TextColumn get currencySymbol => text().withDefault(const Constant('\$'))();
  IntColumn get sleepGoalMinutes =>
      integer().withDefault(const Constant(480))();
  // Minutes after midnight, e.g. 1380 = 23:00.
  IntColumn get targetBedtimeMinutes =>
      integer().withDefault(const Constant(1380))();

  @override
  Set<Column> get primaryKey => {id};
}

class SleepSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get sleepAt => dateTime()();
  DateTimeColumn get wakeAt => dateTime().nullable()();
  IntColumn get quality => integer().nullable()();
  TextColumn get note => text().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get budgetCents => integer().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountCents => integer()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMethod => text()();
  TextColumn get note => text().nullable()();
  TextColumn get item => text().nullable()();
  TextColumn get store => text().nullable()();
  DateTimeColumn get warrantyOrReturnBy => dateTime().nullable()();
  TextColumn get receiptPath => text().nullable()();
}
