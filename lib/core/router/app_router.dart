import 'package:go_router/go_router.dart';

import '../../features/dashboard/dashboard_page.dart';
import '../../features/money/categories_page.dart';
import '../../features/money/expense_form_page.dart';
import '../../features/money/money_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/sleep/sleep_edit_page.dart';
import '../../features/sleep/sleep_page.dart';
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
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sleep',
              builder: (_, _) => const SleepPage(),
              routes: [
                GoRoute(
                  path: 'edit/:id',
                  builder: (_, state) =>
                      SleepEditPage(id: int.parse(state.pathParameters['id']!)),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/money',
              builder: (_, _) => const MoneyPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (_, _) => const ExpenseFormPage(),
                ),
                GoRoute(
                  path: 'edit/:id',
                  builder: (_, state) => ExpenseFormPage(
                    id: int.parse(state.pathParameters['id']!),
                  ),
                ),
                GoRoute(
                  path: 'categories',
                  builder: (_, _) => const CategoriesPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
