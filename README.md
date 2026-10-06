# Events Tracker

Events Tracker is a private, offline-first Android app for keeping the parts of daily life that are easiest to forget in one place: sleep, spending, reading, investments, memories, and personal habits.

It stores data locally in SQLite through Drift. There is no cloud account or automatic data sync. Backups can be exported manually as JSON/CSV, with an optional ZIP backup for photos and videos.

## Daily use

The app is designed around a simple daily loop:

- **Morning:** review the dashboard, finish the previous sleep session, and see sleep duration and goal status.
- **During the day:** log expenses as they happen, including categories, payment methods, notes, purchase details, receipts, budgets, and recurring payments.
- **Reading time:** start a book timer, stop it when finished, record the page reached, and attach notes or quotes to the session.
- **Habits and routines:** use custom daily yes/no trackers or duration timers, with streaks, history, reminders, and dashboard quick actions.
- **Investing:** record trades manually, update prices by hand, and review holdings, FIFO-based realized P/L, unrealized P/L, charts, and weekly reports.
- **Memories:** save birthdays, anniversaries, milestones, trips, and one-time events with approximate dates, reminders, photos, and videos.
- **Evening:** check the dashboard and charts to understand spending, reading progress, sleep, and routines without relying on a separate service.

## Main sections

- **Home:** Today dashboard with quick actions and summaries.
- **Sleep:** start/wake controls, sleep goals, quality, history, charts, and reminders.
- **Money:** expenses, budgets, categories, receipts, recurring expenses, and charts.
- **Invest:** stocks, trades, prices, portfolio calculations, journal, weekly reports, and charts.
- **Read:** book library, reading timers, page progress, notes, ratings, statistics, and charts.
- **Memories:** events, calendar, search, media, reminders, and “on this day” prompts.
- **Trackers:** custom habits and duration-based routines with streaks and reminders.

## Convenience features

- Android home-screen widget for sleep, reading, and expense actions.
- Local notifications for reminders and weekly reports.
- Manual JSON/CSV export and import.
- ZIP backup and restore for database data plus memory media.
- Receipts, book covers, photos, and videos are copied into app-managed storage.

## Development

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

Generated Drift code can be refreshed with:

```bash
dart run build_runner build --delete-conflicting-outputs
```
