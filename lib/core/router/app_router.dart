import 'package:go_router/go_router.dart';

import '../../features/dashboard/dashboard_page.dart';
import '../../features/memories/calendar_page.dart';
import '../../features/memories/event_detail_page.dart';
import '../../features/memories/event_form_page.dart';
import '../../features/memories/media_viewer_page.dart';
import '../../features/memories/memories_page.dart';
import '../../features/memories/search_page.dart';
import '../../features/reading/book_form_page.dart';
import '../../features/reading/book_page.dart';
import '../../features/reading/reading_page.dart';
import '../../features/reading/reading_stats_page.dart';
import '../../features/settings/reminders_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/trackers/tracker_detail_page.dart';
import '../../features/trackers/tracker_form_page.dart';
import '../../features/trackers/trackers_page.dart';
import '../../features/sleep/sleep_edit_page.dart';
import '../../features/sleep/sleep_page.dart';
import '../../features/sleep/sleep_charts_page.dart';
import '../../features/reading/reading_charts_page.dart';
import 'app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const DashboardPage(),
              routes: [
                GoRoute(
                  path: 'settings',
                  builder: (_, _) => const SettingsPage(),
                  routes: [
                    GoRoute(
                      path: 'reminders',
                      builder: (_, _) => const RemindersPage(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'trackers',
                  builder: (_, _) => const TrackersPage(),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (_, _) => const TrackerFormPage(),
                    ),
                    GoRoute(
                      path: 'edit/:id',
                      builder: (_, state) => TrackerFormPage(
                        id: int.parse(state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (_, state) => TrackerDetailPage(
                        id: int.parse(state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'sleep',
                  builder: (_, _) => const SleepPage(),
                  routes: [
                    GoRoute(
                      path: 'charts',
                      builder: (_, _) => const SleepChartsPage(),
                    ),
                    GoRoute(
                      path: 'edit/:id',
                      builder: (_, state) => SleepEditPage(
                        id: int.parse(state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/memories',
              builder: (_, _) => const MemoriesPage(),
              routes: [
                GoRoute(path: 'add', builder: (_, _) => const EventFormPage()),
                GoRoute(
                  path: 'edit/:id',
                  builder: (_, state) =>
                      EventFormPage(id: int.parse(state.pathParameters['id']!)),
                ),
                GoRoute(
                  path: 'calendar',
                  builder: (_, _) => const CalendarPage(),
                ),
                GoRoute(path: 'search', builder: (_, _) => const SearchPage()),
                GoRoute(
                  path: 'viewer/:id',
                  builder: (_, state) => MediaViewerPage(
                    eventId: int.parse(state.pathParameters['id']!),
                    initialIndex:
                        int.tryParse(
                          state.uri.queryParameters['index'] ?? '',
                        ) ??
                        0,
                  ),
                ),
                GoRoute(
                  path: 'event/:id',
                  builder: (_, state) => EventDetailPage(
                    id: int.parse(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/read',
              builder: (_, _) => const ReadingPage(),
              routes: [
                GoRoute(path: 'edit', builder: (_, _) => const BookFormPage()),
                GoRoute(
                  path: 'edit/:id',
                  builder: (_, state) =>
                      BookFormPage(id: int.parse(state.pathParameters['id']!)),
                ),
                GoRoute(
                  path: 'stats',
                  builder: (_, _) => const ReadingStatsPage(),
                ),
                GoRoute(
                  path: 'charts',
                  builder: (_, _) => const ReadingChartsPage(),
                ),
                GoRoute(
                  path: 'book/:id',
                  builder: (_, state) =>
                      BookPage(id: int.parse(state.pathParameters['id']!)),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
