import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../investing/invest_card.dart';
import '../money/spend_card.dart';
import '../reading/reading_card.dart';
import '../sleep/last_night_card.dart';
import '../sleep/sleep_toggle_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Aura.margin),
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon/splash_logo.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text('Events', style: text.headlineMedium)),
                IconButton(
                  tooltip: 'Memories',
                  onPressed: () => context.push('/memories'),
                  icon: const Icon(Icons.cake_outlined),
                ),
                IconButton(
                  tooltip: 'Settings',
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SleepToggleCard(),
            const SizedBox(height: 12),
            const LastNightCard(),
            const SizedBox(height: 12),
            const SpendCard(),
            const SizedBox(height: 12),
            const InvestCard(),
            const SizedBox(height: 12),
            const ReadingCard(),
            const SizedBox(height: 12),
            PillButton(
              label: 'Add expense',
              icon: Icons.add,
              color: Aura.money,
              onPressed: () => context.push('/money/add'),
            ),
          ],
        ),
      ),
    );
  }
}
