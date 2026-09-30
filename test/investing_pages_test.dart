import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/theme/app_theme.dart';
import 'package:events_tracker/features/investing/investing_repository.dart';
import 'package:events_tracker/features/investing/trade_form_page.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<AppDatabase> _seed(WidgetTester tester) async {
  final db = AppDatabase(NativeDatabase.memory());
  await tester.runAsync(() async {
    final repo = InvestingRepository(db);
    final id = await repo.addStock('AAPL', 'Apple');
    await repo.addTrade(
      TradesCompanion.insert(
        stockId: id,
        isBuy: true,
        date: DateTime.now().subtract(const Duration(days: 30)),
        quantity: 10,
        priceCents: 1000,
      ),
    );
    await repo.setPrice(id, 1200, DateTime.now());
  });
  return db;
}

Future<void> _teardown(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(db.close);
}

void main() {
  testWidgets('Invest tab shows portfolio totals and the holding', (
    tester,
  ) async {
    final db = await _seed(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const TrackerApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2)); // splash
    await tester.tap(find.text('Invest'));
    await tester.pump(const Duration(milliseconds: 300));
    // Let the database streams deliver in real time, then rebuild.
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('AAPL'), findsOneWidget);
    expect(find.text('₹120.00'), findsWidgets); // value 10 x 12.00
    expect(find.text('₹100.00'), findsOneWidget); // invested
    expect(find.text('+₹20.00'), findsOneWidget); // unrealized
    await _teardown(tester, db);
  });

  testWidgets(
    'sell form previews profit and days held, and flags overselling',
    (tester) async {
      final db = await _seed(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: auraTheme,
            home: const TradeFormPage(stockId: 1, sell: true),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.widgetWithText(TextField, 'Shares'), '4');
      await tester.enterText(
        find.widgetWithText(TextField, 'Price each'),
        '15',
      );
      await tester.pump();
      expect(find.text('THIS SALE'), findsOneWidget);
      expect(find.text('+₹20.00'), findsOneWidget); // 4 x (15 - 10)
      expect(find.text('Held 30 days'), findsOneWidget);
      expect(find.text('Short-term'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Shares'), '11');
      await tester.pump();
      expect(
        find.text('You do not hold that many shares on this date.'),
        findsOneWidget,
      );
      expect(find.text('THIS SALE'), findsNothing);
      await _teardown(tester, db);
    },
  );
}
