import 'package:drift/drift.dart';

class Settings extends Table {
  IntColumn get id => integer()();
  TextColumn get currencySymbol => text().withDefault(const Constant('₹'))();
  IntColumn get sleepGoalMinutes =>
      integer().withDefault(const Constant(480))();
  // Minutes after midnight, e.g. 1380 = 23:00.
  IntColumn get targetBedtimeMinutes =>
      integer().withDefault(const Constant(1380))();
  BoolColumn get weeklyReportEnabled =>
      boolean().withDefault(const Constant(true))();
  // Minutes after midnight for the Sunday report notification, e.g. 1140 = 19:00.
  IntColumn get weeklyReportMinutes =>
      integer().withDefault(const Constant(1140))();
  // Minutes after midnight for Memories reminders, e.g. 540 = 09:00.
  IntColumn get memoryRemindMinutes =>
      integer().withDefault(const Constant(540))();
  BoolColumn get onThisDayEnabled =>
      boolean().withDefault(const Constant(false))();
  // Bedtime reminder fires this many minutes before the target bedtime.
  BoolColumn get bedtimeReminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get bedtimeReminderLeadMinutes =>
      integer().withDefault(const Constant(30))();
  // Daily "log today's expenses" reminder, minutes after midnight (21:00).
  BoolColumn get expenseReminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get expenseReminderMinutes =>
      integer().withDefault(const Constant(1260))();
  IntColumn get dailyPageGoal => integer().withDefault(const Constant(25))();

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

class Stocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().unique()();
  TextColumn get name => text()();
  IntColumn get lastPriceCents => integer().nullable()();
  DateTimeColumn get priceDate => dateTime().nullable()();
}

class Trades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get stockId => integer().references(Stocks, #id)();
  BoolColumn get isBuy => boolean()();
  DateTimeColumn get date => dateTime()();
  IntColumn get quantity => integer()();
  IntColumn get priceCents => integer()();
  IntColumn get feesCents => integer().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
}

class WeeklySnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Monday 00:00 of the week the snapshot belongs to.
  DateTimeColumn get weekStart => dateTime().unique()();
  IntColumn get investedCents => integer()();
  IntColumn get valueCents => integer()();
}

class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get author => text().withDefault(const Constant(''))();
  IntColumn get totalPages => integer().nullable()();
  // One of the names in reading_logic.dart's BookStatus.
  TextColumn get status => text().withDefault(const Constant('wantToRead'))();
  IntColumn get rating => integer().nullable()();
  TextColumn get coverPath => text().nullable()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
}

class ReadingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer().references(Books, #id)();
  DateTimeColumn get startAt => dateTime()();
  // Null while the timer is running, so it survives the app being closed.
  DateTimeColumn get endAt => dateTime().nullable()();
  IntColumn get endPage => integer().nullable()();
}

class ReadingNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer().references(Books, #id)();
  IntColumn get sessionId =>
      integer().nullable().references(ReadingSessions, #id)();
  TextColumn get body => text()();
  BoolColumn get isQuote => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class MemoryCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class MemoryEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  // 'occasion' repeats every year; 'oneTime' happened (or will happen) once.
  TextColumn get kind => text().withDefault(const Constant('oneTime'))();
  // How much of the date is known: 'day', 'month' or 'year'.
  TextColumn get precision => text().withDefault(const Constant('day'))();
  // Year may be null only for an occasion whose starting year is unknown.
  IntColumn get year => integer().nullable()();
  IntColumn get month => integer().nullable()();
  IntColumn get day => integer().nullable()();
  TextColumn get person => text().nullable()();
  IntColumn get categoryId => integer().references(MemoryCategories, #id)();
  TextColumn get place => text().nullable()();
  TextColumn get description => text().nullable()();
  // Media id chosen as cover; null means the first photo.
  IntColumn get coverMediaId => integer().nullable()();
  BoolColumn get remindOnDay => boolean().withDefault(const Constant(false))();
  // Comma-separated days before, from {1, 3, 7}, e.g. "1,7".
  TextColumn get remindDaysBefore => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('MemoryMediaItem')
class MemoryMedia extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(MemoryEvents, #id)();
  TextColumn get path => text()();
  BoolColumn get isVideo => boolean().withDefault(const Constant(false))();
  TextColumn get thumbPath => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
}

class Trackers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // Key into the icon list in tracker_icons.dart.
  TextColumn get icon => text().withDefault(const Constant('star'))();
  // 'habit' (daily yes/no) or 'duration' (start/stop timer).
  TextColumn get type => text().withDefault(const Constant('habit'))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  // Daily reminder time in minutes after midnight; null means no reminder.
  IntColumn get reminderMinutes => integer().nullable()();
}

class TrackerEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackerId => integer().references(Trackers, #id)();
  // Local calendar day (midnight) the entry belongs to.
  DateTimeColumn get day => dateTime()();
  // Duration entries only; endAt is null while the timer runs.
  DateTimeColumn get startAt => dateTime().nullable()();
  DateTimeColumn get endAt => dateTime().nullable()();
}

class RecurringExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountCents => integer()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get paymentMethod => text()();
  TextColumn get note => text().nullable()();
  TextColumn get item => text().nullable()();
  TextColumn get store => text().nullable()();
  // 'weekly', 'monthly' or 'yearly'.
  TextColumn get frequency => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get startDate => dateTime()();
  // Last date an expense was created for; null before the first one.
  DateTimeColumn get lastGeneratedDate => dateTime().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
