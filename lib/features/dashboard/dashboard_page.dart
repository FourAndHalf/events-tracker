import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../money/spend_card.dart';
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
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()).toUpperCase(),
              style: text.labelSmall,
            ),
            const SizedBox(height: 4),
            Text('Today', style: text.headlineMedium),
            const SizedBox(height: 20),
            const SleepToggleCard(),
            const SizedBox(height: 12),
            const LastNightCard(),
            const SizedBox(height: 12),
            const SpendCard(),
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
