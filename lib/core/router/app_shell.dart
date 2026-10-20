import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/pearl_colors.dart';

/// Branch indexes: 0 home (no tab), 1 sleep, 2 read.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final i = shell.currentIndex;
    return Scaffold(
      body: shell,
      // Frosted bar: translucent surface over a blur, with a top hairline.
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.module.withValues(alpha: 0.78),
              border: Border(top: BorderSide(color: c.hairline)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _Tab(
                      icon: Icons.bedtime_outlined,
                      label: 'Sleep',
                      selected: i == 1,
                      onTap: () => shell.goBranch(1, initialLocation: i == 1),
                    ),
                    const SizedBox(width: 8),
                    _Tab(
                      icon: Icons.menu_book_outlined,
                      label: 'Read',
                      selected: i == 2,
                      onTap: () => shell.goBranch(2, initialLocation: i == 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    final c = context.pearl;
    final color = selected ? c.onAnchor : c.muted;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: Pearl.motion,
            curve: Curves.easeOut,
            height: 48,
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: selected ? c.anchor : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
