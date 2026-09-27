import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Route opened when the weekly report notification is tapped.
const reportRoute = '/invest/weekly';

abstract class ReportNotifier {
  /// Replaces any scheduled report with one at [when].
  Future<void> schedule(DateTime when, String title, String body);
  Future<void> cancel();

  /// Schedules one notification with its own [id] (1 is the weekly report).
  /// Tapping it opens [route].
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required String route,
  });

  /// Schedules a notification that repeats every day at [minutes] after midnight.
  Future<void> scheduleDaily({
    required int id,
    required int minutes,
    required String title,
    required String body,
    required String route,
  });

  /// Cancels every pending notification whose id is in [from, to).
  Future<void> cancelRange(int from, int to);

  /// Asks for the Android 13+ notification permission. True if granted.
  Future<bool> requestPermission();
}

/// Real implementation on flutter_local_notifications. Every call is wrapped so a
/// notification problem can never crash the app (and so tests without the plugin still run).
class LocalReportNotifier implements ReportNotifier {
  LocalReportNotifier._();
  static final instance = LocalReportNotifier._();

  static const _id = 1;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Sets up the plugin. [onTap] receives the route when a notification is tapped.
  /// Returns the route if the app was cold-started by tapping the notification.
  Future<String?> init(void Function(String route) onTap) async {
    try {
      tz_data.initializeTimeZones();
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (r) {
          final route = r.payload;
          if (route != null && route.isNotEmpty) onTap(route);
        },
      );
      _ready = true;
      final launch = await _plugin.getNotificationAppLaunchDetails();
      return launch?.didNotificationLaunchApp == true
          ? launch?.notificationResponse?.payload
          : null;
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
      return null;
    }
  }

  @override
  Future<void> schedule(DateTime when, String title, String body) async {
    if (!_ready) return;
    try {
      await _plugin.zonedSchedule(
        id: _id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'weekly_report',
            'Weekly investing report',
            channelDescription: 'Sunday-evening summary of your investing week',
            importance: Importance.defaultImportance,
          ),
        ),
        // Inexact: no special "alarms" permission needed; may arrive a little late.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: reportRoute,
      );
    } catch (e) {
      debugPrint('Could not schedule report: $e');
    }
  }

  @override
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required String route,
  }) async {
    if (!_ready) return;
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'memories',
            'Memories and important dates',
            channelDescription:
                'Reminders for birthdays, anniversaries and memories',
            importance: Importance.defaultImportance,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: route,
      );
    } catch (e) {
      debugPrint('Could not schedule reminder $id: $e');
    }
  }

  @override
  Future<void> scheduleDaily({
    required int id,
    required int minutes,
    required String title,
    required String body,
    required String route,
  }) async {
    if (!_ready) return;
    try {
      final now = tz.TZDateTime.now(tz.local);
      var first = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        minutes ~/ 60,
        minutes % 60,
      );
      if (!first.isAfter(now)) first = first.add(const Duration(days: 1));
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: first,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminders',
            'Daily reminders',
            channelDescription: 'Bedtime, expenses and tracker reminders',
            importance: Importance.defaultImportance,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: route,
      );
    } catch (e) {
      debugPrint('Could not schedule daily reminder $id: $e');
    }
  }

  @override
  Future<void> cancelRange(int from, int to) async {
    if (!_ready) return;
    try {
      for (final n in await _plugin.pendingNotificationRequests()) {
        if (n.id >= from && n.id < to) await _plugin.cancel(id: n.id);
      }
    } catch (e) {
      debugPrint('Could not cancel reminders: $e');
    }
  }

  @override
  Future<void> cancel() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _id);
    } catch (e) {
      debugPrint('Could not cancel report: $e');
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }
}

final reportNotifierProvider = Provider<ReportNotifier>(
  (_) => LocalReportNotifier.instance,
);
