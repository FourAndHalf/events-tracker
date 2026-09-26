import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/aura_colors.dart';

/// Branch indexes: 0 home (no tab), 1 sleep, 2 money.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final i = shell.currentIndex;
    return Scaffold(
      body: shell,
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            _Tab(
              icon: Icons.bedtime,
              label: 'Sleep',
              selected: i == 1,
              onTap: () => shell.goBranch(1, initialLocation: i == 1),
            ),
            _Tab(
              icon: Icons.payments,
              label: 'Money',
              selected: i == 2,
              onTap: () => shell.goBranch(2, initialLocation: i == 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Aura.text : Aura.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: selected ? Aura.raised : Colors.transparent,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
