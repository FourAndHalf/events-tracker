import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/settings_repository.dart';
import '../../core/notifications/report_notifier.dart';
import 'investing_repository.dart';
import 'portfolio_provider.dart';
import 'weekly_report.dart';

/// Keeps this week's snapshot (invested amount and portfolio value) up to date.
/// The last write of a week is what the week-on-week comparison uses.
final snapshotWriterProvider = Provider<void>((ref) {
  final trades = ref.watch(tradesProvider).value;
  if (trades == null || trades.isEmpty) return;
  final snap = snapshotNow(ref.watch(portfolioProvider), DateTime.now());
  unawaited(
    ref
        .read(investingRepositoryProvider)
        .upsertSnapshot(snap.weekStart, snap.investedCents, snap.valueCents)
        .catchError((Object e) => debugPrint('Snapshot not saved: $e')),
  );
});

/// Schedules the next Sunday notification with headline numbers as they are now.
/// Runs again after every change, so the text follows the data.
final reportSchedulerProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final stocks = ref.watch(stocksProvider).value;
  final trades = ref.watch(tradesProvider).value;
  final snapshots = ref.watch(snapshotsProvider).value;
  if (settings == null ||
      stocks == null ||
      trades == null ||
      snapshots == null) {
    return;
  }
  final notifier = ref.read(reportNotifierProvider);

  if (!settings.weeklyReportEnabled || trades.isEmpty) {
    unawaited(notifier.cancel());
    return;
  }
  final when = nextReportTime(DateTime.now(), settings.weeklyReportMinutes);
  final report = buildWeeklyReport(
    weekStart: weekStartOf(when),
    stocks: stocks,
    trades: trades,
    snapshots: snapshots,
    today: when,
    liveValueCents: ref.watch(portfolioProvider).valueCents,
  );
  unawaited(
    notifier.schedule(
      when,
      'Your investing week',
      weeklyHeadline(report, settings.currencySymbol),
    ),
  );
});
