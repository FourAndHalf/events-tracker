import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
import '../memories/memory_card.dart';
import '../reading/reading_card.dart';
import '../sleep/last_night_card.dart';
import '../sleep/sleep_toggle_card.dart';
import '../trackers/tracker_card.dart';

/// "Good morning" / "Good afternoon" / "Good evening" for [now].
String greetingFor(DateTime now) => now.hour < 12
    ? 'Good morning'
    : now.hour < 17
    ? 'Good afternoon'
    : 'Good evening';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Pearl.margin),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greetingFor(now), style: text.headlineMedium),
                      Text(
                        DateFormat('EEEE d MMMM').format(now),
                        style: text.bodyMedium?.copyWith(
                          color: context.pearl.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                PearlIconButton(
                  tooltip: 'Sleep',
                  onPressed: () => context.push('/sleep'),
                  icon: Icons.bedtime_outlined,
                ),
                const SizedBox(width: 8),
                PearlIconButton(
                  tooltip: 'Settings',
                  onPressed: () => context.push('/settings'),
                  icon: Icons.settings_outlined,
                ),
              ],
            ),
            const SizedBox(height: Pearl.spaceLg),
            const SleepToggleCard(hero: true),
            const SizedBox(height: Pearl.gutter),
            const LastNightCard(),
            const SizedBox(height: Pearl.gutter),
            const TrackerCard(),
            const SizedBox(height: Pearl.gutter),
            const ReadingCard(),
            const SizedBox(height: Pearl.gutter),
            const MemoryCard(),
          ],
        ),
      ),
    );
  }
}
