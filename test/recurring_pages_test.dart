import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/features/money/recurring_repository.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets(
    'due recurring expenses are added on start and the rule is listed',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final now = DateTime.now();
      await tester.runAsync(
        () => RecurringRepository(db).add(
          RecurringExpensesCompanion.insert(
            amountCents: 4500,
            categoryId: 1,
            paymentMethod: 'Card',
            startDate: DateTime(now.year, now.month - 2, 1),
            note: const Value('Gym'),
          ),
        ),
      );
      appRouter.go('/');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const TrackerApp(),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      await _settle(tester);
      await _settle(tester);

      final expenses = await tester.runAsync(
        () => db.select(db.expenses).get(),
      );
      expect(expenses, hasLength(3));
      expect(expenses!.every((e) => e.amountCents == 4500), isTrue);

      appRouter.go('/money/recurring');
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.textContaining('Monthly'), findsOneWidget);
      expect(find.textContaining('Gym'), findsOneWidget);
      expect(find.textContaining('next'), findsOneWidget);

      // Still exactly three after everything settled (no double generation).
      final again = await tester.runAsync(() => db.select(db.expenses).get());
      expect(again, hasLength(3));

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(db.close);
    },
  );
}
